import { Model, ObjectId } from "mongoose";
import { ClothingItem, ClothingItemI, ClothingItemId, clothingTypes } from "../models/clothingItem.model";
import { FileI } from "../models/file.model";
import { OutfitI } from "../models/outfit.model";
import { SellerId } from "../models/seller.model";
import { UserI } from "../models/user.model";
import { uploadFile } from "./file.service";
import * as StripeService from "./stripe.service";
import * as ReveryService from "./revery.service";
import { PurchaseI } from "../models/purchase.model";

// /clothing-items/item/:id
// /clothing-items/create
// /clothing-items/delete/:id

export const POPULATE = ["files", "seller"];

// Search for and return a clothing items by text.
export async function searchClothingItems(text: string): Promise<ClothingItemI[]> {
  return await ClothingItem.find({ $text: { $search: text }, }).populate(POPULATE).exec();;
}

// Search for and return a clothing items by text and type.
export async function searchClothingItemsByTextAndType(text: string, clothingType: string): Promise<ClothingItemI[]> {
  return await ClothingItem.find({ $text: { $search: text }, clothingType }).populate(POPULATE).exec();;
}

export interface ClothingItemsByType {
  [key: string]: ClothingItemI[];
}

// Search for and return a clothing items by text and type.
export async function getClothingItemsTypeMap(): Promise<ClothingItemsByType> {
  const typeMap: ClothingItemsByType = {};
  for (const clothingType of clothingTypes) {
    typeMap[clothingType] = await ClothingItem.find({ clothingType }).populate(POPULATE).exec();
  }

  return typeMap;
}


export async function getClothingItemsTypeMapByGender(gender: string): Promise<ClothingItemsByType> {
  const typeMap: ClothingItemsByType = {};
  for (const clothingType of clothingTypes) {
    typeMap[clothingType] = await ClothingItem.find({ clothingType, gender, reveryUploaded: true }).populate(POPULATE).exec();
  }
  return typeMap;
}

// Search for and return a clothing item by id.
export async function addImage(clothingItem: ClothingItemId, fileName: string, base64: string): Promise<ClothingItemI | null> {
  const item = await ClothingItem.findById(clothingItem);
  if (!item) throw "No item found";
  if (item == undefined) throw "No item found";

  // eslint-disable-next-line no-useless-escape
  const matches = base64.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/);//,  response = {};

  if (matches?.length !== 3) {
    throw new Error('Invalid input string');
  }

  const _data = matches[2];
  const file: FileI | null = await uploadFile({ name: fileName, data: _data } as FileI, null);
  if (!file) throw "Failed to upload avatar";

  await ClothingItem.findByIdAndUpdate(clothingItem, { $push: { files: file } });
  const _clothingItem: ClothingItemI|null = await ClothingItem.findById(clothingItem).populate(POPULATE).exec();

  if (_clothingItem) {
    StripeService.updateProduct(_clothingItem);
    ReveryService.uploadEntireCatalog();
  }


  return _clothingItem;
}

// Search for and return a clothing item by id.
export async function getById(clothingItem: ClothingItemId): Promise<ClothingItemI | null> {
  return await ClothingItem.findById(clothingItem).populate(POPULATE).exec();
}

// Search for and return a clothing item by id.
export async function editItem(clothingItem: ClothingItemId, update: ClothingItemI): Promise<ClothingItemI | null> {
  return await ClothingItem.findByIdAndUpdate(clothingItem, {
    name: update.name,

    description: update.description,
    sizesInStock: update.sizesInStock,
    sizes: update.sizes,
    price: update.price,

    gender: update.gender,
    clothingType: update.clothingType,
    purchaseUrl: update.purchaseUrl,
    overlayURLs: update.overlayURLs,
    torsoOverlayURLs: update.torsoOverlayURLs,
    saleAmount: update.saleAmount,
    dontGoToRevery: update.dontGoToRevery,
    itemsPageIndex: update.itemsPageIndex,
    reviews: update.reviews,
    shippingCost: update.shippingCost,
    videoURL: update.videoURL,

    tags: update.tags,
    promoCode: update.promoCode,
    saleIsFinal: update.saleIsFinal,
  }, { new: true }).populate(POPULATE).exec();
}

export async function deleteImage(clothingItem: ClothingItemId, fileId: string): Promise<ClothingItemI | null> {
  return await ClothingItem.findByIdAndUpdate(clothingItem, { $pull: { files: fileId } }, { new: true });
}

// Get all clothing items.
export async function getClothingItems(): Promise<ClothingItemI[]> {
  return await ClothingItem.find().populate(POPULATE).exec();
}

// Get all clothing items.
export async function getClothingItemsByIds(ids: string[]): Promise<ClothingItemI[]> {
  return await ClothingItem.find({ _id: { $in: ids } }).populate(POPULATE).exec();
}

// Search for and return a clothing item by id.
export async function getBrandsClothingItems(seller: SellerId): Promise<ClothingItemI[]> {
  return await ClothingItem.find({ seller }).populate(POPULATE).exec();
}

// Create a clothing item.
export async function createClothingItem(
  name: string,
  seller: SellerId,
  description: string,
  sizesInStock: string[],
  price: number,
  overlayURLs: string[],
  torsoOverlayURLs: string[],
  saleAmount: number,
  dontGoToRevery: boolean,
  itemsPageIndex: number,
  reviews: string,
  shippingCost: number,
  videoURL: string,
): Promise<ClothingItemI | null> {
  const item = await ClothingItem.create({ name, seller, description, sizesInStock, price, overlayURLs, torsoOverlayURLs, saleAmount, dontGoToRevery, itemsPageIndex, reviews, shippingCost, videoURL });
  await StripeService.createProduct(item);
  return item;
}

export async function createClothingItemFromBody(body: ClothingItemI): Promise<ClothingItemI | null> {
  const item = await ClothingItem.create(body);
  await StripeService.createProduct(item);
  return item;
}

// Delete a clothing item.
export async function deleteClothingItem(clothingItem: ClothingItemId): Promise<ClothingItemI | null> {
  const item = await ClothingItem.findByIdAndDelete(clothingItem).populate(POPULATE).exec();

  if (item !== null ) {
    await StripeService.createProduct(item);
  }
  return item;
}


// REVERY processing
export async function markAsReveryUploaded(clothingItem: ClothingItemId, reveryId: string): Promise<ClothingItemI | null> {
  return await ClothingItem.findByIdAndUpdate(clothingItem, { reveryUploaded: true, reveryId }, { new: true }).populate(POPULATE).exec();
}

// "Tops",
// "Hoodies",
// "Sweatshirts",
// "Long-Sleeves",
// "Pants",
// "Jeans",
// "Sweatpants",
// "Shorts",
// "Skirts",
// "Jackets",
// "Dresses",
// "Pantsuits",


// tops, bottoms, outerwear, allbody
// pants, shorts, skirts
export async function getRandomOutfit(gender: "Men" | "Women"): Promise<ClothingItemI[] | null> {
  const clothes = await getClothingItemsTypeMapByGender(gender);
  const tops = [
    // ...clothes.Top,
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
  // const outerwear = [...clothes.Jackets];
  // const allbody = [...clothes.Dresses];

  const outfit = [];
  outfit.push(tops[random(0, tops.length - 1)]);
  outfit.push(bottoms[random(0, bottoms.length - 1)]);
  return outfit;
}

export function random(min: number, max: number): number { // min and max included 
  return Math.floor(Math.random() * (max - min + 1) + min)
}

//TODO upload photos to clothing item.
