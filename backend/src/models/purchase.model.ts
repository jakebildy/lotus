import mongoose from 'mongoose';
import { ClothingItemI } from './clothingItem.model';
import { UserI } from './user.model';
import { ObjectId, Schema } from 'mongoose';
import { OutfitI } from './outfit.model';
import { OrderI } from './order.model';

export interface PurchaseI {
  _id?: string;
  order: OrderI | string | ObjectId;
  user: UserI | string | ObjectId;
  clothingItem: ClothingItemI | string | ObjectId;
  size: string;
  
  stylist?: UserI | string | ObjectId;
  outfit?: OutfitI | string | ObjectId;
  
  stylistPaid?: boolean;
  completed: boolean;

  testing?: boolean;
}

const PurchaseSchema = new mongoose.Schema<PurchaseI>(
  {
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    order: { type: Schema.Types.ObjectId, ref: 'Order', required: true },

    clothingItem: {type: Schema.Types.ObjectId, ref: 'ClothingItem'},
    size: { type: String, required: false, default: "" },
    
    stylist: { type: Schema.Types.ObjectId, ref: 'User', required: false },
    outfit: { type: Schema.Types.ObjectId, ref: 'Outfit', required: false },
    
    stylistPaid: { type: Boolean, required: true, default: false },
    completed: { type: Boolean, required: true, default: false },

    testing: { type: Boolean, required: true, default: false },
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

export const Purchase = mongoose.model('Purchase', PurchaseSchema);