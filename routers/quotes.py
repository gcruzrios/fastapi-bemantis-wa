from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from database import get_db
from models.contact import Contact
from models.quote import Quote, QuoteItem, QuoteStatus
from models.service import Service
from models.usuario import Usuario
from routers.auth import get_current_user
from routers.config import get_or_create_config
from schemas.quote import (
    QuoteCreate,
    QuoteItemCreate,
    QuoteItemUpdate,
    QuoteResponse,
    QuoteStatusUpdate,
    QuoteUpdate,
)

router = APIRouter()

CLOSED_STATUSES = {QuoteStatus.aprobada, QuoteStatus.rechazada}


def _generate_quote_number(db: Session, prefix: str) -> str:
    count = db.query(Quote).count()
    return f"{prefix}-{(count + 1):04d}"


def _recalculate_totals(quote: Quote) -> None:
    subtotal = sum(item.custom_price for item in quote.items)
    discount_amount = subtotal * (quote.discount_percent / 100)
    base_gravable = subtotal - discount_amount
    tax_amount = base_gravable * (quote.tax_rate / 100)
    quote.subtotal = round(subtotal, 2)
    quote.discount_amount = round(discount_amount, 2)
    quote.tax_amount = round(tax_amount, 2)
    quote.total = round(base_gravable + tax_amount, 2)


@router.get("", response_model=List[QuoteResponse])
def list_quotes(
    status: Optional[QuoteStatus] = Query(None),
    contact_id: Optional[int] = Query(None),
    seller_id: Optional[int] = Query(None),
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    q = db.query(Quote)
    if status is not None:
        q = q.filter(Quote.status == status)
    if contact_id is not None:
        q = q.filter(Quote.contact_id == contact_id)
    if seller_id is not None:
        q = q.filter(Quote.seller_id == seller_id)
    return q.all()


@router.post("", response_model=QuoteResponse, status_code=201)
def create_quote(
    payload: QuoteCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    contact = db.query(Contact).filter(Contact.id == payload.contact_id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contacto no encontrado")

    config = get_or_create_config(db)
    quote_number = _generate_quote_number(db, config.quote_prefix)

    quote = Quote(
        quote_number=quote_number,
        contact_id=payload.contact_id,
        seller_id=current_user.id,
        discount_percent=payload.discount_percent,
        tax_rate=config.tax_rate,
        notes=payload.notes,
    )
    db.add(quote)
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
            db.add(QuoteItem(
                quote_id=quote.id,
                service_id=item_data.service_id,
                custom_price=item_data.custom_price,
                notes=item_data.notes,
            ))
        db.flush()

    db.refresh(quote)
    _recalculate_totals(quote)
    db.commit()
    db.refresh(quote)
    return quote


@router.get("/{quote_id}", response_model=QuoteResponse)
def get_quote(
    quote_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if not quote:
        raise HTTPException(status_code=404, detail="Cotizacion no encontrada")
    return quote


@router.put("/{quote_id}", response_model=QuoteResponse)
def update_quote(
    quote_id: int,
    payload: QuoteUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if not quote:
        raise HTTPException(status_code=404, detail="Cotizacion no encontrada")
    if quote.status in CLOSED_STATUSES:
        raise HTTPException(
            status_code=400,
            detail="No se puede editar una cotizacion aprobada o rechazada",
        )
    if payload.discount_percent is not None:
        quote.discount_percent = payload.discount_percent
    if payload.notes is not None:
        quote.notes = payload.notes
    _recalculate_totals(quote)
    db.commit()
    db.refresh(quote)
    return quote


@router.patch("/{quote_id}/status", response_model=QuoteResponse)
def update_quote_status(
    quote_id: int,
    payload: QuoteStatusUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if not quote:
        raise HTTPException(status_code=404, detail="Cotizacion no encontrada")
    quote.status = payload.status
    db.commit()
    db.refresh(quote)
    return quote


@router.post("/{quote_id}/items", response_model=QuoteResponse, status_code=201)
def add_quote_item(
    quote_id: int,
    payload: QuoteItemCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if not quote:
        raise HTTPException(status_code=404, detail="Cotizacion no encontrada")
    if quote.status in CLOSED_STATUSES:
        raise HTTPException(status_code=400, detail="Cotizacion cerrada")

    existing = db.query(QuoteItem).filter(
        QuoteItem.quote_id == quote_id,
        QuoteItem.service_id == payload.service_id,
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="El servicio ya esta incluido en esta cotizacion")

    service = db.query(Service).filter(Service.id == payload.service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Servicio no encontrado")

    db.add(QuoteItem(
        quote_id=quote_id,
        service_id=payload.service_id,
        custom_price=payload.custom_price,
        notes=payload.notes,
    ))
    db.flush()
    db.refresh(quote)
    _recalculate_totals(quote)
    db.commit()
    db.refresh(quote)
    return quote


@router.put("/{quote_id}/items/{item_id}", response_model=QuoteResponse)
def update_quote_item(
    quote_id: int,
    item_id: int,
    payload: QuoteItemUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if not quote:
        raise HTTPException(status_code=404, detail="Cotizacion no encontrada")
    if quote.status in CLOSED_STATUSES:
        raise HTTPException(status_code=400, detail="Cotizacion cerrada")

    item = db.query(QuoteItem).filter(
        QuoteItem.id == item_id,
        QuoteItem.quote_id == quote_id,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item no encontrado en esta cotizacion")

    if payload.custom_price is not None:
        item.custom_price = payload.custom_price
    if payload.notes is not None:
        item.notes = payload.notes

    db.flush()
    db.refresh(quote)
    _recalculate_totals(quote)
    db.commit()
    db.refresh(quote)
    return quote


@router.delete("/{quote_id}/items/{item_id}", response_model=QuoteResponse)
def delete_quote_item(
    quote_id: int,
    item_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    quote = db.query(Quote).filter(Quote.id == quote_id).first()
    if not quote:
        raise HTTPException(status_code=404, detail="Cotizacion no encontrada")
    if quote.status in CLOSED_STATUSES:
        raise HTTPException(status_code=400, detail="Cotizacion cerrada")

    item = db.query(QuoteItem).filter(
        QuoteItem.id == item_id,
        QuoteItem.quote_id == quote_id,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item no encontrado en esta cotizacion")

    db.delete(item)
    db.flush()
    db.refresh(quote)
    _recalculate_totals(quote)
    db.commit()
    db.refresh(quote)
    return quote
