import express, { Response } from "express";
import { RequestI } from "../types/request";
import {
  checkResetCodeAndResetPassword,
  resetPasswordEmail,
} from "../services/resetpassword.service";
export const router = express.Router();

async function resetPassword(req: RequestI, res: Response) {
  try {
    resetPasswordEmail(req.body.email);
    res.status(200).json({ message: "Password reset email sent" });
  } catch (e) {
    res.status(500).send(e);
  }
}

async function resetPasswordComplete(req: RequestI, res: Response) {
  try {
    const response = await checkResetCodeAndResetPassword(
      req.body.email,
      req.body.code,
      req.body.newPassword,
    );

    if (response === "Success") {
      res.status(200).json({ message: "Password reset email sent" });
    } else {
      res.status(500).json({ message: response });
    }
  } catch (e) {
    res.status(500).send(e);
  }
}

router.post("/reset-password", resetPassword);
router.post("/reset-password-complete", resetPasswordComplete);
