# Import SQLAlchemy components
from sqlalchemy import Column, Integer, String, Float, DateTime
from database import Base
from datetime import datetime

# Define a Trade model (this maps to the "trades" table in the DB)
class Trade(Base):
    __tablename__ = "trades"  # Name of the table in the database

    # Primary key column, auto-incremented
    id = Column(Integer, primary_key=True, index=True)

    # Trade details
    symbol = Column(String)           # e.g., "BTCUSDT"
    direction = Column(String)        # "long" or "short"
    entry_price = Column(Float)       # Entry price for the trade
    exit_price = Column(Float, nullable=True)  # Optional exit price (for closed trades)
    size = Column(Float)              # Position size in USD or coin
    leverage = Column(Integer)        # Leverage used
    exchange = Column(String)         # e.g., "Binance", "MEXC"

    # Timestamps
    entry_time = Column(DateTime, default=datetime.utcnow)  # Time of trade entry
    exit_time = Column(DateTime, nullable=True)              # Optional exit time
    
    # Notes or additional info
    notes = Column(String)            # Optional notes field

    # Result of the trade
    result = Column(String, nullable=True)