import mongoose from 'mongoose';
import { ObjectId, Schema } from 'mongoose';
import { SellerI } from './seller.model';
import { UserI } from './user.model';


export enum FollowType {
  Seller = 'Seller',
  Stylist = 'Stylist'
}

export interface FollowI {
  _id?: string;
  type: FollowType;
  seller: string | ObjectId | SellerI;
  stylist: string | ObjectId | UserI;
  user: string | ObjectId | UserI;
}

const FollowSchema = new mongoose.Schema<FollowI>(
  {
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    type: {type: String, required: true, enum: Object.values(FollowType)},
    seller: { type: Schema.Types.ObjectId, ref: 'Seller', required: false  },
    stylist: { type: Schema.Types.ObjectId, ref: 'User', required: false },
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

export const Follow = mongoose.model('Follow', FollowSchema);
