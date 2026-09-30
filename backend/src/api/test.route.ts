import express, { Response } from "express";
import { RequestI } from "../types/request";
export const router = express.Router();

async function test(_req: RequestI, res: Response) {
  try {
    res.status(200).json({ message: "hello world" });
  } catch (e) {
    res.status(500).send(e);
  }
}

async function health(_req: RequestI, res: Response) {
  try {
    res.status(200).json({ status: "ok" });
  } catch (e) {
    res.status(500).send(e);
  }
}

router.get("/health", health);
router.get("/test", test);
