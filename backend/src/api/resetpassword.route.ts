import express, {Response } from "express";
import { RequestI } from "../types/request";
import { sendStreakReminder } from "../services/streakreminder.service";
import {checkResetCodeAndResetPassword, resetPasswordEmail} from "../services/resetpassword.service";
export const router = express.Router();

async function resetPassword(req: RequestI, res: Response) {
  try {
    // check if the request has a query parameter called "password". This is not at all secure, but it should work for now
    // if (req.query.password !== "joemama") {
    //   res.status(401).json({message: "Unauthorized"});
    //   return;
    // }
    resetPasswordEmail(req.body.email);
    res.status(200).json({message: "Password reset email sent"});
  } catch (e) {
    res.status(500).send(e);
  }
}


async function resetPasswordComplete(req: RequestI, res: Response) {
  try {
    // check if the request has a query parameter called "password". This is not at all secure, but it should work for now
    // if (req.query.password !== "joemama") {
    //   res.status(401).json({message: "Unauthorized"});
    //   return;
    // }
    let response = await checkResetCodeAndResetPassword(req.body.email, req.body.code, req.body.newPassword);

    if (response === true) {
    res.status(200).json({message: "Password reset email sent"});
    } else {
      res.status(
        500
      ).json({message: "Failed to reset password"});
    }
  } catch (e) {
    res.status(500).send(e);
  }
}

router.post("/reset-password", resetPassword);
router.post("/reset-password-complete", resetPasswordComplete);
