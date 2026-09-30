// Must stay the first import: loads .env before any other module reads process.env.
import "dotenv/config";
import express, { Request, Response } from "express";
import cors from "cors";
import helmet from "helmet";
import { Api } from "./api";
import cookieParser from "cookie-parser";
import * as mongoConnection from "./connections/mongo.connection";
import path from "path";
import { RequestI } from "./types/request";

const BUILD_DIRECTORY = "../build/";

const ALLOWED_ORIGINS = [
  "*",
  "http://localhost:3000",
  "http://localhost:53523",
  "http://localhost:7007",
  "http://localhost:63373",
];

mongoConnection.init();

if (!process.env.PORT) {
  process.exit(1);
}
const PORT = parseInt(process.env.PORT, 10);

/**
 *  App Configuration
 */
const app = express();
app.use(
  helmet({
    contentSecurityPolicy: false,
  }),
);
app.use(cors({ credentials: true, origin: ALLOWED_ORIGINS }));

// Keeps the raw request body around for Stripe webhook signature checks.
function verify(req: RequestI, _res: Response, buf: Buffer) {
  const url = req.originalUrl;
  if (url.startsWith("/api/stripe/webhook")) {
    req.rawBody = buf.toString();
  }
}

app.use(express.json({ limit: "50mb", verify }));
app.use(express.urlencoded({ limit: "50mb", extended: true, verify }));
app.use(cookieParser());

app.use("/api", Api);
app.get("/joe-mama", (_, res) => res.send("Fits"));

function redirect(_req: Request, res: Response) {
  res.setHeader("Cache-Control", "no-cache");
  return res.redirect("/landing-page");
}

app.get("/", redirect);
app.use(express.static(path.resolve(__dirname, BUILD_DIRECTORY)));

app.get("*", function (_req, res) {
  res.setHeader("Cache-Control", "no-cache");
  const filePath = path.resolve(__dirname, BUILD_DIRECTORY, "index.html");
  res.sendFile(filePath);
});

app.listen(PORT, () => {
  console.log(`server is listening on ${PORT}`);
  console.log(`http://localhost:${PORT}`);
});
