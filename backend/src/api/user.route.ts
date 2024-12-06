
import express, { Request, Response } from "express";
import * as UserService from "../services/user.service"
import { UserI } from "../models/user.model";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";
import { UserUpdate } from "../services/user.service";
export const UserRouter = express.Router();

async function updateUser(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "no user sheeeeeeeeesh";
    const user = await UserService.updateUser(req.user, req.body as UserUpdate);

    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function updateDeviceToken(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "no user sheeeeeeeeesh";
    const user = await UserService.updateUser(req.user, { deviceToken: req.params.token } as UserUpdate);
    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function searchByText(req: Request, res: Response) {
  try {
    const items = await UserService.searchUsers(req.params.text);
    return res.json(items);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function uploadAvatar(req: RequestI, res: Response) {
  console.log("upload avatar");
  try {
    if (!req.user) throw "no user sheeeeeeeeesh";
    const fileName: string = req.body.fileName;
    const base64: string = req.body.base64;

    const user = await UserService.uploadAvatar(req.user, fileName, base64);

    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
};

async function findUserByUsername(req: Request, res: Response) {
  try {
    const user = await UserService.findUserByUsername(req.params.username);
    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

UserRouter.get("/user/username/:username", findUserByUsername);

UserRouter.get("/user/search/:text", searchByText);
UserRouter.post("/user/update", userAuth, updateUser);
UserRouter.post("/user/upload-avatar", userAuth, uploadAvatar);
UserRouter.post("/user/update-device-token/:token", userAuth, updateDeviceToken);
// UserRouter.post("/user/subscribed/", userAuth, markSubscribed);