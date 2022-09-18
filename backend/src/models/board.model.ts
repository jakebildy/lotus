import mongoose from 'mongoose';
import { ObjectId, Schema } from 'mongoose';
import { ClothingItemI } from './clothingItem.model';
import { OutfitI } from './outfit.model';
import { UserI } from './user.model';


export interface BoardI {
  _id?: string;
  name: string;
  outfits: string[] | ObjectId[] | OutfitI[];
  user: string | ObjectId | UserI;
}

const BoardSchema = new mongoose.Schema<BoardI>(
  {
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    name: {type: String, required: true},
    outfits: [{ type: Schema.Types.ObjectId, ref: 'Outfit', required: true }],
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

export const Board = mongoose.model('Board', BoardSchema);