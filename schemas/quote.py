from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel

from models.quote import QuoteStatus


class QuoteItemCreate(BaseModel):
    service_id: int
    custom_price: float
    notes: Optional[str] = None


class QuoteItemUpdate(BaseModel):
    custom_price: Optional[float] = None
    notes: Optional[str] = None


class ServiceBrief(BaseModel):
    id: int
    name: str
    category: str

    model_config = {"from_attributes": True}


class QuoteItemResponse(BaseModel):
    id: int
    quote_id: int
    service_id: int
    custom_price: float
    notes: Optional[str]
    service: Optional[ServiceBrief]

    model_config = {"from_attributes": True}


class SellerBrief(BaseModel):
    id: int
    nombre: str
    correo: str

    model_config = {"from_attributes": True}


class ContactBrief(BaseModel):
    id: int
    name: str
    email: Optional[str]
    company: Optional[str]

    model_config = {"from_attributes": True}


class QuoteCreate(BaseModel):
    contact_id: int
    discount_percent: float = 0.0
    notes: Optional[str] = None
    items: Optional[List[QuoteItemCreate]] = None


class QuoteUpdate(BaseModel):
    discount_percent: Optional[float] = None
    notes: Optional[str] = None


class QuoteStatusUpdate(BaseModel):
    status: QuoteStatus


class QuoteResponse(BaseModel):
    id: int
    quote_number: str
    contact_id: int
    seller_id: int
    status: QuoteStatus
    discount_percent: float
    tax_rate: float
    notes: Optional[str]
    created_at: datetime
    subtotal: float
    discount_amount: float
    tax_amount: float
    total: float
    contact: Optional[ContactBrief]
    seller: Optional[SellerBrief]
    items: List[QuoteItemResponse] = []

    model_config = {"from_attributes": True}
