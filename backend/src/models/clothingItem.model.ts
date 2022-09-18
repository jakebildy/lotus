import mongoose from "mongoose";
import { ObjectId, Schema } from "mongoose";
import { FileId } from "./file.model";
import { SellerI } from "./seller.model";

export const clothingTypes = [
  "Tops",
  "Hoodies",
  "Sweatshirts",
  "Long-Sleeves",
  "Pants",
  "Jeans",
  "Sweatpants",
  "Shorts",
  "Skirts",
  "Jackets",
  "Dresses",
  "Necklaces",
  "Socks",
  "Croptops",
  "Hats",
];

export interface ClothingItemI {
  _id?: string;
  name: string;
  seller: string | ObjectId | SellerI;
  // sellerName: string;
  // photos?: string[];
  files?: FileId[];
  description?: string;
  sizesInStock: string;
  sizes?: string;
  price: number;

  gender: string;
  clothingType: string;
  purchaseUrl: string;

  tags: string;
  promoCode: string;
  saleIsFinal: boolean;

  overlayURLs?: string;
  torsoOverlayURLs?: string;
  saleAmount?: number;
  dontGoToRevery?: string;
  itemsPageIndex?: number;
  reviews?: string;

  shippingCost?: number;
  videoURL?: string;

  reveryUploaded: boolean;
  reveryId: string;
}

const ClothingItemSchema = new mongoose.Schema<ClothingItemI>(
  {
    name: { type: String, required: true },
    seller: { type: Schema.Types.ObjectId, ref: "Seller", required: true },
    // sellerName: {type: String, required: true},
    // photos: {type: [String], required: true, default: []},
    files: {
      type: [Schema.Types.ObjectId],
      ref: "File",
      required: true,
      default: [],
    },
    description: { type: String, required: false, default: "" },
    sizesInStock: { type: String, required: true, default: "default" },
    sizes: { type: String, required: true, default: "default" },
    price: { type: Number, required: true },

    overlayURLs: { type: String, required: false, default: "" },
    torsoOverlayURLs: { type: String, required: false, default: "" },
    saleAmount: { type: Number, required: false, default: "" },
    dontGoToRevery: { type: String, required: false, default: "" },
    itemsPageIndex: { type: Number, required: false },
    reviews: { type: String, required: false, default: "" },

    shippingCost: { type: Number, required: false },
    videoURL: { type: String, required: false },
  
    gender: {
      type: String,
      required: true,
      enum: ["Men", "Women", "Unisex"],
      default: "Unisex",
    },
    clothingType: {
      type: String,
      required: true,
      enum: clothingTypes,
      default: "t-shirts",
    },
    purchaseUrl: { type: String, required: true, default: "n/a" },
    tags: { type: String, required: false, default: "" },
    saleIsFinal: { type: Boolean, default: true },
    promoCode: { type: String, default: "" },

    reveryUploaded: { type: Boolean, default: false },
    reveryId: { type: String },
  },

  {
    versionKey: false,
    timestamps: true,
    toJSON: { virtuals: true }, // So `res.json()` and other `JSON.stringify()` functions include virtuals
    toObject: { virtuals: true }
  },
);

ClothingItemSchema.virtual('numLikes', {
  ref: 'Like', // The model to use
  localField: '_id', // Find people where `localField`
  foreignField: 'clothingItem', // is equal to `foreignField`
  count: true // And only get the number of docs
});

// Searchable text
ClothingItemSchema.index({ name: 'text', description: 'text', clothingType: "text", tags: "text" });

export type ClothingItemId = string | ObjectId | ClothingItemI;

export const ClothingItem = mongoose.model("ClothingItem", ClothingItemSchema);

// DART CLASS

// final String name;
// final String sellerId;
// final String sellerName;
// final List<String> photos;
// final String description;
// final List<String> sizesInStock;
// final double price;
