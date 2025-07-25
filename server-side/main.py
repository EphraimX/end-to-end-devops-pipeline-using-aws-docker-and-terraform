from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field
from models import Base, PaymentRecord
from config import settings
from typing import Union
from db import SessionLocal, engine
import uvicorn


# Initialize FastAPI app
app = FastAPI(
    title="ROI Calculator Backend",
    description="API for calculating ROI and recording payments."
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,  # Adjust based on your deployment
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Pydantic models for request bodies
class RoiCalculationRequest(BaseModel):
    cost: float
    revenue: float
    timeHorizon: int


class PaymentRecordRequest(BaseModel):
    cost: float
    revenue: float
    time_horizon: int = Field(..., alias="timeHorizon")
    roi_percent: str = Field(..., alias="roiPercent")
    break_even_months: str = Field(..., alias="breakEvenMonths")
    date: str

    class Config:
        validate_by_name = True 


@app.get("/api/healthcheck")
async def health_check():
    return {"message": "Working Lovelies"}


@app.post("/api/calculate-roi")
async def calculate_roi(request: RoiCalculationRequest):
    """
    Calculates Return on Investment (ROI) and break-even time.
    """
    current_cost = request.cost
    current_revenue = request.revenue
    current_time_horizon = request.timeHorizon

    if any(val is None for val in [current_cost, current_revenue, current_time_horizon]) or current_time_horizon <= 0:
        raise HTTPException(status_code=400, detail="Please enter valid numbers for all fields.")

    # --- ROI Calculation ---
    total_revenue = current_revenue * current_time_horizon
    net_profit = total_revenue - current_cost
    calculated_roi_percent = 0.0
    if current_cost > 0:
        calculated_roi_percent = (net_profit / current_cost) * 100
    elif net_profit > 0:
        # If cost is 0 but there's profit, ROI is infinite
        calculated_roi_percent = float('inf')

    calculated_break_even_months: Union[str, float] = "N/A"
    if current_revenue > 0:
        calculated_break_even_months = round(current_cost / current_revenue, 2)
    elif current_cost > 0:
        # If cost > 0 but revenue is 0, never breaks even
        calculated_break_even_months = "Never"
    else:
        # If cost and revenue are both 0, already broken even
        calculated_break_even_months = "0"

    roi_percent = "Infinite" if calculated_roi_percent == float('inf') else f"{calculated_roi_percent:.2f}%"
    break_even_months = str(calculated_break_even_months)

    return {"roiPercent": roi_percent, "breakEvenMonths": break_even_months}


# DB Healtch Check
@app.get("/dbHealth")
def health_check(db: Session = Depends(get_db)):
    try:
        db.execute("SELECT 1")
        return {"status": "ok"}
    except Exception as e:
        raise HTTPException(status_code=500, detail="Database connection failed")


@app.post("/api/recordEntry")
def record_payment(request: PaymentRecordRequest, db: Session = Depends(get_db)):
    try:
        new_record = PaymentRecord(
            cost=request.cost,
            revenue=request.revenue,
            time_horizon=request.time_horizon,
            roi_percent=request.roi_percent,
            break_even_months=request.break_even_months,
            date=request.date
        )
        db.add(new_record)
        db.commit()
        db.refresh(new_record)

        return {"success": True, "message": "Payment record saved to RDS."}
    except Exception as e:
        print("DB error:", e)
        raise HTTPException(status_code=500, detail="Failed to save payment record.")