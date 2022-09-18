
import axios from "axios";
import { GoogleUser } from "../types/google_user.type";
import { User, UserI } from "../models/user.model";
import dotenv from "dotenv";
import bcrypt from "bcrypt";
import jwt from 'jsonwebtoken';
import { Seller, SellerI, SellerId } from "../models/seller.model";
import { uploadFile } from "./file.service";
import { FileI } from "../models/file.model";
import { ClothingItem } from "../models/clothingItem.model";

dotenv.config();
const JWT_PRIVATE_KEY = process.env.JWT_PRIVATE_KEY;

export async function getSellers(): Promise<SellerI[]> {
  const sellers = await Seller.find();
  return sellers;
}

export async function getById(id: string): Promise<SellerI | null> {
  const seller = await Seller.findById(id);
  return seller;
}

// Search for and return a seller by text.
export async function searchSellers(text: string): Promise<SellerI[]> {
  return await Seller.find({ $text: { $search: text }, }).exec();
}

export async function findSellerByEmail(email: string): Promise<SellerI | null> {
  const seller = await Seller.findOne({ email });
  return seller;
}

export async function createSeller(seller: SellerI): Promise<SellerI> {
  return await Seller.create({
    ...seller,
    password: seller.password ? bcrypt.hashSync(seller.password, bcrypt.genSaltSync(10)) : null,
    _id: null
  });
}

export async function deleteSeller(seller: SellerId): Promise<SellerI|null> {
  await ClothingItem.deleteMany({ seller });
  return await Seller.findByIdAndDelete(seller);
}

// export async function uploadLogo(seller: SellerId, fileName: string, base64: string): Promise<UserI> {
//   const file: FileI | null = await uploadFile({ name: fileName, data: base64 } as FileI, null);
//   if (!file) throw "Failed to upload avatar";

//   await Seller.findByIdAndUpdate(seller, { avatar: file.url });
//   return await Seller.findById(seller);
// };

export async function getJwtFromSeller(seller: SellerI): Promise<string> {
  if (!JWT_PRIVATE_KEY) throw "process.env.JWT_PRIVATE_KEY is not defined!";
  return jwt.sign({ _id: seller._id }, JWT_PRIVATE_KEY);
}

export async function getSellerFromJwt(token: string): Promise<SellerI|null> {
  if (!JWT_PRIVATE_KEY) throw "process.env.JWT_PRIVATE_KEY is not defined!";
  const jwtPayload = jwt.verify(token, JWT_PRIVATE_KEY);
  const seller = await Seller.findById((<SellerI>jwtPayload)._id);
  return seller;
}

// Search for and return a clothing item by id.
export async function setAvatar(sellerId: SellerId, fileName: string, base64: string): Promise<SellerI | null> {
  const seller = await Seller.findById(sellerId);
  if (!seller) throw "No item found";
  if (seller == undefined) throw "No item found";

  // eslint-disable-next-line no-useless-escape
  const matches = base64.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/);//,  response = {};

  if (matches?.length !== 3) {
    throw new Error('Invalid input string');
  }

  const _data = matches[2];
  const file: FileI | null = await uploadFile({ name: fileName, data: _data } as FileI, null);
  if (!file) throw "Failed to upload avatar";

  const _seller = await Seller.findByIdAndUpdate(seller, { file, avatar: file.url }, {new: true});

  return _seller;
}