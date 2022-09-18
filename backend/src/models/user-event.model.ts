import mongoose, { ObjectId } from 'mongoose';

export interface UserEventI {
  _id?: string | ObjectId;
  user?: string | ObjectId;
  name: string;
  createdAt: Date;
}

const UserEventSchema = new mongoose.Schema<UserEventI>(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    name: { type: String, required: true },
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

// UserEventSchema.index({ fullName: 'text', username: 'text' });
export const UserEvent = mongoose.model('UserEvent', UserEventSchema);