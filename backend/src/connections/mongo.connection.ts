import mongoose from "mongoose";

const MONGO_URL: string | undefined = process.env.MONGO_URL;

// Connect to mongo db.
export async function init(): Promise<void> {
  if (!MONGO_URL) throw "MONGO_URL is undefined";
  try {
    await mongoose.connect(MONGO_URL);
    console.log("Mongoose Connected");
  } catch (error) {
    // Deliberately not logging MONGO_URL here: it contains the database password.
    console.error(`Unable to connect to database ${error}`);
    throw error;
  }
}
