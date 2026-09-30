import { NextFunction, Response } from "express";
import * as UserService from "../services/user.service";
import { RequestI } from "../types/request";

// Reads the auth jwt from cookies and loads the user object into req.
export async function userAuth(
  req: RequestI,
  res: Response,
  next: NextFunction,
): Promise<void | Response> {
  try {
    const userJwt = req.cookies["user"];
    const user = await UserService.getUserFromJwt(userJwt);
    if (!user) throw "Unauthorized";
    req.user = user;
    return next();
  } catch (e) {
    return res
      .status(401)
      .send(e + ", " + req.url)
      .end();
  }
}
