
import express, { Response } from "express";
import * as BoardService from "../services/board.service";
import { RequestI } from "../types/request";
import { userAuth } from "../middleware/auth.middleware";
import { getAll } from "../services/outfit.service";

export const router = express.Router();

async function getUsersBoards(req: RequestI, res: Response) {
  try {
    const board = await BoardService.getUsersBoards(req.params.id);
    return res.json(board);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function getAllBoards(req: RequestI, res: Response) {
  try {
    const board = await BoardService.getAllBoards();
    return res.json(board);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function saveOutfitToBoard(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthorized";
    const board = await BoardService.saveOutfitToBoard(req.user, req.params.id, req.params.boardId);
    return res.json(board);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function unsaveOutfitToBoard(req: RequestI, res: Response) {
  try {
    if (!req.user) throw "Not logged in - unauthorized";
    const board = await BoardService.unsaveOutfitToBoard(req.user, req.params.id, req.params.boardId);
    return res.json(board);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
}

async function createBoard(req: RequestI, res: Response) {
    try {
      if (!req.user) throw "Not logged in - unauthorized";
      const board = await BoardService.createBoard(req.user, req.body.name, req.body.outfits);
      return res.json(board);
    } catch (e) {
      console.log(e);
      res.status(500).send(e);
    }
  }
  
  async function deleteBoard(req: RequestI, res: Response) {
    try {
      if (!req.user) throw "Not logged in - unauthorized";
      const board = await BoardService.deleteBoard(req.params.id);
      return res.json(board);
    } catch (e) {
      console.log(e);
      res.status(500).send(e);
    }
  }

router.get("/boards/user/:id", getUsersBoards);
router.get("/boards/all", getAllBoards);

router.post("/boards/save/:id/:boardId", userAuth, saveOutfitToBoard);
router.delete("/boards/unsave/:id/:boardId", userAuth, unsaveOutfitToBoard);

router.post("/boards/create", userAuth, createBoard);
router.delete("/boards/remove/:id", userAuth, deleteBoard);