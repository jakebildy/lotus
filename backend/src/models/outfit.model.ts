import mongoose from 'mongoose';
import { ClothingItemI } from './clothingItem.model';
import { UserI } from './user.model';
import { ObjectId, Schema } from 'mongoose';
import { Like } from './like.model';

// string | ObjectID | ICat
export interface OutfitI {
  _id?: string;
  stylist: UserI | string | ObjectId;
  gender: string;
  clothingItems: ClothingItemI[] | string[] | ObjectId[];
  modelPhoto: string;
  tags: string;
  accessoryOverlays: string;
  backgroundIndex: number;
  modelIndex: number;
}

const OutfitSchema = new mongoose.Schema<OutfitI>(
  {
    stylist: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    gender: {
      type: String,
      required: true,
      enum: ["Men", "Women"],
    },
    clothingItems: [{ type: Schema.Types.ObjectId, ref: 'ClothingItem' }],
    modelPhoto: { type: String, required: true },
    tags: { type: String, required: false, default: "" },
    accessoryOverlays: { type: String, required: false, default: "" },
    backgroundIndex: { type: Number, required: false, default: 0 },
    modelIndex: { type: Number, required: false, default: 0 }
  },
  {
    versionKey: false,
    timestamps: true,
    toJSON: { virtuals: true }, // So `res.json()` and other `JSON.stringify()` functions include virtuals
    toObject: { virtuals: true }
  }
);

OutfitSchema.virtual('numLikes', {
  ref: 'Like', // The model to use
  localField: '_id', // Find people where `localField`
  foreignField: 'outfit', // is equal to `foreignField`
  count: true // And only get the number of docs
});

OutfitSchema.post('remove', async function (outfit) {
  //find all users with referenced tag
  //remove doc._id from array
  await Like.deleteMany({ outfit });
});


// Searchable text
// OutfitSchema.index({"clothingItems.name": 'text', "clothingItems.clothingType": "text", tags: "text"});

export const Outfit = mongoose.model('Outfit', OutfitSchema);

// DART CLASS

// final String? id;
// final String createdById;
// final List<ClothingItem> clothingItems;
// final String modelPhoto;