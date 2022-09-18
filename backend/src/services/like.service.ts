import { ObjectId } from "mongoose";
import { ClothingItem, ClothingItemI } from "../models/clothingItem.model";
import { Like, LikeI, LikeType } from "../models/like.model";
import { Outfit, OutfitI } from "../models/outfit.model";
import { User, UserI } from "../models/user.model";
import { POPULATE as clothing_populate } from "./clothingItem.service";
import { sendPushNotification } from "../services/notifications.service";

// /likes/my-likes/
// /likes/user/:id
// /likes/like/outfit/:id
// /likes/unlike/outfit/:id
// /likes/like/clothing-item/:id
// /likes/unlike/clothing-item/:id

type UserOrId = string | ObjectId | UserI;
type ClothingItemOrId = string | ObjectId | ClothingItemI;
type OutfitOrId = string | ObjectId | OutfitI;

const POPULATE = [
  {
    path: 'outfit',
    populate: [
      "stylist",
      {
        path: 'clothingItems',
        populate: clothing_populate
      }
    ]
  },
  {
    path: 'clothingItem',
    populate: clothing_populate
  },
  'user'
];


// Returns a list of outfits and clothing items that a user liked.
export async function getLikes(user: UserOrId): Promise<LikeI[] | null> {
  const likes = await Like.find({ user }).populate(POPULATE).exec();
  const nonNullLikes = await likes.filter((like: LikeI) => {
    //console.log(like.outfit);
    return like.outfit !== null;
  });
  return nonNullLikes;
  // return likes;
}

// Returns a list of outfits and clothing items that a user liked.
export async function getStylistsLikes(stylist: UserOrId): Promise<LikeI[] | null> {

  const likes = await Like.find({ type: LikeType.Outfit }).populate(POPULATE).exec();
  const nonNullLikes = await likes.filter((like: LikeI) => {
    //console.log(like.outfit);
    return like.outfit !== null;
  });
  const stylistLikes = await nonNullLikes.filter((like: LikeI) => (((like.outfit as OutfitI).stylist as UserI)._id as ObjectId).toString() == stylist.toString());
  return stylistLikes;
}


// Like a outfit.
export async function likeOutfit(user: UserI, outfit: OutfitOrId): Promise<LikeI | null> {
  const _like = await Like.findOne({ user, outfit }).populate(POPULATE).exec();
  const _outfit = await Outfit.findById(outfit);
  if (_outfit === null) {
    return null;
  }
  const _stylist = await User.findById(_outfit.stylist);
  if (_stylist === null) {
    return null;
  }
  sendPushNotification(
    [_stylist.deviceToken], "New Like",
    `${user.fullName} liked your outfit.`,
    {}, true, null
  );

  if (_like) return _like;
  return (await Like.create({ user, outfit, type: LikeType.Outfit }));
}

// UnLike a outfit.
export async function unlikeOutfit(user: UserOrId, outfit: OutfitOrId): Promise<LikeI | null> {
  return await Like.findOneAndDelete({ user, outfit }).populate(POPULATE).exec();
}

// Like a clothing item.
export async function likeClothingItem(user: UserOrId, clothingItem: ClothingItemOrId): Promise<LikeI | null> {
  const _like = await Like.findOne({ user, clothingItem });
  if (_like) return _like;
  //@ts-ignore
  return (await Like.create({ user, clothingItem, type: LikeType.ClothingItem })).populate(POPULATE).exec();
}

// UnLike a clothing item.
export async function unlikeClothingItem(user: UserOrId, clothingItem: ClothingItemOrId): Promise<LikeI | null> {
  return await Like.findOneAndDelete({ user, clothingItem }).populate(POPULATE).exec();
}
