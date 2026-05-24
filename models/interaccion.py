import enum

from sqlalchemy import Column, DateTime, Enum, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from database import Base


class TipoInteraccion(str, enum.Enum):
    nueva_conversacion = "nueva-conversacion"
    seguimiento = "seguimiento"
    cierre = "cierre"


class EstadoInteraccion(str, enum.Enum):
    cold = "cold"
    warm = "warm"
    hot = "hot"
    appointment = "appointment"


class Interaccion(Base):
    """Mensaje o nota registrada para un Lead."""

    __tablename__ = "interacciones"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    lead_id = Column(Integer, ForeignKey("leads.id", ondelete="CASCADE"), nullable=False, index=True)
    fecha = Column(DateTime(timezone=True), server_default=func.now())
    tipo = Column(Enum(TipoInteraccion), nullable=False)
    estado = Column(Enum(EstadoInteraccion), nullable=True)
    contenido = Column(Text, nullable=False)
    agente = Column(String, nullable=False)
    creado_en = Column(DateTime(timezone=True), server_default=func.now())

    lead = relationship("Lead", back_populates="interacciones")

    def __repr__(self):
        return f"<Interaccion id={self.id} lead_id={self.lead_id} agente={self.agente}>"

