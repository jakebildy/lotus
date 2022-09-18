import { NextFunction, Response } from "express";
import * as UserService from "../services/user.service";
import * as SellerService from "../services/seller.service";
import { RequestI } from "../types/request";

export async function userAuth(req: RequestI, res: Response, next: NextFunction): Promise<void|Response<any, Record<string, any>>> {
	//try to get auth jwt from cookies and load user object into req
	try {
		const userJwt = req.cookies["user"];
		const user = await UserService.getUserFromJwt(userJwt);
		if (!user) throw "Unauthorized";
		req.user = user;
		return next();
	} catch (e) {
		//unauthorized
		return res.status(401).send(e + ", " +  req.url).end();
	}
}

export async function adminAuth(req: RequestI, res: Response, next: NextFunction): Promise<void|Response<any, Record<string, any>>> {
	//try to get auth jwt from cookies and load user object into req
	try {
		// const userJwt = req.cookies["user"];
		// const user = await UserService.getUserFromJwt(userJwt);
		// if (!user) throw "Unauthorized";
		// req.user = user;

		// TODO make sure user is admin ;)
		console.log("TODO: Admin auth");
		return next();
	} catch (e) {
		//unauthorized
		return res.status(401).send(e + ", " +  req.url).end();
	}
}

export async function sellerAuth(req: RequestI, res: Response, next: NextFunction): Promise<void|Response<any, Record<string, any>>> {
	//try to get auth jwt from cookies and load user object into req
	try {
		const sellerJwt = req.cookies["seller"];
		const seller = await SellerService.getSellerFromJwt(sellerJwt);
		if (!seller) throw "Unauthorized";
		req.seller = seller;
		return next();
	} catch (e) {
		//unauthorized
		return res.status(401).send(e + ", " +  req.url).end();
	}
}