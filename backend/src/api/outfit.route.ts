
import express, { Request, Response } from "express";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";
import * as ReveryService from "../services/revery.service";
import * as OutfitService from "../services/outfit.service";
import * as ClothingItemService from "../services/clothingItem.service";
import { UserI } from "../models/user.model";

export const router = express.Router();

async function getOutfits(req: Request, res: Response) {
  try {
    const items = await OutfitService.getAll();
    return res.json(items);
  } catch (e) {
    //  console.log(e);
    res.status(500).send(e);
  }
}

async function getOutfitsByGender(req: Request, res: Response) {
  try {
    const items = await OutfitService.getByGender(req.params.gender);
    return res.json(items);
  } catch (e) {
    // console.log(e);
    res.status(500).send(e);
  }
}

async function getOutfitsWithItem(req: Request, res: Response) {
  try {
    const items = await OutfitService.getOutfitsWithItem(req.params.id);
    return res.json(items);
  } catch (e) {
    //  console.log(e);
    res.status(500).send(e);
  }
}

async function createOutfit(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Unauthorized!";

    const outfit = await OutfitService.createOutfit(req.user, req.body.clothingItemIds, req.body.modelId, req.body.gender, req.body.tuckIn ?? false, req.body.tags, req.body.accessoryOverlays, req.body.backgroundIndex, req.body.modelIndex);
    return res.json(outfit);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function generateOutfitImage(req: RequestI, res: Response) {
  try {
    const ids = await ClothingItemService.getClothingItemsByIds(req.body.clothingItemIds);
    const outfit = await ReveryService.generateOutfitImage(ids, req.body.modelId, req.body.tuckIn ?? false);
    return res.json(outfit);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getModels(req: RequestI, res: Response) {
  try {

    const models = await ReveryService.getModels();
    return res.json(models);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function deleteOutfit(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not authenticated can't delete";
    const outfit = await OutfitService.getById(req.params.id);
    if (!outfit) throw "Outfit doesn't exist";
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const ownsOutfit = (outfit.stylist as UserI)._id!.toString() == req.user._id!.toString();
    if (!ownsOutfit) throw "User does not own this outfit so can't delete it";
    const deletedOutfit = await OutfitService.deleteOutfit(outfit);
    return res.json(deletedOutfit);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

router.post("/outfits/generate-image", generateOutfitImage);
router.get("/outfits/models", getModels);

router.get("/outfits/all", getOutfits);
router.get("/outfits/all/:gender", getOutfitsByGender);
router.get("/outfits/clothing-item/:id", getOutfitsWithItem);

router.post("/outfits/create", userAuth, createOutfit);
router.delete("/outfits/delete/:id", userAuth, deleteOutfit);
