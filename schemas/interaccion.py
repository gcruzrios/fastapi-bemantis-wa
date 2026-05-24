from datetime import datetime
from typing import Optional

from pydantic import BaseModel

from models.interaccion import EstadoInteraccion, TipoInteraccion


class InteraccionCreate(BaseModel):
    """Payload para crear una interaccion. Usado por frontend y por n8n."""

    lead_id: int
    tipo: TipoInteraccion
    contenido: str
    agente: str
    estado: Optional[EstadoInteraccion] = None
    fecha: Optional[datetime] = None


class InteraccionUpdate(BaseModel):
    """Campos parciales para editar una interaccion existente."""

    tipo: Optional[TipoInteraccion] = None
    contenido: Optional[str] = None
    estado: Optional[EstadoInteraccion] = None
    agente: Optional[str] = None


class InteraccionResponse(BaseModel):
    """Representacion completa de una interaccion."""

    id: int
    lead_id: int
    fecha: datetime
    tipo: TipoInteraccion
    estado: Optional[EstadoInteraccion]
    contenido: str
    agente: str
    creado_en: datetime

    model_config = {"from_attributes": True}

