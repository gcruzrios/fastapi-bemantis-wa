from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from database import get_db
from models.contact import Contact
from models.invoice import Invoice, InvoiceItem, InvoiceStatus
from models.service import Service
from models.usuario import Usuario
from routers.auth import get_current_user
from routers.config import get_or_create_config
from schemas.invoice import (
    InvoiceCreate,
    InvoiceItemCreate,
    InvoiceItemUpdate,
    InvoiceResponse,
    InvoiceStatusUpdate,
    InvoiceUpdate,
)

router = APIRouter()

CLOSED_STATUSES = {InvoiceStatus.pagada, InvoiceStatus.anulada}


def _generate_invoice_number(db: Session, prefix: str) -> str:
    count = db.query(Invoice).count()
    return f"{prefix}-{(count + 1):04d}"


def _recalculate_totals(invoice: Invoice) -> None:
    subtotal = sum(item.custom_price for item in invoice.items)
    discount_amount = subtotal * (invoice.discount_percent / 100)
    base_gravable = subtotal - discount_amount
    tax_amount = base_gravable * (invoice.tax_rate / 100)
    invoice.subtotal = round(subtotal, 2)
    invoice.discount_amount = round(discount_amount, 2)
    invoice.tax_amount = round(tax_amount, 2)
    invoice.total = round(base_gravable + tax_amount, 2)


@router.get("", response_model=List[InvoiceResponse])
def list_invoices(
    status: Optional[InvoiceStatus] = Query(None),
    contact_id: Optional[int] = Query(None),
    seller_id: Optional[int] = Query(None),
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    q = db.query(Invoice)
    if status is not None:
        q = q.filter(Invoice.status == status)
    if contact_id is not None:
        q = q.filter(Invoice.contact_id == contact_id)
    if seller_id is not None:
        q = q.filter(Invoice.seller_id == seller_id)
    return q.all()


@router.post("", response_model=InvoiceResponse, status_code=201)
def create_invoice(
    payload: InvoiceCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    contact = db.query(Contact).filter(Contact.id == payload.contact_id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contacto no encontrado")

    config = get_or_create_config(db)
    invoice_number = _generate_invoice_number(db, config.invoice_prefix)

    invoice = Invoice(
        invoice_number=invoice_number,
        contact_id=payload.contact_id,
        seller_id=current_user.id,
        discount_percent=payload.discount_percent,
        tax_rate=config.tax_rate,
        notes=payload.notes,
    )
    db.add(invoice)
    db.flush()

    if payload.items:
        seen = set()
        for item_data in payload.items:
            if item_data.service_id in seen:
                raise HTTPException(
                    status_code=400,
                    detail=f"Servicio {item_data.service_id} duplicado en items",
                )
            service = db.query(Service).filter(Service.id == item_data.service_id).first()
            if not service:
                raise HTTPException(
                    status_code=404,
                    detail=f"Servicio {item_data.service_id} no encontrado",
                )
            seen.add(item_data.service_id)
            db.add(InvoiceItem(
                invoice_id=invoice.id,
                service_id=item_data.service_id,
                custom_price=item_data.custom_price,
                notes=item_data.notes,
            ))
        db.flush()

    db.refresh(invoice)
    _recalculate_totals(invoice)
    db.commit()
    db.refresh(invoice)
    return invoice


@router.get("/{invoice_id}", response_model=InvoiceResponse)
def get_invoice(
    invoice_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    invoice = db.query(Invoice).filter(Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Factura no encontrada")
    return invoice


@router.put("/{invoice_id}", response_model=InvoiceResponse)
def update_invoice(
    invoice_id: int,
    payload: InvoiceUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    invoice = db.query(Invoice).filter(Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Factura no encontrada")
    if invoice.status in CLOSED_STATUSES:
        raise HTTPException(
            status_code=400,
            detail="No se puede editar una factura pagada o anulada",
        )
    if payload.discount_percent is not None:
        invoice.discount_percent = payload.discount_percent
    if payload.notes is not None:
        invoice.notes = payload.notes
    _recalculate_totals(invoice)
    db.commit()
    db.refresh(invoice)
    return invoice


@router.patch("/{invoice_id}/status", response_model=InvoiceResponse)
def update_invoice_status(
    invoice_id: int,
    payload: InvoiceStatusUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    invoice = db.query(Invoice).filter(Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Factura no encontrada")
    invoice.status = payload.status
    db.commit()
    db.refresh(invoice)
    return invoice


@router.post("/{invoice_id}/items", response_model=InvoiceResponse, status_code=201)
def add_invoice_item(
    invoice_id: int,
    payload: InvoiceItemCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    invoice = db.query(Invoice).filter(Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Factura no encontrada")
    if invoice.status in CLOSED_STATUSES:
        raise HTTPException(status_code=400, detail="Factura cerrada")

    existing = db.query(InvoiceItem).filter(
        InvoiceItem.invoice_id == invoice_id,
        InvoiceItem.service_id == payload.service_id,
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="El servicio ya esta incluido en esta factura")

    service = db.query(Service).filter(Service.id == payload.service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Servicio no encontrado")

    db.add(InvoiceItem(
        invoice_id=invoice_id,
        service_id=payload.service_id,
        custom_price=payload.custom_price,
        notes=payload.notes,
    ))
    db.flush()
    db.refresh(invoice)
    _recalculate_totals(invoice)
    db.commit()
    db.refresh(invoice)
    return invoice


@router.put("/{invoice_id}/items/{item_id}", response_model=InvoiceResponse)
def update_invoice_item(
    invoice_id: int,
    item_id: int,
    payload: InvoiceItemUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    invoice = db.query(Invoice).filter(Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Factura no encontrada")
    if invoice.status in CLOSED_STATUSES:
        raise HTTPException(status_code=400, detail="Factura cerrada")

    item = db.query(InvoiceItem).filter(
        InvoiceItem.id == item_id,
        InvoiceItem.invoice_id == invoice_id,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item no encontrado en esta factura")

    if payload.custom_price is not None:
        item.custom_price = payload.custom_price
    if payload.notes is not None:
        item.notes = payload.notes

    db.flush()
    db.refresh(invoice)
    _recalculate_totals(invoice)
    db.commit()
    db.refresh(invoice)
    return invoice


@router.delete("/{invoice_id}/items/{item_id}", response_model=InvoiceResponse)
def delete_invoice_item(
    invoice_id: int,
    item_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    invoice = db.query(Invoice).filter(Invoice.id == invoice_id).first()
    if not invoice:
        raise HTTPException(status_code=404, detail="Factura no encontrada")
    if invoice.status in CLOSED_STATUSES:
        raise HTTPException(status_code=400, detail="Factura cerrada")

    item = db.query(InvoiceItem).filter(
        InvoiceItem.id == item_id,
        InvoiceItem.invoice_id == invoice_id,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item no encontrado en esta factura")

    db.delete(item)
    db.flush()
    db.refresh(invoice)
    _recalculate_totals(invoice)
    db.commit()
    db.refresh(invoice)
    return invoice
