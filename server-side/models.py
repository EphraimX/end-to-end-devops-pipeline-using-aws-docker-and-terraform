from sqlalchemy import Column, Integer, Float, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()


class PaymentRecord(Base):
    __tablename__ = "payment_records"

    id = Column(Integer, primary_key=True, index=True)
    cost = Column(Float, nullable=False)
    revenue = Column(Float, nullable=False)
    time_horizon = Column(Integer, nullable=False)
    roi_percent = Column(String, nullable=False)
    break_even_months = Column(String, nullable=False)
    date = Column(DateTime, nullable=False)
