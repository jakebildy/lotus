
import express, { Request, Response } from "express";
import * as UserService from "../services/user.service"
import { RequestI } from "../types/request";
import * as AnalyticsService from "../services/analytics.service";
import { userAuth } from "../middleware/auth.middleware";
import { assert } from "console";


export const router = express.Router();

async function getUsers(req: RequestI, res: Response) {
  try {
    const users = await UserService.getUsers();
    return res.json(users);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function logUserEvent(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "user not authenticated. weird";

    const userEvent = await AnalyticsService.logUserEvent(req.params.name, req.user);
    return res.json(userEvent);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function dau(req: RequestI, res: Response) {
  try {

    const list = await AnalyticsService.getDailyActive(req.params.name);
    return res.json(list);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function freq(req: RequestI, res: Response) {
  try {

    const list = await AnalyticsService.getUserFrequency(req.params.name);
    return res.json(list);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function wau(req: RequestI, res: Response) {
  try {

    const list = await AnalyticsService.getWeeklyActive(req.params.name);
    return res.json(list);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function mau(req: RequestI, res: Response) {
  try {

    const list = await AnalyticsService.getMonthlyActive(req.params.name);
    return res.json(list);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function all(req: RequestI, res: Response) {
  try {

    const list = await AnalyticsService.getAllUserEvents(req.params.name);
    return res.json(list);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

router.get("/stats/users/", getUsers);
router.post("/stats/log/:name", userAuth, logUserEvent);

router.get("/stats/all/:name", all);
router.get("/stats/dau/:name", dau);
router.get("/stats/wau/:name", wau);
router.get("/stats/mau/:name", mau);
router.get("/stats/freq/:name", freq);