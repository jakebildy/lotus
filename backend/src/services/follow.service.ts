import { ObjectId } from "mongoose";
import { Follow, FollowI, FollowType } from "../models/follow.model";
import { User, UserI } from "../models/user.model";
import { sendPushNotification } from "../services/notifications.service";

// /follow/following/
// /follow/followers/
// /follow/user/:id
// /follow/seller/:id
// /unfollow/user/:id
// /unfollow/seller/:id	

type UserOrId = string | ObjectId | UserI;

const POPULATE = ["stylist", "user"];

// Returns a list of stylist and brands that a user is following
export async function getFollowing(user: UserOrId): Promise<FollowI[] | null> {
  const following = await Follow.find({ user }).populate(POPULATE).exec();
  return following;
}

export async function getNotFollowing(user: UserOrId): Promise<FollowI[] | null> {
  const following = await Follow.find({ user: { $ne: user } }).populate(POPULATE).exec();
  return following;
}


// Returns a list of users who are following a stylist
export async function getFollowers(stylist: UserOrId): Promise<FollowI[] | null> {
  const followers = await Follow.find({ stylist }).populate(POPULATE).exec();
  return followers;
}

// Follow a stylist.
export async function followStylist(user: UserOrId, stylist: UserOrId): Promise<FollowI | null> {
  const _follow = await Follow.findOne({ user, stylist }).populate(POPULATE).exec();
  const _stylist = await User.findById(stylist);
  const _user = await User.findById(user);
  sendPushNotification(
    //@ts-ignore
    [_stylist.deviceToken], "New Follower",
    //@ts-ignore
    `${_user.fullName} started following you.`,
    {}, true, null
  );

  if (_follow) return _follow;
  //@ts-ignore
  return (await Follow.create({ user, stylist, type: FollowType.Stylist })).populate(POPULATE).exec();
}

// Unflollow a stylist
export async function unfollowStylist(user: UserOrId, stylist: UserOrId): Promise<FollowI | null> {
  return await Follow.findOneAndDelete({ user, stylist }).populate(POPULATE).exec();
}

