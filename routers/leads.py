from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from database import get_db
from models.lead import EstadoLead, Lead
from models.usuario import Usuario
from routers.auth import get_current_user
from schemas.lead import LeadCreate, LeadResponse, LeadsPaginados, LeadUpdate

router = APIRouter()


@router.get("/", response_model=LeadsPaginados)
def list_leads(
    estado: Optional[EstadoLead] = Query(None, description="Filtrar por estado"),
    telefono: Optional[str] = Query(None, description="Buscar por telefono exacto"),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=200),
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Lista leads con filtros opcionales y paginacion."""
    query = db.query(Lead)
    if estado:
        query = query.filter(Lead.estado == estado)
    if telefono:
        query = query.filter(Lead.telefono == telefono)
    total = query.count()
    leads = query.order_by(Lead.creado_en.desc()).offset(skip).limit(limit).all()
    return LeadsPaginados(total=total, pagina=skip // limit + 1, leads=leads)


@router.get("/{lead_id}", response_model=LeadResponse)
def get_lead(
    lead_id: int,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Retorna detalle completo de un lead por ID."""
    lead = db.query(Lead).filter(Lead.id == lead_id).first()
    if not lead:
        raise HTTPException(status_code=404, detail=f"Lead {lead_id} no encontrado")
    return lead


@router.post("/", response_model=LeadResponse, status_code=201)
def create_lead(
    payload: LeadCreate,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Crea un nuevo lead. Usado por el formulario frontend y por el flujo n8n."""
    lead = Lead(**payload.model_dump(exclude_none=True))
    db.add(lead)
    db.commit()
    db.refresh(lead)
    return lead


@router.put("/{lead_id}", response_model=LeadResponse)
def update_lead(
    lead_id: int,
    payload: LeadUpdate,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Actualiza campos parciales de un lead existente."""
    lead = db.query(Lead).filter(Lead.id == lead_id).first()
    if not lead:
        raise HTTPException(status_code=404, detail=f"Lead {lead_id} no encontrado")
    for field, value in payload.model_dump(exclude_unset=True).items():
        if field in {"nombre", "estado"} and value is None:
            continue
        setattr(lead, field, value)
    db.commit()
    db.refresh(lead)
    return lead


@router.delete("/{lead_id}", status_code=204)
def delete_lead(
    lead_id: int,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Elimina un lead y en cascada todas sus interacciones."""
    lead = db.query(Lead).filter(Lead.id == lead_id).first()
    if not lead:
        raise HTTPException(status_code=404, detail=f"Lead {lead_id} no encontrado")
    db.delete(lead)
    db.commit()
