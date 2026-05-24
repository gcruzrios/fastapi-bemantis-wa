import enum

from sqlalchemy import Column, DateTime, Enum, Integer, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from database import Base


class EstadoLead(str, enum.Enum):
    cold = "cold"
    warm = "warm"
    hot = "hot"
    appointment = "appointment"


class Lead(Base):
    """Prospecto/lead capturado desde WhatsApp o formulario."""

    __tablename__ = "leads"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    nombre = Column(String, nullable=False)
    empresa = Column(String, nullable=True)
    correo = Column(String, nullable=True)
    telefono = Column(String, nullable=True, index=True)
    estado = Column(Enum(EstadoLead), default=EstadoLead.cold, nullable=False)
    fuente = Column(String, nullable=True)
    notas = Column(Text, nullable=True)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())
    fecha_actualizacion = Column(DateTime(timezone=True), onupdate=func.now())

    interacciones = relationship(
        "Interaccion",
        back_populates="lead",
        cascade="all, delete-orphan",
        lazy="dynamic",
    )

    def __repr__(self):
        return f"<Lead id={self.id} nombre={self.nombre} estado={self.estado}>"

