
import express, { Request, Response } from "express";
import { RequestI } from "../types/request";
import { adminAuth, userAuth } from "../middleware/auth.middleware";
import * as ClothingItemService from "../services/clothingItem.service";

export const ClothingItemRouter = express.Router();

async function getItemById(req: Request, res: Response) {
  try {
    const item = await ClothingItemService.getById(req.params.id);
    return res.json(item);
  } catch (e) {
    //console.log(e);
    res.status(500).send(e);
  }
}

async function editItem(req: Request, res: Response) {
  try {
    const item = await ClothingItemService.editItem(req.params.id, req.body);
    return res.json(item);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function deleteImage(req: Request, res: Response) {
  try {
    const item = await ClothingItemService.deleteImage(req.params.id, req.params.imageId);
    return res.json(item);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getBrandsItems(req: Request, res: Response) {
  try {
    const items = await ClothingItemService.getBrandsClothingItems(req.params.id);
    return res.json(items);
  } catch (e) {
    // console.log(e);
    res.status(500).send(e);
  }
}

async function getItems(req: Request, res: Response) {
  try {
    const items = await ClothingItemService.getClothingItems();
    return res.json(items);
  } catch (e) {
    //console.log(e);
    res.status(500).send(e);
  }
}

async function searchByText(req: Request, res: Response) {
  try {
    const items = await ClothingItemService.searchClothingItems(req.params.text);
    return res.json(items);
  } catch (e) {
    //console.log(e);
    res.status(500).send(e);
  }
}

async function searchByTextAndType(req: Request, res: Response) {
  try {
    const items = await ClothingItemService.searchClothingItemsByTextAndType(req.params.text, req.params.type);
    return res.json(items);
  } catch (e) {
    //console.log(e);
    res.status(500).send(e);
  }
}

// async function getByType(req: Request, res: Response) {
//   try {
//     const items = await ClothingItemService.getClothingItemsByTypeAndGender(req.params.type);
//     return res.json(items);
//   } catch (e) {
//     console.log(e);
//     res.status(500).send(e);
//   }
// }

async function getTypeMap(req: Request, res: Response) {
  try {
    const items = await ClothingItemService.getClothingItemsTypeMap();
    return res.json(items);
  } catch (e) {
    // console.log(e);
    res.status(500).send(e);
  }
}

async function deleteItem(req: Request, res: Response) {
  try {
    const items = await ClothingItemService.deleteClothingItem(req.params.id);
    return res.json(items);
  } catch (e) {
    //console.log(e);
    res.status(500).send(e);
  }
}

async function createItem(req: Request, res: Response) {
  try {
    const item = await ClothingItemService.createClothingItemFromBody(req.body);
    return res.json(item);
  } catch (e) {
    //console.log(e);
    res.status(500).send(e);
  }
}

async function addImage(req: RequestI, res: Response) {
  try {
    const fileName: string = req.body.fileName;
    const base64: string = req.body.base64;
    const user = await ClothingItemService.addImage(req.params.id, fileName, base64);

    return res.json(user);
  } catch (e) {
    //console.log(e);
    res.status(500).send(e);
  }
};

ClothingItemRouter.get("/clothing-items/item/:id", getItemById);
ClothingItemRouter.post("/clothing-items/edit/:id", editItem);
ClothingItemRouter.post("/clothing-items/remove-image/:id/:imageId", deleteImage);

ClothingItemRouter.get("/clothing-items/all", getItems);
ClothingItemRouter.get("/clothing-items/brand/:id", getBrandsItems);


ClothingItemRouter.get("/clothing-items/search/:text", searchByText);
ClothingItemRouter.get("/clothing-items/search/:text/:type", searchByTextAndType);
ClothingItemRouter.get("/clothing-items/type-map/", getTypeMap);

ClothingItemRouter.post("/clothing-items/create", adminAuth, createItem);
ClothingItemRouter.post("/clothing-items/add-photo/:id", adminAuth, addImage);
ClothingItemRouter.delete("/clothing-items/delete/:id", adminAuth, deleteItem);