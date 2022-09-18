
import express, { Request, Response } from "express";
import * as ReveryService from "../services/revery.service"
import { RequestI } from "../types/request";
import { adminAuth } from "../middleware/auth.middleware";
export const router = express.Router();

async function upload(req: RequestI, res: Response) {
  try {
    await ReveryService.uploadEntireCatalog();
    return res.json({});
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

router.post("/revery/upload", adminAuth, upload);
