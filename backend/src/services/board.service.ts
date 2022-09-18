import { ObjectId } from "mongoose";
import { ClothingItem, ClothingItemI } from "../models/clothingItem.model";
import { Outfit, OutfitI } from "../models/outfit.model";
import { User, UserI } from "../models/user.model";
import { POPULATE as clothing_populate } from "./clothingItem.service";
import { sendPushNotification } from "../services/notifications.service";
import { Board, BoardI } from "../models/board.model";

type UserOrId = string | ObjectId | UserI;
type ClothingItemOrId = string | ObjectId | ClothingItemI;
type OutfitOrId = string | ObjectId | OutfitI;
type BoardOrId = string | ObjectId | BoardI;

export const OUTFITS_POPULATE = [{
    path: 'clothingItems',
    populate: ["files", "seller"]
  },
  "stylist",
  ] ;

export async function getUsersBoards(user: UserOrId): Promise<BoardI[] | null> {
  const boards = await Board.find({ user }).populate({ 
    path: 'outfits',
    populate: OUTFITS_POPULATE
 }).populate('user').exec();
  return boards;
}

export async function getAllBoards(): Promise<BoardI[] | null> {
  const boards = await Board.find().populate({ 
    path: 'outfits',
    populate: OUTFITS_POPULATE
 }).populate('user').exec();
  return boards;
}

// Pin an outfit to a board.
export async function saveOutfitToBoard(user: UserI, outfit: OutfitOrId, board: BoardOrId): Promise<BoardI | null> {
  const _board = await Board.findById(board).exec();
  if (!_board) return null;

  //@ts-ignore
  if (_board.outfits.includes(outfit)) return _board;

  let newOutfits = _board.outfits;

  //@ts-ignore
  newOutfits.push(outfit);

  return await Board.findByIdAndUpdate(board, {outfits: newOutfits}, { new: true }).populate({ 
    path: 'outfits',
    populate: OUTFITS_POPULATE
 }).populate('user').exec();
}

// Unpin an outfit from a board.
export async function unsaveOutfitToBoard(user: UserI, outfit: OutfitOrId, board: BoardOrId): Promise<BoardI | null> {
    console.log("removing outfit from board\n");
    const _board = await Board.findById(board).exec();
    if (_board) {
    let newOutfits: any = _board.outfits;
    newOutfits = newOutfits.filter((item: ObjectId) => item.toString() !== outfit)
    return await Board.findByIdAndUpdate(board, {outfits: newOutfits}, { new: true }).populate({ 
        path: 'outfits',
        populate: OUTFITS_POPULATE
     }).populate('user').exec();
    } else {
      return null;
    }
}

// Create a board.
export async function createBoard(user: UserI, name: string, outfits: OutfitOrId[]): Promise<BoardI | null> {
    return await Board.create({user, name, outfits});
}

// Delete a board.
export async function deleteBoard(id: BoardOrId): Promise<BoardI | null> {
    return await Board.findByIdAndDelete(id);
}
  