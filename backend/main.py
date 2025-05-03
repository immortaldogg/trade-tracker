from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import Base, engine, get_db
from schemas import TradeCreate, TradeOut, TradeUpdate
from crud import *

import models
  # this loads .env into os.environ

# Create the database tables (if not already created)
# Base.metadata.create_all(bind=engine)

# Create a new FastAPI app instance
app = FastAPI()

@app.post("/trade", response_model=TradeOut)
def create(trade: TradeCreate, db: Session = Depends(get_db)):
    return create_trade(db, trade)

@app.get("/trades", response_model=list[TradeOut])
def read_all(db: Session = Depends(get_db)):
    return get_all_trades(db)

@app.get("/trade/{id}")
def read(id: int, db: Session = Depends(get_db)):
    trade = get_trade(db, id)
    if trade is None:
        raise HTTPException(404, f"Trade {id} not found")
    return trade

@app.put("/trade/{id}", response_model=TradeOut)
def update(id: int, trade_data: TradeUpdate, db: Session = Depends(get_db)):
    trade = get_trade(db, id)
    if not trade:
        raise HTTPException(404, f"Trade {id} not found")
    return update_trade(db, trade, trade_data)

@app.delete("/trade/{id}")
def delete(id: int, db: Session = Depends(get_db)):
    trade = get_trade(db, id)
    if not trade:
        raise HTTPException(404, f"Trade {id} not found")
    delete_trade(db, trade)
    return {"deleted": id}