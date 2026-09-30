import express, { Response } from "express";
import { RequestI } from "../types/request";
import { sendStreakReminder } from "../services/streakreminder.service";
export const router = express.Router();

// NOTE: this endpoint is not authenticated.
async function remind(_req: RequestI, res: Response) {
  try {
    sendStreakReminder();
    res.status(200).json({ message: "Reminded" });
  } catch (e) {
    res.status(500).send(e);
  }
}

router.get("/remind", remind);
