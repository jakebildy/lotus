import { assert } from "console";
import { UserEvent, UserEventI } from "../models/user-event.model";
import { User, UserI } from "../models/user.model";
import { findUserByEmail } from "./user.service";

// Work out days for start of tomorrow and one week before
const oneDay = 1000 * 60 * 60 * 24;
const oneWeek = oneDay * 7;
const oneMonth = oneDay * 30;

export const UserEvents = {
  login: "login",
  signup: "signup",
  download: "download",
}


export async function logUserEvent(name: string, user: UserI): Promise<UserEventI> {
  return await UserEvent.create({ name, user });
}

export async function getAllUserEvents(name: string): Promise<Array<UserEventI>> {
  return await UserEvent.find({ name });
}

export async function getDailyActive(name: string): Promise<[{ _id: string, dau: number }]> {

  const d = Date.now();
  const lastDay = d - (d % oneDay) + oneDay;
  const firstDay = lastDay - oneWeek;

  const results = await UserEvent.aggregate(
    [
      { "$match": { name, "createdAt": { "$gte": new Date(firstDay), "$lt": new Date(lastDay) } } },
      {
        "$group": {
          "_id": {
            "user": "$user",
            "ymd": { "$dateToString": { "format": "%Y-%m-%d", "date": "$createdAt" } }
          }
        }
      },
      { "$group": { "_id": "$_id.ymd", "dau": { "$sum": 1 } } }
    ]) as [{ _id: string, dau: number }];

  console.log("🔥 getDailyActive", results);
  // console.log("🔥 getDailyActive222 ", await UserEvent.find());
  return results;
}

export async function getWeeklyActive(name: string): Promise<[{ _id: string, wau: number }]> {

  const d = Date.now();
  const lastDay = d - (d % oneDay) + oneDay;
  const firstDay = lastDay - oneWeek*14;

  const results = await UserEvent.aggregate(
    [
      { "$match": { name, "createdAt": { "$gte": new Date(firstDay), "$lt": new Date(lastDay) } } },
      {
        "$group": {
          "_id": {
            "user": "$user",
            "ymd": { "$dateToString": { "format": "%U", "date": "$createdAt" } }
          }
        }
      },
      { "$group": { "_id": "$_id.ymd", "wau": { "$sum": 1 } } }
    ]) as [{ _id: string, wau: number }];

  console.log("🔥 getWeeklyActive", results);
  // console.log("🔥 getDailyActive222 ", await UserEvent.find());
  return results;
}

export async function getMonthlyActive(name: string): Promise<[{ _id: string, dau: number }]> {

  const d = Date.now();

  const results = await UserEvent.aggregate(
    [
      {
        "$group": {
          "_id": {
            "user": "$user",
            "ym": { "$dateToString": { "format": "%Y-%m", "date": "$createdAt" } }
          }
        }
      },
      { "$group": { "_id": "$_id.ym", "mau": { "$sum": 1 } } }
    ]) as [{ _id: string, dau: number }];

  console.log("🔥 getMonthlyActive", results);
  return results;
}

export async function getUserFrequency(name: string): Promise<[{ _id: string, freq: number }]> {

  const d = Date.now();
  const lastDay = d - (d % oneDay) + oneDay;
  const firstDay = lastDay - oneWeek;

  const results = await UserEvent.aggregate(
    [
      { "$match": { name, "createdAt": { "$gte": new Date(firstDay), "$lt": new Date(lastDay) } } },
      { "$group": { "_id": "$user", "freq": { "$sum": 1 } } }
    ]) as [{ _id: string, freq: number }];

  console.log("🔥 getFrequency", results);
  // console.log("🔥 getDailyActive222 ", await UserEvent.find());
  return results;
}

async function test(): Promise<void> {
  console.log("📈Testing Analytics 📈");
  // const user = await findUserByEmail("isaiahballah@gmail.com");
  // assert(user);
  // await logUserEvent(UserEvents.login, user as UserI);
  getDailyActive(UserEvents.login);
  getMonthlyActive(UserEvents.login);
  getAllUserEvents(UserEvents.login);
}
test();
