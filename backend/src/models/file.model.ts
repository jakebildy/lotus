import mongoose, { ObjectId } from "mongoose";
import { UserI } from "./user.model";

export interface FileI {
  _id?: string | ObjectId;
  user?: string | ObjectId | UserI;

  url: string;
  name: string;
  extension: string;
  data?: string;
}

const FileSchema = new mongoose.Schema<FileI>(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
    url: { type: String },
    name: { type: String },
    extension: { type: String },
  },
  {
    versionKey: false,
    timestamps: true,
  },
);

export type FileId = string | ObjectId | FileI;
export const File = mongoose.model("File", FileSchema);
