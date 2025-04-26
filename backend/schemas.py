from pydantic import BaseModel
from typing import Optional

class TradeBase(BaseModel):
    symbol: str
    direction: str
    entry_price: float
    exit_price: Optional[float] = None
    size: float
    leverage: Optional[float] = None
    result: Optional[str] = None
    notes: Optional[str] = None

class TradeCreate(TradeBase):
    pass

class TradeUpdate(BaseModel):
    symbol: Optional[str]
    direction: Optional[str]
    entry_price: Optional[float]
    exit_price: Optional[float]
    size: Optional[float]
    leverage: Optional[float]
    result: Optional[str]
    notes: Optional[str]

class TradeOut(TradeBase):
    id: int

    class Config:
        orm_mode = True