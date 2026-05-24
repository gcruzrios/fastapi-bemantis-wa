from sqlalchemy import Column, DateTime, Integer, String
from sqlalchemy.sql import func

from database import Base


class Usuario(Base):
    """Modelo de usuario del sistema (agente/vendedor)."""

    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    correo = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    nombre = Column(String, nullable=False)
    telefono = Column(String, nullable=True)
    empresa = Column(String, nullable=True)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

    def __repr__(self):
        return f"<Usuario id={self.id} correo={self.correo}>"

