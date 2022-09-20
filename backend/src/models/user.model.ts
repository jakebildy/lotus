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
  totalMinutes?: number,
  gems?: number,
  totalEggs?: number,
  hatchProgressEggOne?: number,


  // streetAddress?: string;
  // apt?: string;
  // city?: string;
  // state?: string;
  // zipcode?: string;

  // clothingGender?: string;

  // // Stylists
  // cashoutPending?: boolean;
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
    totalMinutes: { type: Number, required: false },
    gems: { type: Number, required: false },
    totalEggs: { type: Number, required: false },
    hatchProgressEggOne: { type: Number, required: false },

    // streetAddress: { type: String, required: false },
    // apt: { type: String, required: false },
    // city: { type: String, required: false },
    // state: { type: String, required: false },
    // zipcode: { type: String, required: false },

    // clothingGender: { type: String, required: false },

    // // Stylist
    // cashoutPending: { type: Boolean, default: false },
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

UserSchema.index({ fullName: 'text', username: 'text' });
export const User = mongoose.model('User', UserSchema);