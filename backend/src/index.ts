/**
 * Required External Modules
 */

import dotenv from "dotenv";
import express, { Request, Response } from "express";
import cors from "cors";
import helmet from "helmet";
import { Api } from "./api";
import cookieParser from "cookie-parser";
import * as mongoConnection from "./connections/mongo.connection";
import path from 'path';
import { RequestI } from "./types/request";
import { sendStreakReminder } from "./services/streakreminder.service";


const BUILD_DIRECTORY = "../build/";

dotenv.config();
mongoConnection.init();

if (!process.env.PORT) { process.exit(1); }
const PORT: number = parseInt(process.env.PORT as string, 10)

/**
 *  App Configuration
 */
const app = express();
app.use(helmet({
  contentSecurityPolicy: false,
}));
app.use(cors({ credentials: true, origin: ['*', 'http://localhost:3000', 'http://localhost:3000', 'http://localhost:53523', 'http://localhost:7007', "http://thefits.app", "http://www.thefits.app", "https://www.thefits.app", "https://www.thefits.app", "https://shopfits.me", "http://localhost:63373"] }));

function verify(req: RequestI, res: Response, buf: Buffer) {
  const url = req.originalUrl;
  if (url.startsWith('/api/stripe/webhook')) {
    req.rawBody = buf.toString()
  }
}

app.use(express.json({ limit: '50mb', verify }));
app.use(express.urlencoded({ limit: '50mb', extended: true, verify }));
app.use(cookieParser());


app.use("/api", Api);
app.get('/joe-mama', (_, res) => res.send('Fits'));

function redirect(req: Request, res: Response) {
  res.setHeader('Cache-Control', 'no-cache');
  return res.redirect("/landing-page");
}

app.get("/", redirect);
app.use(express.static(path.resolve(__dirname, BUILD_DIRECTORY)));

app.get('*', function (req, res) {
  res.setHeader('Cache-Control', 'no-cache');
  const filePath = path.resolve(__dirname, BUILD_DIRECTORY, 'index.html');
  res.sendFile(filePath);
});

app.listen(PORT, () => {
  console.log(`server is listening on ${PORT}`);
  console.log(`http://localhost:${PORT}`);
  return;
});

// CourierService.sendTestEmail();

// ReveryService.uploadEntireCatalog();

// StripeService.run();

//WARNING: DO NOT LEAVE THIS ENABLED 
// sendStreakReminder();
console.log("HELLOOOO") 
