from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class ServiceCreate(BaseModel):
    name: str
    description: Optional[str] = None
    category: str
    base_price: float
    is_active: bool = True


class ServiceUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    base_price: Optional[float] = None
    is_active: Optional[bool] = None


class ServiceResponse(BaseModel):
    id: int
    name: str
    description: Optional[str]
    category: str
    base_price: float
    is_active: bool
    created_at: datetime

    model_config = {"from_attributes": True}
