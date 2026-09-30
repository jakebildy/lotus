import { Storage } from "@google-cloud/storage";
import { File, FileI } from "../models/file.model";
import { ObjectId } from "mongoose";
import { UserI } from "../models/user.model";

const storage = new Storage();
const myBucket = storage.bucket("shellevate");

const STORAGE_BASE_URL = "https://storage.googleapis.com/shellevate/";

export const toUrl = (fileName: string): string => {
  return STORAGE_BASE_URL + fileName;
};

export const getExtension = (name: string): string => {
  const extension: string | undefined = name.split(".").pop();
  if (!extension) throw "cannot get extension from file name";
  return extension;
};

// Saves a base64 encoded upload to cloud storage and records it in mongo.
export const uploadFile = async (
  upload: FileI,
  userId: string | ObjectId | UserI | null,
): Promise<FileI | null> => {
  if (!upload.data) throw "no data found, cannot upload file";
  const extension = getExtension(upload.name);
  let file = await new File(upload).save();
  const name = `${file._id}.${extension}`;

  const cloudFile = myBucket.file(name);
  const decodedFile = Buffer.from(upload.data, "base64");

  await cloudFile.save(decodedFile);

  file.name = name;
  file.url = toUrl(name);
  file.extension = extension;

  // NOTE: `userId` is not a field on the File schema (the schema field is `user`),
  // so this value is not persisted.
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  (file as any).userId = userId;
  file = await file.save();

  return file;
};

export const uploadFiles = async (
  uploads: FileI[],
  userId: string | UserI | ObjectId,
): Promise<FileI[] | null> => {
  const files: FileI[] = [];
  for (const upload of uploads) {
    const file = await uploadFile(upload, userId);
    if (file) files.push(file);
    else {
      console.log("failed to upload file: ");
      console.log(upload, userId);
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
  const deletedFile = await File.findByIdAndDelete(file._id);
  if (!deletedFile) return null;
  await deleteCloudFile(deletedFile.name);
  return deletedFile;
};
