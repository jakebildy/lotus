import mongoose, { ObjectId } from 'mongoose';
import { FileI } from './file.model';
const DEFAULT_AVATAR = "https://static.vecteezy.com/system/resources/previews/000/566/942/non_2x/blank-tshirt-icon-vector.jpg";
export interface SellerI {
  _id?: string;
  email: string;
  shopName: string;

  avatar?: string;
  file?: FileI;

  firstName?: string;
  lastName?: string;
  password?: string;
}

const SellerSchema = new mongoose.Schema<SellerI>(
  {
    email: { type: String, unique: true, required: true },
    shopName: { type: String, required: true },

    avatar: { type: String, required: true, default: DEFAULT_AVATAR },
    file: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "File",
      required: false,
    },

    firstName: { type: String, required: false },
    lastName: { type: String, required: false },
    password: { type: String, required: false },
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

SellerSchema.index({ shopName: 'text' });

export type SellerId = string | ObjectId | SellerI;
export const Seller = mongoose.model('Seller', SellerSchema);