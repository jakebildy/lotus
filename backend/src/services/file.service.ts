import fs from 'fs';
import { Storage } from '@google-cloud/storage';
import { File, FileI } from "../models/file.model";
import { ObjectId } from 'mongoose';
import { UserI } from '../models/user.model';

const storage = new Storage();
const myBucket = storage.bucket('fitsapp');

const STORAGE_BASE_URL = 'https://storage.googleapis.com/fitsapp/';

export const toUrl = (fileName: string): string => {
  return STORAGE_BASE_URL + fileName;
};

export const getExtension = (name: string): string => {
  const _extension: string | undefined = name.split('.').pop();
  if (!_extension) throw "cannot get extension from file name";
  return _extension;
};

export const uploadFile = async (upload: FileI, userId: string | ObjectId | UserI| null): Promise<FileI | null> => {
  if (!upload.data) throw "no data found, cannot upload file";
  const oldName = upload.name;
  const extension = getExtension(oldName);
  let file = await new File(upload).save();
  const name = `${file._id}.${extension}`;

  const cloudFile = myBucket.file(name);
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const data: string = upload.data;
  // console.log(data);

  // const matches = data.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/),
  //   response = {};

  // if (matches?.length !== 3) {
  //   throw new Error('Invalid input string');
  // }

  // response.type = matches[1];
  // response.data = new Buffer(matches[2], 'base64');


  // const decodedFile = data;// Buffer.from(data, "base64");
  // const decodedFile = Buffer.from(matches[2], "base64");
  const decodedFile = Buffer.from(data, "base64");
  // console.log(decodedFile);

  await cloudFile.save(decodedFile);

  file.name = name;
  file.url = toUrl(name);
  file.extension = extension;

  //@ts-ignore
  file.userId = userId;
  file = await file.save();

  return file;
};

export const uploadFiles = async (uploads: FileI[], userId: string | UserI | ObjectId): Promise<FileI[] | null> => {
  const filePromises: FileI[] = [];
  for (const upload of uploads) {
    const file = await uploadFile(upload, userId);
    if (file)
      filePromises.push(file);
    else {
      console.log("failed to upload file: ");
      console.log(upload, userId);
    }
  }

  const settledFiles = await Promise.allSettled(filePromises);
  const files: FileI[] = [];

  for (const settledFile of settledFiles) {
    if (settledFile.status == 'fulfilled') {
      files.push(settledFile.value);
    } else {
      console.error(settledFile.reason);
    }
  }

  return files;
};

const deleteCloudFile = async (gcloudFileName: string) => {
  const file = myBucket.file(gcloudFileName);
  const options = { ignoreNotFound: true };
  await file.delete(options);
};

export const deleteFile = async (file: FileI): Promise<FileI | null> => {
  //@ts-ignore
  file = File.findByIdAndDelete(file._id);
  await deleteCloudFile(file.name);
  return file;
};