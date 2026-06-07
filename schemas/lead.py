from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, EmailStr, field_validator

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

    @field_validator("empresa", "correo", "telefono", "estado", "fuente", "notas", mode="before")
    @classmethod
    def empty_string_to_none(cls, value):
        if isinstance(value, str) and not value.strip():
            return None
        return value


class LeadUpdate(BaseModel):
    """Campos parciales para actualizar un lead."""

    nombre: Optional[str] = None
    empresa: Optional[str] = None
    correo: Optional[EmailStr] = None
    telefono: Optional[str] = None
    estado: Optional[EstadoLead] = None
    fuente: Optional[str] = None
    notas: Optional[str] = None

    @field_validator("nombre", "empresa", "correo", "telefono", "estado", "fuente", "notas", mode="before")
    @classmethod
    def empty_string_to_none(cls, value):
        if isinstance(value, str) and not value.strip():
            return None
        return value


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
