# Import FastAPI framework and dependency injection helper
from fastapi import FastAPI, Depends

# Import database session manager
from sqlalchemy.orm import Session

# Import Pydantic for request data validation
from pydantic import BaseModel

# Import database setup and engine
from database import SessionLocal, engine

# Import SQLAlchemy base and the Trade model (DB table)
from models import Base, Trade

# Create a new FastAPI app instance
app = FastAPI()

# Create the database tables (if not already created)
Base.metadata.create_all(bind=engine)

# Define the expected structure of a trade input via API
class TradeInput(BaseModel):
    symbol: str          # e.g., "BTCUSDT"
    direction: str       # "long" or "short"
    entry_price: float   # e.g., 26000.50
    size: float          # position size in USD
    leverage: int        # leverage used, e.g. 5
    exchange: str        # e.g., "Binance"
    notes: str = ""      # optional notes

# Create a dependency that returns a new DB session
def get_db():
    db = SessionLocal()
    try:
        yield db          # gives access to a live DB session
    finally:
        db.close()        # always close the session after use

# Create a POST endpoint at /trades to save new trade entries
@app.post("/trades")
def create_trade(
    trade: TradeInput,               # validated input data
    db: Session = Depends(get_db)   # inject a live DB session
):
    # Convert validated input to a Trade DB model instance
    db_trade = Trade(**trade.dict())

    # Add the trade to the session (staged for saving)
    db.add(db_trade)

    # Commit the trade to the database (permanently saved)
    db.commit()

    # Refresh the object to get updated fields (like auto-generated ID)
    db.refresh(db_trade)

    # Return the newly created trade as JSON response
    return db_trade

# Create a GET endpoint at /trades to ge tall trades
@app.get("/trades")
def get_trades(
    db: Session = Depends(get_db)
):
    trades = db.query(Trade).all()
    return trades