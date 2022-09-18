
import express, { Response } from "express";
import * as FollowService from "../services/follow.service";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";

export const router = express.Router();

async function getFollowing(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const follows = await FollowService.getFollowing(req.user);
    return res.json(follows);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getFollowers(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const follows = await FollowService.getFollowers(req.user);
    return res.json(follows);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getStylistFollowing(req: RequestI, res: Response) {
  try {
    // if (!req.user) throw "Not logged in - unauthorized";
    const follows = await FollowService.getFollowing(req.params.id);
    return res.json(follows);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getStylistFollowers(req: RequestI, res: Response) {
  try {
    //  if (!req.user) throw "Not logged in - unauthorized";
    const follows = await FollowService.getFollowers(req.params.id);
    return res.json(follows);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function followStylist(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthorized";
    const follow = await FollowService.followStylist(req.user, req.params.id);
    return res.json(follow);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function followSeller(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthorized";
    const follow = await FollowService.followSeller(req.user, req.params.id);
    return res.json(follow);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function unfollowStylist(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const follow = await FollowService.unfollowStylist(req.user, req.params.id);
    return res.json(follow);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function unfollowSeller(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthurized";
    const follow = await FollowService.unfollowSeller(req.user, req.params.id);
    return res.json(follow);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

router.get("/follow/following", userAuth, getFollowing);
router.get("/follow/followers/", userAuth, getFollowers);

router.get("/follow/stylist/following/:id", getStylistFollowing);
router.get("/follow/stylist/followers/:id", getStylistFollowers);

router.post("/follow/stylist/:id", userAuth, followStylist);
router.post("/follow/seller/:id", userAuth, followSeller);

router.delete("/unfollow/user/:id", userAuth, unfollowStylist);
router.delete("/unfollow/seller/:id", userAuth, unfollowSeller);