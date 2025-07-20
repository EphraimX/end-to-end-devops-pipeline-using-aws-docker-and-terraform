"use client"

import { useState, type FormEvent } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Checkbox } from "@/components/ui/checkbox"
import { Label } from "@/components/ui/label"

// This component will be wrapped by <Elements>
function CheckoutForm() {

  const [cost, setCost] = useState<number | "">("")
  const [revenue, setRevenue] = useState<number | "">("")
  const [timeHorizon, setTimeHorizon] = useState<number | "">("")
  const [includePdf, setIncludePdf] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [roiPercent, setRoiPercent] = useState<string | null>(null)
  const [breakEvenMonths, setBreakEvenMonths] = useState<string | null>(null)
  const [showResults, setShowResults] = useState(false)
  const [calculationSuccessful, setCalculationSuccessful] = useState(false)
  const APIURL = "https://8000-ephraimx-staticroicalcu-ar07kphbms7.ws-eu120.gitpod.io/api"

  const handleSubmit = async (e: FormEvent) => {
    
    e.preventDefault()

    setIsLoading(true)
    setMessage(null)
    setShowResults(false)
    setRoiPercent(null)
    setBreakEvenMonths(null)

    const currentCost = Number(cost)
    const currentRevenue = Number(revenue)
    const currentTimeHorizon = Number(timeHorizon)

    if (isNaN(currentCost) || isNaN(currentRevenue) || isNaN(currentTimeHorizon) || currentTimeHorizon <= 0) {
      setMessage("Please enter valid numbers for all fields.")
      setIsLoading(false)
      return
    }

    // --- Call API for ROI Calculation ---
    try {
      const roiResponse = await fetch(`${APIURL}/calculate-roi`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ cost: currentCost, revenue: currentRevenue, timeHorizon: currentTimeHorizon }),
      })

      const roiData = await roiResponse.json()

      if (!roiResponse.ok) {
        setMessage(roiData.error || "Failed to calculate ROI.")
        setIsLoading(false)
        return
      }

      setRoiPercent(roiData.roiPercent)
      setBreakEvenMonths(roiData.breakEvenMonths)
      setCalculationSuccessful(true)
      setShowResults(true)
      

      try {
        const recordResponse = await fetch(`${APIURL}/recordEntry`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            cost: currentCost,
            revenue: currentRevenue,
            timeHorizon: currentTimeHorizon,
            roiPercent: roiData.roiPercent,
            breakEvenMonths: roiData.breakEvenMonths,
            date: new Date().toISOString(),
          }),
        })

        const recordData = await recordResponse.json()
        if (!recordResponse.ok) {
          console.error("Failed to record payment:", recordData.error)
        } else {
          console.log("Payment record API response:", recordData.message)
        }
      } catch (recordError) {
        console.error("Error calling record payment API:", recordError)
      }

      setMessage("Calculation complete!")
      
    } catch (error) {
      console.error("Error fetching ROI calculation:", error)
      setMessage("An error occurred during ROI calculation.")
      setIsLoading(false)
      return
    }


    if (calculationSuccessful) {

      try {
        const recordResponse = await fetch(`${APIURL}/recordEntry`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            cost: currentCost,
            revenue: currentRevenue,
            timeHorizon: currentTimeHorizon,
            roiPercent: roiPercent, 
            breakEvenMonths: breakEvenMonths, 
            date: new Date().toISOString(),
          }),
        })

        const recordData = await recordResponse.json()
        if (!recordResponse.ok) {
          console.error("Failed to record payment:", recordData.error)
          // Optionally update message to user about record failure, but payment was successful
        } else {
          console.log("Payment record API response:", recordData.message)
        }
      } catch (recordError) {
        console.error("Error calling record payment API:", recordError)
      }
    } else {
      setMessage("Calculation complete!")
    }

    setIsLoading(false)
  }

  return (
    <Card className="w-full max-w-md mx-auto rounded-xl shadow-2xl overflow-hidden bg-white border border-neutral-200">
      <CardHeader className="bg-neutral-800 p-6 text-white">
        <CardTitle className="text-center text-3xl font-extrabold">ROI Calculator</CardTitle>
      </CardHeader>
      <CardContent className="p-6">
        <form id="roi-form" onSubmit={handleSubmit} className="space-y-6">
          <div className="form-group">
            <Label htmlFor="cost" className="block text-sm font-medium text-neutral-700 mb-1">
              Cost ($)
            </Label>
            <Input
              id="cost"
              name="cost"
              type="number"
              step="0.01"
              required
              min="0"
              value={cost}
              onChange={(e) => setCost(e.target.value === "" ? "" : Number(e.target.value))}
              className="mt-1 block w-full px-4 py-2 border border-neutral-300 rounded-lg shadow-sm focus:ring-neutral-500 focus:border-neutral-500 sm:text-sm transition duration-200 ease-in-out focus:outline-none"
            />
          </div>
          <div className="form-group">
            <Label htmlFor="revenue" className="block text-sm font-medium text-neutral-700 mb-1">
              Projected Revenue ($/month)
            </Label>
            <Input
              id="revenue"
              name="revenue"
              type="number"
              step="0.01"
              required
              min="0"
              value={revenue}
              onChange={(e) => setRevenue(e.target.value === "" ? "" : Number(e.target.value))}
              className="mt-1 block w-full px-4 py-2 border border-neutral-300 rounded-lg shadow-sm focus:ring-neutral-500 focus:border-neutral-500 sm:text-sm transition duration-200 ease-in-out focus:outline-none"
            />
          </div>
          <div className="form-group">
            <Label htmlFor="time-horizon" className="block text-sm font-medium text-neutral-700 mb-1">
              Time Horizon (months)
            </Label>
            <Input
              id="time-horizon"
              name="time-horizon"
              type="number"
              required
              min="1"
              value={timeHorizon}
              onChange={(e) => setTimeHorizon(e.target.value === "" ? "" : Number(e.target.value))}
              className="mt-1 block w-full px-4 py-2 border border-neutral-300 rounded-lg shadow-sm focus:ring-neutral-500 focus:border-neutral-500 sm:text-sm transition duration-200 ease-in-out focus:outline-none"
            />
          </div>
          

          <Button
            type="submit"
            id="submit-button"
            className="w-full py-3 text-lg font-semibold bg-neutral-800 hover:bg-neutral-900 text-white rounded-lg shadow-lg transition duration-300 ease-in-out transform hover:-translate-y-1 disabled:opacity-60 disabled:cursor-not-allowed"
            // disabled={isLoading || !stripe || (includePdf && !elements)}
          >
            {isLoading ? "Processing..." : "Calculate"}
          </Button>

          {message && (
            <div
              className={`message mt-4 p-4 rounded-lg text-base font-medium ${message.includes("failed") ? "bg-red-100 text-red-700 border border-red-200" : "bg-green-100 text-green-700 border border-green-200"}`}
            >
              {message}
            </div>
          )}

          {showResults && (
            <div
              id="results"
              className="results mt-6 p-6 bg-neutral-50 border border-neutral-200 rounded-lg text-left shadow-md"
            >
              <h2 className="text-2xl font-bold text-neutral-800 mb-4">Calculation Results</h2>
              <p className="text-lg text-neutral-700 mb-2">
                <strong>ROI:</strong> {roiPercent}
              </p>
              <p className="text-lg text-neutral-700 mb-2">
                <strong>Break-even:</strong> {breakEvenMonths} months
              </p>
            </div>
          )}
        </form>
      </CardContent>
    </Card>
  )
}

export default function RoiCalculatorForm() {
  // In a real application, the clientSecret would be fetched from your backend
  // before rendering <Elements>. This backend endpoint would create a PaymentIntent
  // for $1.00 (100 cents) if the PDF upgrade is selected.
  const mockClientSecret = "pi_3PZ011Rtv21234567890abcdefg_secret_abcdefgHIJKLMNOPQRSTUVWXY" // Replace with a real client secret from your server

  return (
      <CheckoutForm />
  )
}
