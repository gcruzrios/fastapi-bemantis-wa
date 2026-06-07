from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr

from models.contact import SaleStatus


class ContactCreate(BaseModel):
    sale_status: Optional[SaleStatus] = SaleStatus.cotizado
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    company: Optional[str] = None
    notes: Optional[str] = None


class ContactUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    company: Optional[str] = None
    notes: Optional[str] = None


class ContactStatusUpdate(BaseModel):
    sale_status: SaleStatus


class ContactResponse(BaseModel):
    id: int
    lead_id: int
    name: str
    email: Optional[str]
    phone: Optional[str]
    company: Optional[str]
    notes: Optional[str]
    sale_status: SaleStatus
    converted_at: datetime
    created_by: int

    model_config = {"from_attributes": True}
