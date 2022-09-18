import { Model, ObjectId } from "mongoose";
import { ClothingItem, ClothingItemI, ClothingItemId, clothingTypes } from "../models/clothingItem.model";
import { FileI } from "../models/file.model";
import { OutfitI } from "../models/outfit.model";
import { SellerId } from "../models/seller.model";
import { User, UserI } from "../models/user.model";
import { uploadFile } from "./file.service";
import * as StripeService from "./stripe.service";
import * as ReveryService from "./revery.service";
import { Purchase, PurchaseI } from "../models/purchase.model";
import { getClothingItemsTypeMapByGender } from "./clothingItem.service";
import { Order, OrderI } from "../models/order.model";
import { findUserByEmail } from "./user.service";
import e from "express";
import { ORDER_POPULATE } from "./purchase.service";
import { sendPushNotification } from "./notifications.service";

// /clothing-items/item/:id
// /clothing-items/create
// /clothing-items/delete/:id

export const POPULATE = ["purchases", "user"];

export async function createOrder(user: UserI, purchases: PurchaseI[]): Promise<OrderI> {
  const order = await Order.create({ user, completed: false, testing: true });
  const _purchases = [];
  for (const purchase of purchases) {
    _purchases.push(Purchase.create({
      ...purchase,
      user,
      order,
      completed: false,
      testing: false,
    }));
  }

  const _results = await Promise.all(_purchases);

  const stripeSession = await StripeService.checkout(user, _results, order);
  const _order = await Order.findByIdAndUpdate(order, { stripeCheckoutSession: stripeSession.id, purchaseUrl: stripeSession.url ?? "" }, { new: true });

  if (!_order) throw Error("order failed to create");
  return _order;
}

export async function getOrderFromStripeSessionId(stripeSessionId: string): Promise<OrderI | null> {
  return await Order.findOne({ stripeCheckoutSession: stripeSessionId }).populate(ORDER_POPULATE).exec();
}

export async function markOrderAsPaid(order: OrderI): Promise<OrderI|null> {
  await Purchase.updateMany({ order }, { completed: true });

  const _order = await Order.findByIdAndUpdate(order, { completed: true }, { new: true });
  if (!_order) throw Error("order failed to create");

  console.log("Marked Order as Paid.")
  console.log(order.purchases.length);
  for (const item of (order.purchases as PurchaseI[])) {
    console.log("iterating through items...")
    const _purchase = await Purchase.findById(item);

    if (_purchase === null) {
      return null;
    }
    const _stylist = await User.findById(_purchase.stylist);
    if (_stylist === null) {
      return null;
    }
    const _user = await User.findById(_order.user);
    const _clothingItem = await ClothingItem.findById(_purchase.clothingItem);
    if (_clothingItem === null) {
      return null;
    }
    console.log(`Sending a notification to: ${_stylist.fullName}`)
    console.log(`Notification => Someone bought an item from your outfit. You made $${(_clothingItem.price * 0.05).toFixed(2)}`);
    sendPushNotification(
      [_stylist.deviceToken], "New Purchase",
      `Someone bought an item from your outfit. You made $${(_clothingItem.price * 0.05).toFixed(2)}`,
      {}, true, null
    );
  }

  return _order;
}


// Search for and return a clothing items by text.
export async function getTestingOrder(user: UserI): Promise<OrderI> {
  // const isaiah = await findUserByEmail("isaiahballah@gmail.com");
  const order = await Order.create({ user, completed: false, testing: true });
  return order;
}

async function createTestingPurchase(order: OrderI, clothingItem: ClothingItemI, size: string): Promise<PurchaseI> {
  return await Purchase.create({
    order,
    clothingItem,
    size,
    user: order.user,
    completed: false,
    testing: true,
  });
}


export async function getRandomPurchases(gender: "Men" | "Women", user: UserI): Promise<{ purchases: PurchaseI[], order: OrderI } | null> {
  const clothes = await getClothingItemsTypeMapByGender(gender);
  const tops = [
    ...clothes.Hoodies,
    ...clothes.Sweatshirts,
    ...clothes["Long-Sleeves"],
    ...clothes.Pantsuits,
  ];

  const bottoms = [
    ...clothes.Pants,
    ...clothes.Jeans,
    ...clothes.Sweatpants,
    ...clothes.Shorts,
    ...clothes.Skirts,
  ];

  const item1: ClothingItemI = tops[random(0, tops.length - 1)];
  const item2: ClothingItemI = tops[random(0, tops.length - 1)];
  const item3: ClothingItemI = bottoms[random(0, bottoms.length - 1)];
  const item4: ClothingItemI = bottoms[random(0, bottoms.length - 1)];

  const order = await getTestingOrder(user);

  const purchase1 = createTestingPurchase(order, item1, randomSize(item1) ?? "N/A");
  const purchase2 = createTestingPurchase(order, item2, randomSize(item1) ?? "N/A");
  const purchase3 = createTestingPurchase(order, item3, randomSize(item1) ?? "N/A");
  const purchase4 = createTestingPurchase(order, item4, randomSize(item1) ?? "N/A");

  const purchases: PurchaseI[] = await Promise.all([purchase1, purchase2, purchase3, purchase4]);
  return { purchases, order };
}

export function randomSize(clothingItem: ClothingItemI): string {
  const sizes = clothingItem.sizesInStock.split(",");
  return sizes[random(0, sizes.length - 1)]
}

export function random(min: number, max: number): number { // min and max included 
  return Math.floor(Math.random() * (max - min + 1) + min)
}

//TODO upload photos to clothing item.
