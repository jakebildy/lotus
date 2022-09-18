import mongoose from 'mongoose';
import { ObjectId, Schema } from 'mongoose';
import { UserI } from './user.model';

export interface FileI {
  _id?: string | ObjectId,
  user?: string | ObjectId | UserI,

  url: string,
  name: string,
  extension: string,
  data?: string,// | Buffer,
}

const FileSchema = new mongoose.Schema<FileI>(
  {
    user: { type: Schema.Types.ObjectId, ref: 'User' },
    url: {type: String},
    name: {type: String},
    extension: {type: String},
  },
  {
    versionKey: false,
    timestamps: true,
  }
);

export type FileId = string | ObjectId | FileI;
export const File = mongoose.model('File', FileSchema);
