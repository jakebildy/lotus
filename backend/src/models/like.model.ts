import mongoose from 'mongoose';
import { ObjectId, Schema } from 'mongoose';
import { ClothingItemI } from './clothingItem.model';
import { OutfitI } from './outfit.model';
import { UserI } from './user.model';


export enum LikeType {
  ClothingItem = 'ClothingItem',
  Outfit = 'Outfit'
}

export interface LikeI {
  _id?: string;
  type: LikeType;
  clothingItem: string | ObjectId | ClothingItemI;
  outfit: string | ObjectId | OutfitI;
  user: string | ObjectId | UserI;
}

const LikeSchema = new mongoose.Schema<LikeI>(
  {
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    type: {type: String, required: true, enum: Object.values(LikeType)},
    clothingItem: { type: Schema.Types.ObjectId, ref: 'ClothingItem', required: false  },
    outfit: { type: Schema.Types.ObjectId, ref: 'Outfit', required: false },
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

export const Like = mongoose.model('Like', LikeSchema);