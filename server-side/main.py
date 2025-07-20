from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Union
import uvicorn

# Initialize FastAPI app
app = FastAPI(
    title="ROI Calculator Backend",
    description="API for calculating ROI and recording payments."
)


# CORS configuration
origins = [
    "http://localhost",
    "http://localhost:3000",  # or the port your frontend uses
    "https://3000-ephraimx-staticroicalcu-ar07kphbms7.ws-eu120.gitpod.io"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # Adjust based on your deployment
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Pydantic models for request bodies
class RoiCalculationRequest(BaseModel):
    cost: float
    revenue: float
    timeHorizon: int

class PaymentRecordRequest(BaseModel):
    cost: float
    revenue: float
    timeHorizon: int
    roiPercent: str
    breakEvenMonths: str
    # In a real app, you'd also include Stripe payment intent ID, etc.

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

@app.post("/api/record-payment")
async def record_payment(request: PaymentRecordRequest):
    """
    Records successful payment details into a database (simulated).
    """
    # In a real application, you would insert this data into your database.
    # For example, using SQLAlchemy, Tortoise ORM, or a direct database client.
    print(f"Simulating database insertion for successful payment: {request.dict()}")

    # Example of what you might do with a database client:
    # from your_database_module import db_session, PaymentRecord
    # with db_session() as session:
    #     new_record = PaymentRecord(
    #         cost=request.cost,
    #         revenue=request.revenue,
    #         time_horizon=request.timeHorizon,
    #         roi_percent=request.roiPercent,
    #         break_even_months=request.breakEvenMonths,
    #         payment_status="completed",
    #         # ... other payment details from Stripe webhook or client confirmation
    #     )
    #     session.add(new_record)
    #     session.commit()

    return {"success": True, "message": "Payment record simulated successfully."}

# To run the application locally:
# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)