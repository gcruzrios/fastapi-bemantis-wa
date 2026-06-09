import enum

from sqlalchemy import Column, DateTime, Enum, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from database import Base


class SaleStatus(str, enum.Enum):
    cotizado = "cotizado"
    negociando = "negociando"
    ganado = "ganado"
    perdido = "perdido"
    cliente_activo = "cliente_activo"


class Contact(Base):
    __tablename__ = "contacts"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    lead_id = Column(Integer, ForeignKey("leads.id"), nullable=False, unique=True)
    name = Column(String, nullable=False)
    email = Column(String, nullable=True)
    phone = Column(String, nullable=True)
    company = Column(String, nullable=True)
    notes = Column(Text, nullable=True)
    sale_status = Column(Enum(SaleStatus), nullable=False, default=SaleStatus.cotizado)
    converted_at = Column(DateTime(timezone=True), server_default=func.now())
    created_by = Column(Integer, ForeignKey("usuarios.id"), nullable=False)

    lead = relationship("Lead", backref="contact")
    created_by_user = relationship("Usuario", foreign_keys=[created_by])
    quotes = relationship("Quote", back_populates="contact")
    invoices = relationship("Invoice", back_populates="contact")
