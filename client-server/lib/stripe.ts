import { loadStripe, type Stripe } from "@stripe/stripe-js"

let stripePromise: Promise<Stripe | null>

// Replace with your actual Stripe Publishable Key from your Stripe Dashboard.
// For production, this should ideally come from an environment variable (e.g., process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY).
const STRIPE_PUBLISHABLE_KEY = "YOUR_ACTUAL_STRIPE_PUBLISHABLE_KEY" // <-- REPLACE THIS LINE

export const getStripe = () => {
  if (!stripePromise) {
    stripePromise = loadStripe(STRIPE_PUBLISHABLE_KEY)
  }
  return stripePromise
}
