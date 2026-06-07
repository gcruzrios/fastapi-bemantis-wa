from datetime import datetime
from typing import Optional

from pydantic import BaseModel

from models.system_config import CurrencyEnum


class SystemConfigUpdate(BaseModel):
    quote_prefix: Optional[str] = None
    tax_rate: Optional[float] = None
    currency: Optional[CurrencyEnum] = None
    exchange_rate: Optional[float] = None


class SystemConfigResponse(BaseModel):
    id: int
    quote_prefix: str
    tax_rate: float
    currency: CurrencyEnum
    exchange_rate: float
    updated_at: Optional[datetime]
    updated_by: Optional[int]

    model_config = {"from_attributes": True}
