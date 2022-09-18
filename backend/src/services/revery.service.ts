import dotenv from "dotenv";
import pbkdf2 from "pbkdf2";
import { ClothingItemI } from "../models/clothingItem.model";
import axios from "axios";
import { FileI } from "../models/file.model";
import * as ClothingItemService from "./clothingItem.service";
import * as OutfitService from "./outfit.service";
import * as UserService from "./user.service";

dotenv.config();
const REVERY_PRIVATE_KEY = process.env.REVERY_PRIVATE_KEY ?? "";
const REVERY_PUBLIC_KEY = process.env.REVERY_PUBLIC_KEY ?? "";

const categoryMap: { [key: string]: string } = {
  "Tops": "tops",
  "Hoodies": "tops",
  "Sweatshirts": "tops",
  "Long-Sleeves": "tops",
  "Pants": "bottoms",
  "Jeans": "bottoms",
  "Sweatpants": "bottoms",
  "Shorts": "bottoms",
  "Skirts": "bottoms",
  "Jackets": "outerwear",
  "Dresses": "allbody",
  "Pantsuits": "tops",
};

const subcategoryMap: { [key: string]: string } = {
  "Tops": "",
  "Hoodies": "",
  "Sweatshirts": "",
  "Long-Sleeves": "",
  "Pants": "pants",
  "Jeans": "pants",
  "Sweatpants": "pants",
  "Shorts": "shorts",
  "Skirts": "skirts",
  "Jackets": "",
  "Dresses": "",
  "Pantsuits": "",
}

const genderMap: { [key: string]: string } = {
  "Men": "male",
  "Mens": "male",
  "Unisex": "male",
  "Women": "female",
  "Womens": "female",
}


// tops, bottoms, outerwear, allbody
// pants, shorts, skirts
export async function uploadClothingItem(clothingItem: ClothingItemI): Promise<any> {
  // Check if the clothing Item has an image,
  // If the item was processed before, delete it.
  // upload to revery

  try {
    if (!clothingItem._id) throw "No thumbnail, cannot upload garment to revery yet.";
    if (!clothingItem.files) throw "No thumbnail, cannot upload garment to revery yet.";
    if (clothingItem.files.length <= 0) throw "No thumbnail, cannot upload garment to revery yet.";
    if (clothingItem.reveryUploaded && clothingItem.reveryId) throw "Already uploaded this item to revery, no need to do it again sheesh lol";

    const body: { [key: string]: string } = {
      "garment_id": clothingItem._id.toString(),
      "category": categoryMap[clothingItem.clothingType],
      "gender": genderMap[clothingItem.gender],
      "garment_img_url": (clothingItem.files[0] as FileI).url,
    };

    if (body.category == "bottoms")
      body["bottoms_sub_category"] = subcategoryMap[clothingItem.clothingType];

    const response = await axios.post("https://api.revery.ai/console/v1/process_new_garment", body, {
      headers: getAuthenticationHeader(),
    });

    if (response.data.success)
      await ClothingItemService.markAsReveryUploaded(clothingItem, response.data.garment_id);

    console.log("- Uploaded ", clothingItem.name, " to revery. \n image: ", body.garment_img_url);
    return response.data;
  }
  catch (error) {
    console.log("error uploading clothing item to revery.");
    console.log(error);
  }
}

async function fetchProcessedItems(): Promise<any | null> {
  // https://api.revery.ai/console/v1/get_filtered_garments
  try {
    const response = await axios.get(`https://api.revery.ai/console/v1/get_filtered_garments?page_size=10000`, {
      headers: getAuthenticationHeader(),
    });
    console.log(response.data);
    return response.data;
  }
  catch (error) {
    console.log("error getting clothing item");
    console.log(error);
  }

  return null;
}


export async function getClothingItem(clothingItem: ClothingItemI): Promise<unknown | null> {
  // Check if the clothing Item has an image,
  // If the item was processed before, delete it.
  // upload to revery
  try {
    if (!clothingItem._id) throw "Clothing item must be a valid clothing item, _id is missing";
    const id = clothingItem._id.toString();

    const response = await axios.get(`https://api.revery.ai/console/v1/get_garment?garment_id=${id}`, {
      headers: getAuthenticationHeader(),
    });
    console.log(response.data);
    return response.data;
  }
  catch (error) {
    console.log("error getting clothing item");
    console.log(error);
  }

  return null;
}

export async function generateOutfitImage(clothingItems: ClothingItemI[], modelId: string, tuckIn: boolean): Promise<string | null> {

  try {
    const productIds: { [key: string]: string } = {};
    try {
      console.log(clothingItems.map((item) => item.name));
    }
    catch (error) {
      console.log("lol weird error");
    }

    for (const clothingItem of clothingItems) {
      if (!clothingItem.reveryId) throw "Clothing item must be a valid clothing item, reveryId is missing";

      const category: string = categoryMap[clothingItem.clothingType];
      productIds[category] = clothingItem.reveryId.toString();
    }

    // TODO randomize model
    // id: 'model 15147224'
    // id: 'model 13139372'

    const body = {
      garments: productIds,
      model_id: modelId,
      shoes_id: "model_15147224",
      // face_id
      background: "transparent",
      tuck_in: tuckIn,
    };

    console.log(body);

    const response = await axios.post(
      "https://api.revery.ai/console/v1/request_tryon",
      body,
      { headers: getAuthenticationHeader() },
    );

    console.log("SHEEEEESH");
    console.log(response.data);

    return `https://media.revery.ai/generated_model_image/${response.data.model_metadata.model_file}.png`;
  }
  catch (error) {
    console.log("failed to generate outfit");
    console.error(error);
  }

  return null;
}

export async function getFaces():
  Promise<{ [key: string]: { image: string; id: string; }[] } | undefined> {
  try {
    const maleResponse = await axios.get("https://api.revery.ai/console/v1/get_selected_faces?gender=male", {
      headers: getAuthenticationHeader(),
    });
    const femaleResponse = await axios.get("https://api.revery.ai/console/v1/get_selected_faces?gender=female", {
      headers: getAuthenticationHeader(),
    });

    const maleModelFiles = maleResponse.data.face_ids;
    const maleImages = [];

    const femaleModelFiles = femaleResponse.data.face_ids;
    const femaleImages = [];

    for (const face_id of maleModelFiles) {
      maleImages.push({ image: `https://revery-e-commerce-images.s3.us-east-2.amazonaws.com/revery_faces/${face_id}/crop.png`, id: face_id });
    }

    for (const face_id of femaleModelFiles) {
      femaleImages.push({ image: `https://revery-e-commerce-images.s3.us-east-2.amazonaws.com/revery_faces/${face_id}/crop.png`, id: face_id });
    }

    return {
      male: maleImages,
      female: femaleImages
    }
  }
  catch (error) {
    console.log("failed to fetch models");
    console.error(error);
  }
}
export async function getModels():
  Promise<{ [key: string]: { image: string; id: string; }[] } | undefined> {
  try {
    const maleResponse = await axios.get("https://api.revery.ai/console/v1/get_model_list?gender=male", {
      headers: getAuthenticationHeader(),
    });
    const femaleResponse = await axios.get("https://api.revery.ai/console/v1/get_model_list?gender=female", {
      headers: getAuthenticationHeader(),
    });

    const maleModelFiles = maleResponse.data.model_files;
    const maleModels = maleResponse.data.models;
    const maleImages = [];

    const femaleModelFiles = femaleResponse.data.model_files;
    const femaleModels = femaleResponse.data.models;
    const femaleImages = [];

    let i = 0;
    for (const file of maleModelFiles) {
      maleImages.push({ image: `https://media.revery.ai/generated_model_image/${file}.png`, id: maleModels[i] });
      i++;
    }

    i = 0;
    for (const file of femaleModelFiles) {
      femaleImages.push({ image: `https://media.revery.ai/generated_model_image/${file}.png`, id: femaleModels[i] });
      i++;
    }

    return {
      male: maleImages,
      female: femaleImages
    }
  }
  catch (error) {
    console.log("failed to fetch models");
    console.error(error);
  }
}
export async function getShoes():
  Promise<{ [key: string]: { image: string; id: string; }[] } | undefined> {
  try {
    const maleResponse = await axios.get("https://api.revery.ai/console/v1/get_selected_shoes?gender=male", {
      headers: getAuthenticationHeader(),
    });
    const femaleResponse = await axios.get("https://api.revery.ai/console/v1/get_selected_shoes?gender=female", {
      headers: getAuthenticationHeader(),
    });


    const maleShoeModelFiles = maleResponse.data.shoe_paths_dict;
    const maleShoeImages = [];

    const femaleShoeModelFiles = femaleResponse.data.shoe_paths_dict;
    const femaleShoeImages = [];

    for (const id in maleShoeModelFiles) {
      maleShoeImages.push({ image: `https://revery-e-commerce-images.s3.us-east-2.amazonaws.com/${maleShoeModelFiles[id]}`, id });
    }
    for (const id in femaleShoeModelFiles) {
      femaleShoeImages.push({ image: `https://revery-e-commerce-images.s3.us-east-2.amazonaws.com/${femaleShoeModelFiles[id]}`, id });
    }

    return {
      male: maleShoeImages,
      female: femaleShoeImages
    }
  }
  catch (error) {
    console.log("failed to fetch models");
    console.error(error);
  }
}
// getModels();

export function getAuthenticationHeader(): { [key: string]: string } {
  const millis = Date.now() / 1000;
  const time = millis.toFixed(0);

  const derivedKey = pbkdf2.pbkdf2Sync(REVERY_PRIVATE_KEY, time.toString(), 128, 32, 'sha256');
  const derivedKeyString = derivedKey.toString('hex');

  return {
    "public_key": REVERY_PUBLIC_KEY,
    "one_time_code": derivedKeyString,
    "timestamp": time,
  }
}

export async function run(): Promise<void> {
  try {
    // const catalog = await ClothingItemService.getClothingItems();

    // const testItem = catalog[0];

    // console.log(testItem);

    // const items: { garments: { image_urls: any, tryon: any, [key: string]: any }[] } = await fetchProcessedItems();
    // console.log(items);

    // for (const item of items.garments) {
    //   console.log(item.tryon);
    //   console.log(item.tryon);
    // }

    // await uploadEntireCatalog();

    // for (let i = 0; i < 25; i++) {
    await isaiahMakeSomeOutfits();
    // }

    console.log("🔥🔥🔥");
    // console.log(await getShoes());
    // console.log(await getFaces());

    console.log("DONE - Successfull revery TEST run");
  }
  catch (error) {
    console.log("error running revery");
    console.error(error);
  }
}
// run();

async function isaiahMakeSomeOutfits() {
  try {
    const stylist = await UserService.findUserByEmail("isaiahballah@gmail.com");
    console.log(stylist);
    // return;

    const outfit = await ClothingItemService.getRandomOutfit("Men");
    const models = await getModels();
    if (!models) throw "NO MODELS :.(";
    if (!outfit) throw "NO OUTFIT :.(";

    const model = models.female[ClothingItemService.random(0, models.female.length - 1)].id;
    console.log(outfit);

    const tryon = await generateOutfitImage(outfit, model, false);
    console.log(tryon);

    const ids = outfit.map((item) => item._id!.toString());

    //await OutfitService.createOutfit(stylist!, ids, model, "Men", false, tryon!);

    console.log("-Isaiah: I made a new outfit!! check it out on FITS!");
  }
  catch (error) {
    console.log("error running revery");
    console.error(error);
  }
}

export async function uploadEntireCatalog(): Promise<void> {
  try {
    const catalog = await ClothingItemService.getClothingItems();
    let i = 0;
    let j = 0;

    for (const clothingItem of catalog) {
      if (clothingItem.reveryUploaded && clothingItem.reveryId) {
        j++;
        console.log(clothingItem.name, " is already uploaded, count: ", j);
        continue;
      };
      if (!clothingItem.files) continue;
      if (clothingItem.files.length <= 0) continue;

      await uploadClothingItem(clothingItem);
      await sleep(1.2);
      i++;
      console.log("uploaded another item! count: ", i);
    }

    console.log("DONE - Successfull revery TEST run");
  }
  catch (error) {
    console.log("error running revery");
    console.error(error);
  }
}

export function sleep(seconds: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, seconds * 1000));
}