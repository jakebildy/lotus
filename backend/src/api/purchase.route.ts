
import express, { Request, Response } from "express";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";

import * as PurchaseService from "../services/purchase.service";
import * as CashoutService from "../services/cashout.service";
import { findUserByEmail } from "../services/user.service";
import { ClothingItemI } from "../models/clothingItem.model";
import { PurchaseI } from "../models/purchase.model";
import { OutfitI } from "../models/outfit.model";
import { sendCashoutEmail } from "../services/courier.service";

export const router = express.Router();

async function getMyPurchases(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";

    const purchases = await PurchaseService.getUsersPurchases(req.user);
    return res.json(purchases);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}
async function getMyOrders(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";

    const purchases = await PurchaseService.getUsersOrders(req.user);
    return res.json(purchases);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}
async function earnings(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";

    const earnings = await CashoutService.getStylistCommission(req.user);
    return res.json(earnings);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}
async function stylistsPurchases(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";

    const purchases = await PurchaseService.getStylistPurchases(req.user);
    return res.json(purchases);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function test() {
  try {
    const user = await findUserByEmail("isaiahballah@gmail.com");
    if (!user) return console.log("no user");

    const purchases = await PurchaseService.getStylistPurchases(user);
    // const orders = await PurchaseService.getStylistPurchases(user);
    // console.log(purchases);
    for (const purchase of purchases) {
      // console.log(order.createdAt);
      // for (const purchase of order.purchases) {
      console.log(((purchase as PurchaseI).clothingItem as ClothingItemI).name);
      // console.log(((purchase as PurchaseI).outfit as OutfitI).clothingItems);
      // }
    }
    // for (const purchase of purchases) {
    //   console.log(purchase);
    // }
    // console.log(purchases.map(item=>(item.clothingItem as ClothingItemI).name));
    const earnings = await CashoutService.getStylistCommission(user);
    console.log(earnings);

    // sendCashoutEmail(user, "IsaiahVenmo");
    // await CashoutService.createCashoutRequest(user, "IsaiahVenmo");

  } catch (error) {
    console.error(error);
  }

}
// test();

// router.post("/outfits/generate-image", generateOutfitImage);
router.get("/purchases/my", userAuth, getMyPurchases);
router.get("/orders/my", userAuth, getMyOrders);

router.get("/purchases/earnings", userAuth, earnings);
router.get("/purchases/stylist/", userAuth, stylistsPurchases);