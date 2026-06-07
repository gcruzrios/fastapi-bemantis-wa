import enum

from sqlalchemy import Column, DateTime, Enum, Float, ForeignKey, Integer, String, Text, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from database import Base


class QuoteStatus(str, enum.Enum):
    borrador = "borrador"
    enviada = "enviada"
    aprobada = "aprobada"
    rechazada = "rechazada"


class Quote(Base):
    __tablename__ = "quotes"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    quote_number = Column(String, nullable=False, unique=True)
    contact_id = Column(Integer, ForeignKey("contacts.id"), nullable=False)
    seller_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    status = Column(Enum(QuoteStatus), nullable=False, default=QuoteStatus.borrador)
    discount_percent = Column(Float, nullable=False, default=0.0)
    tax_rate = Column(Float, nullable=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    subtotal = Column(Float, nullable=False, default=0.0)
    discount_amount = Column(Float, nullable=False, default=0.0)
    tax_amount = Column(Float, nullable=False, default=0.0)
    total = Column(Float, nullable=False, default=0.0)

    contact = relationship("Contact", back_populates="quotes")
    seller = relationship("Usuario", foreign_keys=[seller_id])
    items = relationship("QuoteItem", back_populates="quote", cascade="all, delete-orphan")


class QuoteItem(Base):
    __tablename__ = "quote_items"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    quote_id = Column(Integer, ForeignKey("quotes.id", ondelete="CASCADE"), nullable=False)
    service_id = Column(Integer, ForeignKey("services.id"), nullable=False)
    custom_price = Column(Float, nullable=False)
    notes = Column(Text, nullable=True)

    quote = relationship("Quote", back_populates="items")
    service = relationship("Service")

    __table_args__ = (
        UniqueConstraint("quote_id", "service_id", name="uq_quote_service"),
    )
