import { UserEvent, UserEventI } from "../models/user-event.model";
import { UserI } from "../models/user.model";

const oneDay = 1000 * 60 * 60 * 24;
const oneWeek = oneDay * 7;

export const UserEvents = {
  login: "login",
  signup: "signup",
  download: "download",
};

// Returns the timestamp of the start of tomorrow (UTC).
function startOfTomorrow(): number {
  const d = Date.now();
  return d - (d % oneDay) + oneDay;
}

export async function logUserEvent(
  name: string,
  user: UserI,
): Promise<UserEventI> {
  return await UserEvent.create({ name, user });
}

export async function getAllUserEvents(
  name: string,
): Promise<Array<UserEventI>> {
  return await UserEvent.find({ name });
}

export async function getDailyActive(
  name: string,
): Promise<Array<{ _id: string; dau: number }>> {
  const lastDay = startOfTomorrow();
  const firstDay = lastDay - oneWeek;

  const results = await UserEvent.aggregate<{ _id: string; dau: number }>([
    {
      $match: {
        name,
        createdAt: { $gte: new Date(firstDay), $lt: new Date(lastDay) },
      },
    },
    {
      $group: {
        _id: {
          user: "$user",
          ymd: { $dateToString: { format: "%Y-%m-%d", date: "$createdAt" } },
        },
      },
    },
    { $group: { _id: "$_id.ymd", dau: { $sum: 1 } } },
  ]);

  console.log("🔥 getDailyActive", results);
  return results;
}

export async function getWeeklyActive(
  name: string,
): Promise<Array<{ _id: string; wau: number }>> {
  const lastDay = startOfTomorrow();
  const firstDay = lastDay - oneWeek * 14;

  const results = await UserEvent.aggregate<{ _id: string; wau: number }>([
    {
      $match: {
        name,
        createdAt: { $gte: new Date(firstDay), $lt: new Date(lastDay) },
      },
    },
    {
      $group: {
        _id: {
          user: "$user",
          ymd: { $dateToString: { format: "%U", date: "$createdAt" } },
        },
      },
    },
    { $group: { _id: "$_id.ymd", wau: { $sum: 1 } } },
  ]);

  console.log("🔥 getWeeklyActive", results);
  return results;
}

// NOTE: unlike the other stats, this one is not filtered by event name or date range.
export async function getMonthlyActive(
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  name: string,
): Promise<Array<{ _id: string; mau: number }>> {
  const results = await UserEvent.aggregate<{ _id: string; mau: number }>([
    {
      $group: {
        _id: {
          user: "$user",
          ym: { $dateToString: { format: "%Y-%m", date: "$createdAt" } },
        },
      },
    },
    { $group: { _id: "$_id.ym", mau: { $sum: 1 } } },
  ]);

  console.log("🔥 getMonthlyActive", results);
  return results;
}

export async function getUserFrequency(
  name: string,
): Promise<Array<{ _id: string; freq: number }>> {
  const lastDay = startOfTomorrow();
  const firstDay = lastDay - oneWeek;

  const results = await UserEvent.aggregate<{ _id: string; freq: number }>([
    {
      $match: {
        name,
        createdAt: { $gte: new Date(firstDay), $lt: new Date(lastDay) },
      },
    },
    { $group: { _id: "$user", freq: { $sum: 1 } } },
  ]);

  console.log("🔥 getFrequency", results);
  return results;
}
