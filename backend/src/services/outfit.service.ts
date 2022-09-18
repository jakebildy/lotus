import { ObjectId } from "mongoose";
import { ClothingItem, ClothingItemI } from "../models/clothingItem.model";
import { Like } from "../models/like.model";
import { Outfit, OutfitI } from "../models/outfit.model";
import { UserI } from "../models/user.model";
import * as ReveryService from "./revery.service";
// import { POPULATE as clothing_populate } from "./clothingItem.service";

// /clothing-items/item/:id
// /clothing-items/create
// /clothing-items/delete/:id

type UserOrId = string | ObjectId | UserI;
type OutfitOrId = string | ObjectId | OutfitI;

export const POPULATE = [
  "stylist",
  {
    path: 'clothingItems',
    populate: ["files", "seller"]
  },
  "numLikes"
];

// Search for and return a outfit by id.
export async function getById(outfit: OutfitOrId): Promise<OutfitI | null> {
  return await Outfit.findById(outfit).populate(POPULATE).exec();
}


// Search for and return a outfit by id.
export async function getAll(): Promise<OutfitI[]> {
  return await Outfit.find().populate(POPULATE).exec();
}

// Search for and return a outfit by id.
export async function getOutfitsWithItem(itemId: string): Promise<OutfitI[]> {
  return await Outfit.find({ clothingItems: itemId }).populate(POPULATE).exec();
}

// Search for and return a outfit by id.
export async function getByGender(gender: string): Promise<OutfitI[]> {
  return await Outfit.find({ gender }).populate(POPULATE).exec();
}

// Search for and return a outfit by id.
export async function getByStylist(stylist: UserOrId): Promise<OutfitI[]> {
  return await Outfit.find({ stylist }).populate(POPULATE).exec();
}

// Create a outfit.
export async function createOutfit(
  stylist: UserOrId,
  clothingItemIds: string[],
  modelId: string,
  gender: string,
  tuckIn: boolean,
  tags: string,
  accessoryOverlays: string,
  backgroundIndex: number, 
  modelIndex: number,
  url?: string): Promise<OutfitI | null> {



  const clothingItems = await ClothingItem.find({ _id: { $in: clothingItemIds } });
  const _url = url ? url : await ReveryService.generateOutfitImage(
    clothingItems.filter((clothingItem: ClothingItemI) => (clothingItem.clothingType != "Necklaces" && clothingItem.clothingType != "Socks" && clothingItem.clothingType != "Croptops"  && clothingItem.clothingType != "Crop Tops")),
    modelId, tuckIn);

  let clothingItemIdsNew = clothingItemIds;
  if (clothingItems.filter((clothingItem: ClothingItemI) => (clothingItem.clothingType === "Croptops" || clothingItem.clothingType === "Crop Tops")).length > 0)
  {
    clothingItemIdsNew = clothingItemIds.filter(e => e !== '6216b6dce95d09e1d16bb730');
    console.log(clothingItemIdsNew);
  }

  const clothingItemsNew = await ClothingItem.find({ _id: { $in: clothingItemIdsNew } });

  const outfit = await Outfit.create({ stylist, clothingItems: clothingItemsNew, modelPhoto: _url, gender, tags, accessoryOverlays, backgroundIndex, modelIndex });
  return await Outfit.findById(outfit).populate(POPULATE).exec();
  // TODO generate outfit image with API.
}

// Delete a outfit.
export async function deleteOutfit(outfit: OutfitOrId): Promise<OutfitI | null> {
  // await Like.deleteMany({outfit});
  return await Outfit.findByIdAndDelete(outfit).populate(POPULATE).exec();
}

// function delete
//TODO upload photos to outfit.
