
import express, { Request, Response } from "express";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";

import * as PurchaseService from "../services/purchase.service";
import * as CashoutService from "../services/cashout.service";
import { findUserByEmail } from "../services/user.service";
import { ClothingItemI } from "../models/clothingItem.model";
import { PurchaseI } from "../models/purchase.model";
import { OutfitI } from "../models/outfit.model";

export const router = express.Router();


async function canCashout(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";

    const canCashout = await CashoutService.canCashout(req.user);
    return res.json(canCashout);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function createCashoutRequest(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";

    const user = await CashoutService.createCashoutRequest(req.user, req.params.venmo);
    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

router.post("/cashout/request/:venmo", userAuth, createCashoutRequest);
router.get("/cashout/can-cashout", userAuth, canCashout);