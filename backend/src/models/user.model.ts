import mongoose, { ObjectId } from 'mongoose';
const defaultImage = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

export interface UserI {
  _id?: string | ObjectId;
  fullName: string;
  username: string;
  email: string;
  password?: string;

  avatar?: string;
  lastSeenActivity?: Date,
  deviceToken?: string,

  streak?: number,
  streakValueNeverReset?: number,
  totalMinutes?: number,
  gems?: number,
  totalEggs?: number,
  hatchProgressEggOne?: number,

  lastMeditated?: Date,
  streakLostAndSeenAt?: Date,
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

const UserSchema = new mongoose.Schema<UserI>(
  {
    email: { type: String, unique: true, required: true },
    fullName: { type: String, required: true },
    username: { type: String, required: true, unique: true },
    password: { type: String, required: true },

    avatar: { type: String, required: true, default: defaultImage },
    lastSeenActivity: { type: Date, required: true },
    deviceToken: { type: String, required: false },

    streak: { type: Number, required: false },
    streakValueNeverReset: { type: Number, required: false },
    totalMinutes: { type: Number, required: false },
    gems: { type: Number, required: false },
    totalEggs: { type: Number, required: false },
    hatchProgressEggOne: { type: Number, required: false },

    lastMeditated: { type: Date, required: false },
    streakLostAndSeenAt: { type: Date, required: false },
    meditationTimes: { type: Array, required: false },
    meditationTimesAsOf: { type: Date, required: false },
    
    meditationHistory: { type: Map, of: Number },
    unlockedTurtles: { type: Array, required: false },
    unlockedTurtleColors: { type: [[Number]], required: false },
    eggs: { type: Number, required: false },
    streakFreezes: { type: Number, required: false, default: 3 },
    eggTypes: {type: Array, required: false},

    emojisSentAt: { type: Map, of: Date, required: false },
    sentEmojis: { type: Map, of: String, required: false },
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

UserSchema.index({ fullName: 'text', username: 'text' });
export const User = mongoose.model('User', UserSchema);