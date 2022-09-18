
import express, { Response, Request } from "express";
import * as OrderService from "../services/order.service";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";
import stripe from "../connections/stripe.client";
import Stripe from 'stripe';
import dotenv from "dotenv";
import { sendOrderPlacedEmail } from "../services/courier.service";
dotenv.config();


// import * as getRawBody from 'raw-body';

export const router = express.Router();
// This is your Stripe CLI webhook secret for testing your endpoint locally.
// const endpointSecret = "***REMOVED***";
const ENDPOINT_SECERT = process.env.STRIPE_TESTING ? process.env.STRIPE_ENDPOINT_TEST : process.env.STRIPE_ENDPOINT;
if (!ENDPOINT_SECERT) throw "ENDPOINT_SECERT is undefined";

async function webhook(request: RequestI, response: Response) {
  if (!ENDPOINT_SECERT) throw "ENDPOINT_SECERT is undefined";

  const sig = request.headers['stripe-signature'];
  let event;

  try {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    event = stripe.webhooks.constructEvent(request.rawBody!, sig!, ENDPOINT_SECERT);
  } catch (err) {
    console.log(err);
    response.status(400).send(`Webhook Error: ${err}`);
    return;
  }

  console.log();
  console.log("~~~ event.type ~~~", event.type);

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      // Then define and call a function to handle the event payment_intent.succeeded
      onPaymentIntentSucceeded(event.data.object);
      break;

    case 'checkout.session.completed':
      onCheckoutCompleted(event.data.object);
      // Then define and call a function to handle the event checkout.session.completed
      break;
      
      // ... handle other event types
      default:
      console.log(`~~~ Unhandled stripe event type: ${event.type} ~~~`);
      console.log();
  }

  // Return a 200 response to acknowledge receipt of the event
  response.send();
};

async function onPaymentIntentSucceeded(paymentIntent: Stripe.Event.Data.Object): Promise<void> {
  // console.log("~~~ onPaymentIntentSucceeded ~~~", paymentIntent);
}

async function onCheckoutCompleted(session: Stripe.Event.Data.Object): Promise<void> {
  console.log();
  console.log();
  console.log("~~~~ onCheckoutCompleted ~~~", session);
  console.log();
  try {
    const _session = (session as Stripe.Checkout.Session);
    console.log("session id", _session.id);
    
    const order = await OrderService.getOrderFromStripeSessionId(_session.id);
    if (!order) throw "failed to get order from session";
    console.log(order);
    await OrderService.markOrderAsPaid(order);
    sendOrderPlacedEmail(order, _session);
  }
  catch(error) {
    console.error(error);
  }
}


async function createOrder(req: RequestI, res: Response ) {
  try {
    if (!req.user) throw "no user sheeeeeeeeesh";
    // console.log("Route: ", req.body.purchases);
    const purchases = JSON.parse(req.body.purchases);
    // console.log(purchases);
    const order = await OrderService.createOrder(req.user, purchases);
    // return res.send("lol.ca");
    return res.json(order);

  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

// stripe listen --forward-to localhost:8000/api/stripe/webhook
router.post('/stripe/webhook', express.raw({ type: 'application/json' }), webhook);
router.post('/stripe/checkout/', userAuth, createOrder);

