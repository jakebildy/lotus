import { Request } from "express";
import { UserI } from "../models/user.model";

export interface RequestI extends Request {
  rawBody?: string;
  user?: UserI;
}
