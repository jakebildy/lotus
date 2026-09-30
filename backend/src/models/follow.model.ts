import mongoose, { ObjectId } from "mongoose";
import { UserI } from "./user.model";

export enum FollowType {
  Stylist = "Stylist",
}

export interface FollowI {
  _id?: string;
  type: FollowType;
  stylist: string | ObjectId | UserI;
  user: string | ObjectId | UserI;
}

const FollowSchema = new mongoose.Schema<FollowI>(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    type: { type: String, required: true, enum: Object.values(FollowType) },
    stylist: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: false,
    },
  },
  {
    versionKey: false,
    timestamps: true,
  },
);

export const Follow = mongoose.model("Follow", FollowSchema);
