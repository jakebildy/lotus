import mongoose, { ObjectId } from "mongoose";

export interface ResetCodeI {
  _id?: string | ObjectId;
  email: string;
  code: string;
  createdAt: Date;
}

const ResetCodeSchema = new mongoose.Schema<ResetCodeI>(
  {
    email: { type: String, required: true },
    code: { type: String, required: true },
  },
  {
    versionKey: false,
    timestamps: true,
  },
);

export const ResetCode = mongoose.model("ResetCode", ResetCodeSchema);
