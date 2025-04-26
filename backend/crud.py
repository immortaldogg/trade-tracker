from models import Trade
from sqlalchemy.orm import Session

def get_all_trades(db: Session):
    return db.query(Trade).all()

def get_trade(db: Session, trade_id: int):
    return db.get(Trade, trade_id)

def create_trade(db: Session, trade_data):
    trade = Trade(**trade_data.dict())
    db.add(trade)
    db.commit()
    db.refresh(trade)
    return trade

def update_trade(db: Session, trade: Trade, update_data):
    for key, value in update_data.dict(exclude_unset=True).items():
        setattr(trade, key, value)
    db.commit()
    db.refresh(trade)
    return trade

def delete_trade(db: Session, trade: Trade):
    db.delete(trade)
    db.commit()