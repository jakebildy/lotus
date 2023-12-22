
import axios from "axios";
import { GoogleUser } from "../types/google_user.type";
import { User, UserI } from "../models/user.model";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
import jwt from 'jsonwebtoken';
import { uploadFile } from "./file.service";
import { FileI } from "../models/file.model";

dotenv.config();
const JWT_PRIVATE_KEY = process.env.JWT_PRIVATE_KEY;

export async function getGoogleUser(access_token: string, id_token: string): Promise<GoogleUser> {
  const googleUser = await axios.get(
    `https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=${access_token}`,
    {
      headers: {
        Authorization: `Bearer ${id_token}`,
      },
    },
  );
  const user: GoogleUser = googleUser.data;
  return user;
}

// Search for and return a stylist by text.
export async function searchUsers(text: string): Promise<UserI[]> {
  return await User.find({ $text: { $search: text }, }).exec();;
}

// Get users
export async function getUsers(): Promise<UserI[]> {
  return await User.find();
}

export async function findUserByEmail(email: string): Promise<UserI | null> {
  const user = await User.findOne({ email });
  return user;
}

export async function findUserByUsername(username: string): Promise<UserI | null> {
  const user = await User.findOne({ username });
  return user;
}

export async function comparePassword(user: UserI, password: string): Promise<boolean> {
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  // console.log(`Comparing password: ${password} with user password: ${user.password}`);
  const result = await bcrypt.compare(password, user.password!);
  // console.log(`Compare result: ${result}`);
  return result;
}

export async function createUserFromGoogleUser(googleUser: GoogleUser): Promise<UserI> {
  return await User.create({ email: googleUser.email, fullName: googleUser.given_name, username: googleUser.family_name });
}

export async function createUser(user: UserI, password: string): Promise<UserI> {
  return await User.create({
    ...user,
    password: bcrypt.hashSync(password, bcrypt.genSaltSync(10)),
    _id: null
  });
}

export interface UserUpdate {
  fullName?: string,
  displayName?: string,
  deviceToken?: string,

  streak?: number,
  totalMinutes?: number,
  gems?: number,
  totalEggs?: number,
  hatchProgressEggOne?: number,

  lastMeditated?: Date,
  meditationTimes?: Array<number>,
  meditationTimesAsOf?: Date,

  meditationHistory?: { [key: string]: number };
  unlockedTurtles?: Array<any>; // Replace 'any' with a more specific type if applicable
  unlockedTurtleColors?: Array<Array<number>>;
  eggs?: number;

  streakFreezes?: number;
  eggTypes?: Array<string>;

  emojisSentAt?: { [key: string]: Date };
  sentEmojis?: { [key: string]: string };
}


export async function updateUser(user: UserI, userUpdate: UserUpdate): Promise<UserI | null> {
  await User.findByIdAndUpdate(user, {
    ...userUpdate,
    username: user.username
  });
  const _user = await User.findById(user);
  return _user;
}

export async function login(email: string, password: string): Promise<UserI> {
  const user: UserI | null = await findUserByEmail(email);
  if (!user) throw "No user found with email: " + email;
  if (!comparePassword(user, password)) {
    console.log("Incorrect password 😡");
    throw "Incorrect password";
  };

  return user;
}

export async function getJwtFromUser(user: UserI): Promise<string> {
  if (!JWT_PRIVATE_KEY) throw "process.env.JWT_PRIVATE_KEY is not defined!";
  return jwt.sign({ _id: user._id }, JWT_PRIVATE_KEY);
}

export async function getUserFromJwt(token: string): Promise<UserI | null> {
  if (!JWT_PRIVATE_KEY) throw "process.env.JWT_PRIVATE_KEY is not defined!";
  const jwtPayload = jwt.verify(token, JWT_PRIVATE_KEY);
  const user = await User.findById((<UserI>jwtPayload)._id);
  return user;
}

export async function uploadAvatar(user: UserI, fileName: string, base64: string): Promise<UserI | null> {
  const file: FileI | null = await uploadFile({ name: fileName, data: base64 } as FileI, user);
  if (!file) throw "Failed to upload avatar";

  await User.findByIdAndUpdate(user, { avatar: file.url });
  return await User.findById(user);
};