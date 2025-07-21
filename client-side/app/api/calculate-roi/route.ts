import { NextResponse } from "next/server"

export async function POST(request: Request) {
  try {
    const { cost, revenue, timeHorizon } = await request.json()

    const currentCost = Number(cost)
    const currentRevenue = Number(revenue)
    const currentTimeHorizon = Number(timeHorizon)

    if (isNaN(currentCost) || isNaN(currentRevenue) || isNaN(currentTimeHorizon) || currentTimeHorizon <= 0) {
      return NextResponse.json({ error: "Please enter valid numbers for all fields." }, { status: 400 })
    }

    // --- ROI Calculation ---
    const totalRevenue = currentRevenue * currentTimeHorizon
    const netProfit = totalRevenue - currentCost
    let calculatedRoiPercent = 0
    if (currentCost > 0) {
      calculatedRoiPercent = (netProfit / currentCost) * 100
    } else if (netProfit > 0) {
      // If cost is 0 but there's profit, ROI is infinite
      calculatedRoiPercent = Number.POSITIVE_INFINITY
    }

    let calculatedBreakEvenMonths = "N/A"
    if (currentRevenue > 0) {
      calculatedBreakEvenMonths = (currentCost / currentRevenue).toFixed(2)
    } else if (currentCost > 0) {
      // If cost > 0 but revenue is 0, never breaks even
      calculatedBreakEvenMonths = "Never"
    } else {
      // If cost and revenue are both 0, already broken even
      calculatedBreakEvenMonths = "0"
    }

    const roiPercent =
      calculatedRoiPercent === Number.POSITIVE_INFINITY ? "Infinite" : calculatedRoiPercent.toFixed(2) + "%"
    const breakEvenMonths = calculatedBreakEvenMonths

    return NextResponse.json({ roiPercent, breakEvenMonths })
  } catch (error) {
    console.error("Error calculating ROI:", error)
    return NextResponse.json({ error: "Internal Server Error" }, { status: 500 })
  }
}
