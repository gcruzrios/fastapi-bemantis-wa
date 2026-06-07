import enum

from sqlalchemy import Column, DateTime, Enum, Float, ForeignKey, Integer, String
from sqlalchemy.sql import func

from database import Base


class CurrencyEnum(str, enum.Enum):
    USD = "USD"
    CRC = "CRC"


class SystemConfig(Base):
    __tablename__ = "system_config"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    quote_prefix = Column(String, nullable=False, default="CD")
    tax_rate = Column(Float, nullable=False, default=13.0)
    currency = Column(Enum(CurrencyEnum), nullable=False, default=CurrencyEnum.USD)
    exchange_rate = Column(Float, nullable=False, default=450.0)
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    updated_by = Column(Integer, ForeignKey("usuarios.id"), nullable=True)
