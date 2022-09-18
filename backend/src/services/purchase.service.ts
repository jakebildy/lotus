import { UserI } from "../models/user.model";
import { Purchase, PurchaseI } from "../models/purchase.model";
import { Order, OrderI } from "../models/order.model";
import { findUserByEmail } from "./user.service";

// /clothing-items/item/:id
// /clothing-items/create
// /clothing-items/delete/:id

// export const POPULATE = ["purchases", "user"];
export const PURCHASE_POPULATE = [
  'user', "stylist", 
  {
    path: 'outfit',
    populate: [
      "stylist",
      {
        path: 'clothingItems',
        populate: [
          "seller",
          "files",
        ]
      },
    ]
  },
  {
    path: 'clothingItem',
    populate: [
      "seller",
      "files",
    ]
  },
];

export const ORDER_POPULATE = [
  {
    path: "purchases",
    populate: PURCHASE_POPULATE
  },
  "user",
];

export async function getUsersPurchases(user: UserI): Promise<PurchaseI[]> {
  return await Purchase.find({user, completed: true}).populate(PURCHASE_POPULATE).exec();
}

export async function getStylistPurchases(stylist: UserI): Promise<PurchaseI[]> {
  return await Purchase.find({stylist, completed: true}).populate(PURCHASE_POPULATE).exec();
}

// export async function getStylistCommission(stylist: UserI): Promise<{total: string, pending: string}> {
//   const _total = await Purchase.find({stylist, completed: true}).populate(PURCHASE_POPULATE).exec();
//   const _pending = await Purchase.find({stylist, completed: true, stylistPaid: false}).populate(PURCHASE_POPULATE).exec();
//   let intTotal = 0;
//   let intPending = 0;
//   for (const _purchase of _total) {
//     intTotal += _purchase.clothingItem.price * 0.05;
//   }
//   for (const _purchase of _pending) {
//     intPending += _purchase.clothingItem.price * 0.05;
//   }

//   return {total: `$${intTotal.toFixed(2).toString()}`, pending: `$${intPending.toFixed(2).toString()}`};
// }

// export async function canCashout(user: UserI): Promise<boolean> {
//   return true;
// }

// export async function createCashoutRequest(user: UserI): Promise<UserI> {
//   return user;
// }


export async function getStylistUnpaidPurchases(stylist: UserI): Promise<PurchaseI[]> {
  return await Purchase.find({stylist, stylistPaid: false, completed: true}).populate(PURCHASE_POPULATE).exec();
}

export async function getUsersOrders(user: UserI): Promise<OrderI[]> {
  return await Order.find({user, completed: true}).populate(ORDER_POPULATE).exec();
}


