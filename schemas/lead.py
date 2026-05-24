from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, EmailStr

from models.lead import EstadoLead


class LeadCreate(BaseModel):
    """Payload para crear un nuevo lead."""

    nombre: str
    empresa: Optional[str] = None
    correo: Optional[EmailStr] = None
    telefono: Optional[str] = None
    estado: Optional[EstadoLead] = EstadoLead.cold
    fuente: Optional[str] = None
    notas: Optional[str] = None


class LeadUpdate(BaseModel):
    """Campos parciales para actualizar un lead."""

    nombre: Optional[str] = None
    empresa: Optional[str] = None
    correo: Optional[EmailStr] = None
    telefono: Optional[str] = None
    estado: Optional[EstadoLead] = None
    fuente: Optional[str] = None
    notas: Optional[str] = None


class LeadResponse(BaseModel):
    """Representacion completa del lead para el cliente."""

    id: int
    nombre: str
    empresa: Optional[str]
    correo: Optional[str]
    telefono: Optional[str]
    estado: EstadoLead
    fuente: Optional[str]
    notas: Optional[str]
    creado_en: Optional[datetime]
    fecha_actualizacion: Optional[datetime]

    model_config = {"from_attributes": True}


class LeadsPaginados(BaseModel):
    """Respuesta paginada de leads."""

    total: int
    pagina: int
    leads: List[LeadResponse]

