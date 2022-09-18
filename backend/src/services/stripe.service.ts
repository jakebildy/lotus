import dotenv from "dotenv";
import { json } from "express";
import Stripe from "stripe";
dotenv.config();
// import { Seller, SellerI, SellerId } from "../models/seller.model";

import stripe from "../connections/stripe.client";
import { ClothingItemI } from "../models/clothingItem.model";
import { FileI, FileId } from "../models/file.model";
import { OrderI } from "../models/order.model";
import { PurchaseI } from "../models/purchase.model";
import { UserI } from "../models/user.model";
import { getClothingItems, getRandomOutfit } from "./clothingItem.service";
import { createOrder, getRandomPurchases } from "./order.service";
import { sleep } from "./revery.service";
import { findUserByEmail } from "./user.service";

export async function createProduct(clothingItem: ClothingItemI): Promise<Stripe.Product> {

  let _exists = true;

  try {
    return await stripe.products.retrieve(clothingItem._id?.toString() ?? "");
  } catch (error) {
    _exists = false;
  }

  if (_exists) {
    return _exists;
  }

  // clothingItem.files
  const product: Stripe.Product = await stripe.products.create({
    name: clothingItem.name,
    id: clothingItem._id?.toString(),
    description: clothingItem.description,
    images: (clothingItem.files ?? []).slice(0, 8).map((file) => {
      return (file as FileI).url;
    }),
  });

  const price = await stripe.prices.create({
    unit_amount: Math.ceil(clothingItem.price * 100),
    currency: 'usd',
    product: product.id,
    tax_behavior: "exclusive",
  });

  return product;
}

export async function updateProduct(clothingItem: ClothingItemI): Promise<Stripe.Product> {
  // clothingItem.files

  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const product: Stripe.Product = await stripe.products.update(clothingItem._id!.toString(), {
    name: clothingItem.name,
    description: clothingItem.description,
    images: (clothingItem.files ?? []).slice(0, 8).map((file) => {
      return (file as FileI).url;
    }),
  });

  console.log(product);
  return product;
}

export async function deleteProduct(clothingItem: ClothingItemI): Promise<Stripe.DeletedProduct | null> {
  try {
    const product: Stripe.DeletedProduct = await stripe.products.del(clothingItem._id?.toString() ?? "");
    console.log("deleted stripe product: ", product.id);
    return product;
  }
  catch (error) {
    console.log(error);
  }
  return null;
}


async function getLineItems(purchases: PurchaseI[]): Promise<{ price: string; quantity: number; description: string }[]> {
  const promises: Promise<Stripe.Response<Stripe.ApiList<Stripe.Price>>>[] = [];
  const items = [];

  for (const purchase of purchases) {
    if (!purchase.clothingItem) continue;

    const prices = stripe.prices.list({
      limit: 1,
      product: (purchase.clothingItem as ClothingItemI)._id?.toString(),
    });

    // console.log("prices: ", await prices);
    promises.push(prices);

    items.push({ purchase, prices });
  }
  const prices = await Promise.all(promises);
  const lineItems = items.map(async (item) => {

    return {
      price: (await item.prices).data[0].id,
      quantity: 1,
      description: item.purchase.size,
    };
  });

  return Promise.all(lineItems);
}

async function getPromoCodesAndPurchaseLinks(purchases: PurchaseI[]): Promise<{ promoCode: string; purchaseUrl: string; }[]> {
  const lineItems = purchases.map((purchase) => {
    console.log("😵purchase", purchase.clothingItem);
    return {
      promoCode: (purchase.clothingItem as ClothingItemI).promoCode,
      purchaseUrl: (purchase.clothingItem as ClothingItemI).purchaseUrl,
    };
  });
  return lineItems;
}

export async function checkout(user: UserI, purchases: PurchaseI[], order: OrderI): Promise<Stripe.Response<Stripe.Checkout.Session>> {

  const lineItems = await getLineItems(purchases);
  const metadata: { [key: string]: string } = {
    "user": user._id?.toString() ?? "",
  };

  const promoCodesAndPurchaseLinks = await getPromoCodesAndPurchaseLinks(purchases);
  for (let i = 0; i < promoCodesAndPurchaseLinks.length; i++) {
    metadata["promoCode_" + i] = promoCodesAndPurchaseLinks[i].promoCode;
    metadata["purchaseUrl_" + i] = promoCodesAndPurchaseLinks[i].purchaseUrl;
  }

  const session = await stripe.checkout.sessions.create({
    customer_email: user.email,
    payment_method_types: ['card'],
    line_items: lineItems,
    mode: 'payment',
    success_url: `https://thefits.app/order/success/?order_id=${order._id}session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: 'https://thefits.app/order/failure/',
    automatic_tax: { enabled: true },
    shipping_address_collection: {
      allowed_countries: ["US", "CA"],
    },
    // metadata,
    // metadata: { "test": "test" },
    payment_intent_data: {
      metadata,
    },
  });

  return session;
}

async function uploadCatalogToStripe(): Promise<void> {
  await sleep(2);
  const clothingItems = await getClothingItems();
  let count = 0;
  console.log("uploading catalog to stripe");

  for (const clothingItem of clothingItems) {
    try {
      const product = await createProduct(clothingItem);
      count++;
      console.log("uploaded product to stripe ", count, " / ", clothingItems.length, " id: ", product.id);
      // await sleep(1);
    } catch (error) {
      console.error(error);
    }
  }
}
// uploadCatalogToStripe();

export async function run(): Promise<void> {
  try {

    console.log("cool");
    const isaiah = await findUserByEmail("isaiahballah@gmail.com");
    if (!isaiah) return console.log("failed to create test checkout session - no user");

    const randomOrder = await getRandomPurchases("Men", isaiah);
    if (!randomOrder) throw "no random order, its null";

    if (!randomOrder.purchases) return console.log("failed to create test checkout session");

    // const session = await checkout(isaiah, randomOrder.purchases);

    const purchases = randomOrder.purchases.map((_purchase) => {
      return {
        ..._purchase,
        clothingItem: (_purchase.clothingItem as ClothingItemI)._id,
        size: _purchase.size,
      }
    });

    const _order = await createOrder(isaiah, (purchases as PurchaseI[]));
    // console.log("ORDER", _order);

    console.log("~~~ session url: ", _order.purchaseUrl);
    console.log("~~~ session id: ", _order.stripeSessionId);
  } catch (error) {
    console.error(error);
  }
}
// run();

async function setAutomaticTaxBehavouir(startingAfter?: string) {
  try {
    const prices = await stripe.prices.list(
      startingAfter ? { starting_after: startingAfter } : {}
    );
    let lastId = "";
    for (const price of prices.data) {
      // price.
      const _price = await stripe.prices.update(
        price.id,
        { tax_behavior: "exclusive" }
      );
      lastId = price.id;
    }

    if (prices.has_more) {
      setAutomaticTaxBehavouir(startingAfter = lastId);
    }

  }
  catch (error) {

    console.log("error setting automatic tax behavouir", error);
  }
}

// setAutomaticTaxBehavouir("");
