
import express, { Request, Response } from "express";
import * as UserService from "../services/user.service"
import { UserI } from "../models/user.model";
import { RequestI } from "../types/request";
import { adminAuth, userAuth } from "../middleware/auth.middleware";
import * as SellerService from "../services/seller.service";
import { SellerI } from "../models/seller.model";

export const SellerRouter = express.Router();

async function getById(req: Request, res: Response) {
  try {
    console.log(req.body);
    const seller = await SellerService.getById(req.params.id);
    return res.json(seller);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getSellers(req: Request, res: Response) {
  try {
    console.log(req.body);
    const sellers = await SellerService.getSellers();
    return res.json(sellers);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function searchByText(req: Request, res: Response) {
  try {
    const items = await SellerService.searchSellers(req.params.text);
    return res.json(items);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function createSeller(req: Request, res: Response) {
  try {
    console.log(req.body);
    console.log("creating seller");
    const seller = await SellerService.createSeller(req.body as SellerI);

    return res.json(seller);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function deleteSeller(req: Request, res: Response) {
  try {
    const seller = await SellerService.deleteSeller(req.params.id);
    return res.json(seller);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

// async function uploadLogo(req: RequestI, res: Response) {
//   console.log("upload avatar");
//   try {
//     if (!req.user) throw "no user sheeeeeeeeesh";
//     const fileName: string = req.body.fileName;
//     const base64: string = req.body.base64;

//     const user = await SellerService.uploadLogo(req.params.id, fileName, base64);

//     return res.json(user);
//   } catch (e) {
//     console.log(e);
//     res.status(500).send(e);
//   }
// };

async function addImage(req: RequestI, res: Response) {
  try {
    const fileName: string = req.body.fileName;
    const base64: string = req.body.base64;
    const user = await SellerService.setAvatar(req.params.id, fileName, base64);

    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
};



SellerRouter.get("/seller/search/:text", searchByText);
SellerRouter.get("/seller/sellers", adminAuth, getSellers);
SellerRouter.get("/seller/sellers/:id", adminAuth, getById);
SellerRouter.post("/seller/create", adminAuth, createSeller);
SellerRouter.delete("/seller/delete/:id", adminAuth, deleteSeller);
SellerRouter.post("/seller/:id/set-avatar", adminAuth, addImage);

