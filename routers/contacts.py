from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from database import get_db
from models.contact import Contact, SaleStatus
from models.lead import Lead
from models.usuario import Usuario
from routers.auth import get_current_user
from schemas.contact import ContactCreate, ContactResponse, ContactStatusUpdate, ContactUpdate

router = APIRouter()


@router.get("", response_model=List[ContactResponse])
def list_contacts(
    sale_status: Optional[SaleStatus] = Query(None),
    search: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    q = db.query(Contact)
    if sale_status is not None:
        q = q.filter(Contact.sale_status == sale_status)
    if search:
        pattern = f"%{search}%"
        q = q.filter(Contact.name.ilike(pattern) | Contact.company.ilike(pattern))
    return q.all()


@router.post("/from-lead/{lead_id}", response_model=ContactResponse, status_code=201)
def convert_lead_to_contact(
    lead_id: int,
    payload: ContactCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    lead = db.query(Lead).filter(Lead.id == lead_id).first()
    if not lead:
        raise HTTPException(status_code=404, detail="Lead no encontrado")

    existing = db.query(Contact).filter(Contact.lead_id == lead_id).first()
    if existing:
        raise HTTPException(status_code=400, detail="El lead ya fue convertido anteriormente")

    contact = Contact(
        lead_id=lead_id,
        name=lead.nombre,
        email=payload.email or lead.correo,
        phone=payload.phone or lead.telefono,
        company=payload.company or lead.empresa,
        notes=payload.notes,
        sale_status=payload.sale_status,
        created_by=current_user.id,
    )
    db.add(contact)
    db.commit()
    db.refresh(contact)
    return contact


@router.get("/{contact_id}", response_model=ContactResponse)
def get_contact(
    contact_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    contact = db.query(Contact).filter(Contact.id == contact_id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contacto no encontrado")
    return contact


@router.put("/{contact_id}", response_model=ContactResponse)
def update_contact(
    contact_id: int,
    payload: ContactUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    contact = db.query(Contact).filter(Contact.id == contact_id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contacto no encontrado")
    for field, value in payload.model_dump(exclude_none=True).items():
        setattr(contact, field, value)
    db.commit()
    db.refresh(contact)
    return contact


@router.patch("/{contact_id}/status", response_model=ContactResponse)
def update_contact_status(
    contact_id: int,
    payload: ContactStatusUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    contact = db.query(Contact).filter(Contact.id == contact_id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contacto no encontrado")
    contact.sale_status = payload.sale_status
    db.commit()
    db.refresh(contact)
    return contact
