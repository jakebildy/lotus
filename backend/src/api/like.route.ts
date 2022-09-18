
import express, { Response } from "express";
import * as LikeService from "../services/like.service";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";

export const router = express.Router();

async function getLikes(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const likes = await LikeService.getLikes(req.user);
    return res.json(likes);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getStylistsLikes(req: RequestI, res: Response) {
  try {
    const likes = await LikeService.getStylistsLikes(req.params.id);
    return res.json(likes);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getUsersLikes(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const likes = await LikeService.getLikes(req.params.id);
    return res.json(likes);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function likeClothingItem(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const like = await LikeService.likeClothingItem(req.user, req.params.id);
    return res.json(like);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function likeOutfit(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const like = await LikeService.likeOutfit(req.user, req.params.id);
    return res.json(like);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function unlikeClothingItem(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const like = await LikeService.unlikeClothingItem(req.user, req.params.id);
    return res.json(like);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function unlikeOutfit(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const like = await LikeService.unlikeOutfit(req.user, req.params.id);
    return res.json(like);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

// /likes/my-likes/
// /likes/user/:id

// /likes/like/outfit/:id
// /likes/unlike/outfit/:id

// /likes/like/clothing-item/:id
// /likes/unlike/clothing-item/:id

router.get("/likes/my-likes", userAuth, getLikes);
router.get("/likes/user/:id", userAuth, getUsersLikes);

router.get("/likes/stylist/:id", getStylistsLikes);

router.post("/likes/like/outfit/:id", userAuth, likeOutfit);
router.post("/likes/like/clothing-item/:id", userAuth, likeClothingItem);

router.delete("/likes/unlike/outfit/:id", userAuth, unlikeOutfit);
router.delete("/likes/unlike/clothing-item/:id", userAuth, unlikeClothingItem);