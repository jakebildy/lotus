import express from "express";
import { UserAuthRouter } from "./auth.route";
import { router as testRouter } from "./test.route";
import { UserRouter } from "./user.route";
import { router as followRouter } from "./follow.route";
import { router as stats } from "./stats.route";
import { router as reminder } from "./reminders.route";
import { router as resetpassword } from "./resetpassword.route";

export const Api = express.Router();

Api.use("/test", testRouter);
Api.use(UserRouter);
Api.use(UserAuthRouter);
Api.use(followRouter);
Api.use(stats);
Api.use(reminder);
Api.use(resetpassword);
