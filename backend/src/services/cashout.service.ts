import { User, UserI } from "../models/user.model";
import { Purchase, PurchaseI } from "../models/purchase.model";
import { Order, OrderI } from "../models/order.model";
import { findUserByEmail } from "./user.service";
import { POPULATE as clothing_populate } from "./clothingItem.service";
import { PURCHASE_POPULATE } from "./purchase.service";
import * as PurchaseService from "./purchase.service";
import { ClothingItemI } from "../models/clothingItem.model";
import { sendCashoutEmail } from "./courier.service";


export async function getStylistCommission(stylist: UserI): Promise<{ total: string, pending: string }> {
  const _total = await PurchaseService.getStylistPurchases(stylist);
  const _pending = await PurchaseService.getStylistUnpaidPurchases(stylist);

  let intTotal = 0;
  let intPending = 0;
  for (const _purchase of _total) {
    intTotal += (_purchase.clothingItem as ClothingItemI).price * 0.05;
  }
  for (const _purchase of _pending) {
    intPending += (_purchase.clothingItem as ClothingItemI).price * 0.05;
  }

  return { total: `$${intTotal.toFixed(2).toString()}`, pending: `$${intPending.toFixed(2).toString()}` };
}

export async function canCashout(user: UserI): Promise<boolean> {
  const { total, pending } = await getStylistCommission(user);
  console.log(total, pending);
  const pendingNumber = parseFloat(pending.replace("$", ""));
  console.log("the pending cashout ammount in ", pendingNumber.toPrecision(2));

  return !user.cashoutPending && (pendingNumber >= 5);
}

export async function createCashoutRequest(user: UserI, venmo: string): Promise<UserI> {
  if (!(await canCashout(user))) throw "Can't cashout user: " + user._id + ", email: " + user.email;
  await sendCashoutEmail(user, venmo);
  const _user = await User.findByIdAndUpdate(user, { cashoutPending: true }, { new: true });
  if (!_user) throw "Can't find user, " + user.toString();

  return _user;
}



