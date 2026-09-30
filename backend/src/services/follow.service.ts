import { ObjectId } from "mongoose";
import { Follow, FollowI, FollowType } from "../models/follow.model";
import { User, UserI } from "../models/user.model";
import { sendPushNotification } from "../services/notifications.service";

type UserOrId = string | ObjectId | UserI;

const POPULATE = ["stylist", "user"];

// Returns a list of stylist and brands that a user is following
export async function getFollowing(user: UserOrId): Promise<FollowI[] | null> {
  return await Follow.find({ user }).populate(POPULATE).lean().exec();
}

// NOTE: currently returns every user, regardless of who `user` follows.
export async function getNotFollowing(
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  user: UserOrId,
): Promise<UserI[] | null> {
  return await User.find({}).lean().exec();
}

// Returns a list of users who are following a stylist
export async function getFollowers(
  stylist: UserOrId,
): Promise<FollowI[] | null> {
  return await Follow.find({ stylist }).populate(POPULATE).lean().exec();
}

export async function getEveryUserFollowers(): Promise<FollowI[] | null> {
  return await Follow.find().populate(POPULATE).lean().exec();
}

// Follow a stylist.
export async function followStylist(
  user: UserOrId,
  stylist: UserOrId,
): Promise<FollowI | null> {
  const _follow = await Follow.findOne({ user, stylist })
    .populate(POPULATE)
    .exec();
  const _stylist = await User.findById(stylist);
  const _user = await User.findById(user);
  sendPushNotification(
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    [_stylist!.deviceToken],
    "New Follower",
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    `${_user!.fullName} started following you.`,
    {},
    true,
    null,
  );

  if (_follow) return _follow;
  const created = await Follow.create({
    user,
    stylist,
    type: FollowType.Stylist,
  });
  // FIXME: in mongoose 6 document.populate() returns a Promise, which has no
  // .exec(), so this line throws after the follow has already been created.
  // Left as is on purpose to keep current behaviour; fix by dropping .exec().
  // @ts-expect-error see FIXME above
  return created.populate(POPULATE).exec();
}

export async function sendEmoji(
  user: UserOrId,
  targetUser: UserOrId,
  emoji: string,
): Promise<void> {
  const _targetUser = await User.findById(targetUser);
  const _user = await User.findById(user);

  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const deviceTokens = [_targetUser!.deviceToken];
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const senderName = _user!.fullName;

  let title: string;
  switch (emoji) {
    case "🙌":
      title = `${senderName} high-fived you! 🙌`;
      break;
    case "👉":
      title = `${senderName} poked you! 👉`;
      break;
    default:
      title = `${senderName} sent you a ${emoji}`;
      break;
  }

  sendPushNotification(deviceTokens, title, "", {}, true, null);
}

// Unfollow a stylist
export async function unfollowStylist(
  user: UserOrId,
  stylist: UserOrId,
): Promise<FollowI | null> {
  return await Follow.findOneAndDelete({ user, stylist })
    .populate(POPULATE)
    .exec();
}
