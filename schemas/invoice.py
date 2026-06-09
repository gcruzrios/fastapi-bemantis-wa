from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel

from models.invoice import InvoiceStatus


class InvoiceItemCreate(BaseModel):
    service_id: int
    custom_price: float
    notes: Optional[str] = None


class InvoiceItemUpdate(BaseModel):
    custom_price: Optional[float] = None
    notes: Optional[str] = None


class ServiceBrief(BaseModel):
    id: int
    name: str
    category: str

    model_config = {"from_attributes": True}


class InvoiceItemResponse(BaseModel):
    id: int
    invoice_id: int
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


class InvoiceCreate(BaseModel):
    contact_id: int
    discount_percent: float = 0.0
    notes: Optional[str] = None
    items: Optional[List[InvoiceItemCreate]] = None


class InvoiceUpdate(BaseModel):
    discount_percent: Optional[float] = None
    notes: Optional[str] = None


class InvoiceStatusUpdate(BaseModel):
    status: InvoiceStatus


class InvoiceResponse(BaseModel):
    id: int
    invoice_number: str
    contact_id: int
    seller_id: int
    status: InvoiceStatus
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
    items: List[InvoiceItemResponse] = []

    model_config = {"from_attributes": True}
