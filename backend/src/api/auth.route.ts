import express, { Request, Response } from "express";
import * as AuthService from "../services/user.service";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";
import { logUserEvent, UserEvents } from "../services/analytics.service";
import { trackSignup } from "../conversion_api";

export const UserAuthRouter = express.Router();

const EMAIL_REGEX =
  /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

async function login(req: Request, res: Response) {
  try {
    const user = await AuthService.login(req.body.email, req.body.password);

    if (!user) throw "Invalid email or password";

    // set user jwt cookie.
    const jwt = await AuthService.getJwtFromUser(user);
    res.cookie("user", jwt);
    logUserEvent(UserEvents.login, user);

    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function signup(req: Request, res: Response) {
  try {
    console.log({
      fullName: req.body.fullName,
      username: req.body.username,
      email: req.body.email,
    });

    if (!req.body.email.match(EMAIL_REGEX)) throw "Not a valid email";

    await AuthService.createUser(req.body, req.body.password);
    const user = await AuthService.login(req.body.email, req.body.password);
    // set user jwt cookie.
    const jwt = await AuthService.getJwtFromUser(user);
    res.cookie("user", jwt);

    logUserEvent(UserEvents.login, user);
    logUserEvent(UserEvents.signup, user);
    trackSignup(req.body.email);

    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

// Login or signup with google, If account does not exist create one. Set user jwt to sign user in.
async function googleLogin(req: Request, res: Response) {
  try {
    const accessToken = req.body.accessToken;
    const idToken = req.body.idToken;
    const googleUser = await AuthService.getGoogleUser(accessToken, idToken);
    console.log(googleUser.email);
    const existingUser = await AuthService.findUserByEmail(googleUser.email);

    // If the user does not exist yet, sign up with google details. Otherwise log this user in.
    const user =
      existingUser ?? (await AuthService.createUserFromGoogleUser(googleUser));

    // set user jwt cookie.
    const jwt = await AuthService.getJwtFromUser(user);
    res.cookie("user", jwt);
    return res.json(user);
  } catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
}

async function me(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";
    const user = req.user;
    logUserEvent(UserEvents.login, user);

    return res.status(200).json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

UserAuthRouter.post("/auth/login", login);
UserAuthRouter.post("/auth/signup", signup);
UserAuthRouter.post("/auth/google", googleLogin);

UserAuthRouter.get("/user/me", userAuth, me);
