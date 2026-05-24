from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from database import get_db
from models.interaccion import Interaccion
from models.lead import Lead
from models.usuario import Usuario
from routers.auth import get_current_user
from schemas.interaccion import InteraccionCreate, InteraccionResponse, InteraccionUpdate

router = APIRouter()


@router.get("/{lead_id}", response_model=List[InteraccionResponse])
def list_interacciones(
    lead_id: int,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Lista todas las interacciones de un lead, ordenadas por fecha."""
    lead = db.query(Lead).filter(Lead.id == lead_id).first()
    if not lead:
        raise HTTPException(status_code=404, detail="Lead no encontrado")
    return (
        db.query(Interaccion)
        .filter(Interaccion.lead_id == lead_id)
        .order_by(Interaccion.fecha.asc())
        .all()
    )


@router.post("/", response_model=InteraccionResponse, status_code=201)
def create_interaccion(
    payload: InteraccionCreate,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """
    Crea una interaccion. Endpoint usado por:
    - El vendedor desde el frontend React
    - El flujo n8n con agente='IA' para mensajes de WhatsApp
    """
    lead = db.query(Lead).filter(Lead.id == payload.lead_id).first()
    if not lead:
        raise HTTPException(status_code=404, detail=f"Lead {payload.lead_id} no encontrado")
    data = payload.model_dump(exclude_none=True)
    interaccion = Interaccion(**data)
    db.add(interaccion)
    db.commit()
    db.refresh(interaccion)
    return interaccion


@router.put("/{interaccion_id}", response_model=InteraccionResponse)
def update_interaccion(
    interaccion_id: int,
    payload: InteraccionUpdate,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Edita contenido, tipo o estado de una interaccion existente."""
    interaccion = db.query(Interaccion).filter(Interaccion.id == interaccion_id).first()
    if not interaccion:
        raise HTTPException(status_code=404, detail="Interaccion no encontrada")
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(interaccion, field, value)
    db.commit()
    db.refresh(interaccion)
    return interaccion


@router.delete("/{interaccion_id}", status_code=204)
def delete_interaccion(
    interaccion_id: int,
    db: Session = Depends(get_db),
    _: Usuario = Depends(get_current_user),
):
    """Elimina una interaccion individual del historial del lead."""
    interaccion = db.query(Interaccion).filter(Interaccion.id == interaccion_id).first()
    if not interaccion:
        raise HTTPException(status_code=404, detail="Interaccion no encontrada")
    db.delete(interaccion)
    db.commit()
