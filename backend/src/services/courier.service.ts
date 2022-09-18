import { CourierClient } from "@trycourier/courier";
import { access } from "fs";
import Stripe from "stripe";
import { ClothingItemI, ClothingItemId } from "../models/clothingItem.model";
import { File } from "../models/file.model";
import { OrderI } from "../models/order.model";
import { PurchaseI } from "../models/purchase.model";
import { UserI } from "../models/user.model";

const courier = CourierClient(
  { authorizationToken: "***REMOVED***" });


export async function sendTestEmail(): Promise<void> {
  console.log("Sending email");

  const { requestId } = await courier.send({
    message: {
      content: {
        title: "Welcome to Courier!",
        body: "Want to hear a joke? {{joke}}"
      },
      data: {
        joke: "Why was the JavaScript developer sad? Because they didn't Node how to Express themselves"
      },
      to: {
        email: "fits.devteam@gmail.com"
      }
    }
  });

  console.log("sent email,", "requestId", requestId);
}


export async function sendCashoutEmail(user: UserI, venmo: string): Promise<void> {
  console.log("Sending Venmo email");
  const { requestId } = await courier.send({
    message: {
      content: {
        title: "[FITS][Cashout Request] From: " + user.fullName,
        body: `The user: ${user.fullName} wants to cashout, their email is: ${user.email} \n their venmo is: ${venmo}`
      },
      data: {},
      to: {
        email: "fits.devteam@gmail.com"
      }
    }
  });

  console.log("sent email,", "requestId", requestId);
}


// Include the shippind address, and name from the stripe checkout
export async function sendOrderPlacedEmail(order: OrderI, session: Stripe.Checkout.Session): Promise<void> {
  console.log("Sending email");
  const user = order.user as UserI;
  let orderText =
    "Fits Name: {{name}} \n" +
    `Fits Username: {{username}} \n` +
    `Fits Email: {{email}} \n\n\n`;

  console.log(order.purchases.length);
  for (const purchase of (order.purchases as PurchaseI[])) {
    const _file = await File.findById((purchase.clothingItem as ClothingItemI).files![0]);

    const text =
      `Purchase Item:\n` +
      `Price: \$${((purchase).clothingItem as ClothingItemI).price} \n` +
      `Item: ${(purchase.clothingItem as ClothingItemI).name} \n` +
      `Size: ${(purchase).size} \n` +
      //@ts-ignore
      `Image URL: ${_file.url} \n` +
      `Purchase Link: ${(purchase.clothingItem as ClothingItemI).purchaseUrl} \n` +
      `Promo Code: ${(purchase.clothingItem as ClothingItemI).promoCode} \n` +

      `\n\n\n`;

    orderText += text;
  }

  orderText +=
    // Address
    `Stripe Email: \n` +
    `{{stripeEmail}} \n \n` +

    `Stripe Shipping Address: \n` +
    `{{stripeAddress}} \n \n \n`;

  const address = session.shipping!.address;
  // const [city, country, line1, line2, postal_code, state] = address;
  const city = address?.city;
  const country = address?.country;
  const line1 = address?.line1;
  const line2 = address?.line2;
  const postal_code = address?.postal_code;
  const state = address?.state;
  const addressString =
    "Country: " + country + "\n" +
    "Address Line 1: " + line1 + "\n" +
    "Address Line 2: " + line2 + "\n" +
    "Postal Code: " + postal_code + "\n" +
    "State: " + state + "\n" +
    "Shipping Name: " + session.shipping?.name;

  // shipping: {
  //   address: {
  //     city: 'Beverly Hills',
  //     country: 'US',
  //     line1: '9390 North Santa Monica Boulevard',
  //     line2: null,
  //     postal_code: '90210',
  //     state: 'CA'
  //   },
  //   name: 'Isaiah Antwan Gallimore'
  // },

  const { requestId } = await courier.send({
    message: {
      content: {
        title: "NEW ORDER - {{name}} placed an order",
        body: orderText,
      },
      data: {
        // Fits
        name: user.fullName,
        username: user.username,
        email: user.email,

        // Stripe
        stripeEmail: session.customer_email,
        stripeAddress: addressString,
      },
      to: {
        email: "fits.devteam@gmail.com"
      }
    }
  });

  // Send to Matt and Jacob
  try {
    await courier.send({
      message: {
        content: {
          title: "NEW ORDER - {{name}} placed an order",
          body: orderText,
        },
        data: {
          // Fits
          name: user.fullName,
          username: user.username,
          email: user.email,

          // Stripe
          stripeEmail: session.customer_email,
          stripeAddress: addressString,
        },
        to: {
          email: "Matt@thefits.app, jacobbildy@gmail.com"
        }
      }
    });
  }
  catch (error) { console.error(error); }


  console.log("sent email,", "requestId", requestId);
}


// sendEmail();