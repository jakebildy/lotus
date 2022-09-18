import mongoose from 'mongoose';
import { ClothingItemI } from './clothingItem.model';
import { UserI } from './user.model';
import { ObjectId, Schema } from 'mongoose';
import { PurchaseI } from './purchase.model';

// string | ObjectID | ICat
export interface OrderI {
  _id?: string;
  user: UserI | string | ObjectId;
  purchases: PurchaseI[] | string[] | ObjectId[];
  stripeSessionId: string;
  completed: boolean;

  purchaseUrl?: string;
  stripeCheckoutSession?: string;

  testing?: boolean;
  createdAt: Date;
}

const OrderSchema = new mongoose.Schema<OrderI>(
  {
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    // purchases: [{type: Schema.Types.ObjectId, ref: 'Purchase'}],
    completed: { type: Boolean, required: true, default: false },
    
    purchaseUrl: { type: String, required: false},
    stripeCheckoutSession: { type: String, required: false},

    testing: { type: Boolean, required: true, default: false },
  },
  {
    versionKey: false,
    timestamps: true,
    toJSON: { virtuals: true }, // So `res.json()` and other `JSON.stringify()` functions include virtuals
    toObject: { virtuals: true }
  }
);

OrderSchema.virtual('purchases', {
  ref: 'Purchase', // The model to use
  localField: '_id', // Find people where `localField`
  foreignField: 'order', // is equal to `foreignField`
  // count: true // And only get the number of docs
});

// Searchable text
// OutfitSchema.index({"clothingItems.name": 'text', "clothingItems.clothingType": "text", tags: "text"});

export const Order = mongoose.model('Order', OrderSchema);

// DART CLASS

// final String? id;
// final String createdById;
// final List<ClothingItem> clothingItems;
// final String modelPhoto;