from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr


class UsuarioCreate(BaseModel):
    """Payload para registro de nuevo usuario."""

    correo: EmailStr
    password: str
    nombre: str
    telefono: Optional[str] = None
    empresa: Optional[str] = None


class UsuarioResponse(BaseModel):
    """Datos publicos del usuario (sin password)."""

    id: int
    correo: str
    nombre: str
    telefono: Optional[str]
    empresa: Optional[str]
    creado_en: Optional[datetime]

    model_config = {"from_attributes": True}


class UsuarioUpdate(BaseModel):
    """Campos actualizables del perfil de usuario."""

    nombre: Optional[str] = None
    telefono: Optional[str] = None
    empresa: Optional[str] = None
    password_new: Optional[str] = None


class LoginRequest(BaseModel):
    correo: EmailStr
    password: str


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    usuario: UsuarioResponse

