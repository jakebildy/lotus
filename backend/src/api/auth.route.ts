
import express, { Request, Response } from "express";
import * as AuthService from "../services/user.service"
import { UserI } from "../models/user.model";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";
import { logUserEvent, UserEvents } from "../services/analytics.service";
export const UserAuthRouter = express.Router();

async function login(req: Request, res: Response) {
  try {
    const user = await AuthService.login(req.body.email, req.body.password);

    // set user jwt cookie.
    const jwt = await AuthService.getJwtFromUser(user);
    res.cookie('user', jwt);
    logUserEvent(UserEvents.login, user as UserI);

    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function signup(req: Request, res: Response) {
  try {
    console.log({ fullName: req.body.fullName, username: req.body.username, email: req.body.email });
    var validRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;

    if (!req.body.email.match(validRegex)) throw "Not a valid email";

    await AuthService.createUser(req.body as UserI, req.body.password);
    const user = await AuthService.login(req.body.email, req.body.password);
    // set user jwt cookie.
    const jwt = await AuthService.getJwtFromUser(user);
    res.cookie('user', jwt);

    logUserEvent(UserEvents.login, user as UserI);
    logUserEvent(UserEvents.signup, user as UserI);

    return res.json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

// Login or signup with google, If account does not exist create one. Set user jwt to sign user in.
async function google_login(req: Request, res: Response) {
  try {
    const accessToken = req.body.accessToken;
    const idToken = req.body.idToken;
    const googleUser = await AuthService.getGoogleUser(accessToken, idToken);
    console.log(googleUser.email);
    const _user: UserI | null = await AuthService.findUserByEmail(googleUser.email);
    let user: UserI;

    // User does not exist, signup with google details.
    if (!_user) {
      user = await AuthService.createUserFromGoogleUser(googleUser);
    }
    // User already exists, login this user.
    else {
      user = _user;
    }

    // set user jwt cookie.
    const jwt = await AuthService.getJwtFromUser(user);
    res.cookie('user', jwt);
    return res.json(user);
  }
  catch (error) {
    console.log(error);
    res.status(500).send(error);
  }
}

async function me(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in";
    const user: UserI = req.user;
    logUserEvent(UserEvents.login, user as UserI);

    return res.status(200).json(user);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

UserAuthRouter.post("/auth/login", login);
UserAuthRouter.post("/auth/signup", signup);
UserAuthRouter.post("/auth/google", google_login);

UserAuthRouter.get("/user/me", userAuth, me);
