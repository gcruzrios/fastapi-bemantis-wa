import enum

from sqlalchemy import Column, DateTime, Enum, Float, ForeignKey, Integer, String, Text, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from database import Base


class InvoiceStatus(str, enum.Enum):
    borrador = "borrador"
    emitida = "emitida"
    pagada = "pagada"
    anulada = "anulada"


class Invoice(Base):
    __tablename__ = "invoices"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    invoice_number = Column(String, nullable=False, unique=True)
    contact_id = Column(Integer, ForeignKey("contacts.id"), nullable=False)
    seller_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    status = Column(Enum(InvoiceStatus), nullable=False, default=InvoiceStatus.borrador)
    discount_percent = Column(Float, nullable=False, default=0.0)
    tax_rate = Column(Float, nullable=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    subtotal = Column(Float, nullable=False, default=0.0)
    discount_amount = Column(Float, nullable=False, default=0.0)
    tax_amount = Column(Float, nullable=False, default=0.0)
    total = Column(Float, nullable=False, default=0.0)

    contact = relationship("Contact", back_populates="invoices")
    seller = relationship("Usuario", foreign_keys=[seller_id])
    items = relationship("InvoiceItem", back_populates="invoice", cascade="all, delete-orphan")


class InvoiceItem(Base):
    __tablename__ = "invoice_items"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    invoice_id = Column(Integer, ForeignKey("invoices.id", ondelete="CASCADE"), nullable=False)
    service_id = Column(Integer, ForeignKey("services.id"), nullable=False)
    custom_price = Column(Float, nullable=False)
    notes = Column(Text, nullable=True)

    invoice = relationship("Invoice", back_populates="items")
    service = relationship("Service")

    __table_args__ = (
        UniqueConstraint("invoice_id", "service_id", name="uq_invoice_service"),
    )
