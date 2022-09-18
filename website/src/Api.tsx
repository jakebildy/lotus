import axios from "axios";
import { ClothingItemI, FileUpload, OutfitI, SellerI, UserI } from "./interfaces/interfaces";

axios.defaults.withCredentials = true;

const remoteURL = "https://thefits.app/api";
const testingURL = "http://localhost:8000/api";
const TESTING = process.env.NODE_ENV === "development";
const baseURL = TESTING ? testingURL : remoteURL;

const Api = {

  analytics: {
    getUsers: async (): Promise<SellerI[]> => {
      const response = await axios.get(baseURL + "/stats/users");
      return response.data;
    },
    getDau: async (name: string): Promise<any[]> => {
      const response = await axios.get(baseURL + "/stats/dau/" + name);
      return response.data;
    },
    getWau: async (name: string): Promise<any[]> => {
      const response = await axios.get(baseURL + "/stats/wau/" + name);
      return response.data;
    },
    getMau: async (name: string): Promise<any[]> => {
      const response = await axios.get(baseURL + "/stats/mau/" + name);
      return response.data;
    },
    getFreq: async (name: string): Promise<any[]> => {
      const response = await axios.get(baseURL + "/stats/freq/" + name);
      return response.data;
    },
    getAll: async (name: string): Promise<any[]> => {
      const response = await axios.get(baseURL + "/stats/all/" + name);
      return response.data;
    },
  },

  brands: {
    getBrands: async (): Promise<SellerI[]> => {
      const response = await axios.get(baseURL + "/seller/sellers");
      return response.data;
    },

    getBrand: async (brandId: string): Promise<SellerI> => {
      const response = await axios.get(baseURL + "/seller/sellers/" + brandId);
      return response.data;
    },

    create: async (seller: SellerI): Promise<SellerI> => {
      const response = await axios.post(baseURL + "/seller/create", seller);
      return response.data;
    },

    setAvatar: async (id: string, file: FileUpload): Promise<SellerI> => {
      const response = await axios.post(baseURL + `/seller/${id}/set-avatar`, file);
      return response.data;
    },

    delete: async (id: string): Promise<ClothingItemI> => {
      const response = await axios.delete(baseURL + "/seller/delete/" + id);
      return response.data;
    },
  },

  items: {
    getAll: async (): Promise<ClothingItemI[]> => {
      const response = await axios.get(baseURL + "/clothing-items/all");
      return response.data;
    },

    getById: async (id: string,): Promise<any> => {
      const response = await axios.get(baseURL + "/clothing-items/item/" + id);
      return response.data;
    },

    removeImage: async (id: string, imageId: string): Promise<any> => {
      const response = await axios.post(baseURL + `/clothing-items/remove-image/${id}/${imageId}`);
      return response.data;
    },

    getBrandsItems: async (seller: string): Promise<ClothingItemI[]> => {
      const response = await axios.get(baseURL + "/clothing-items/brand/" + seller);
      return response.data;
    },

    create: async (clothingItem: ClothingItemI): Promise<ClothingItemI> => {
      const response = await axios.post(baseURL + "/clothing-items/create", clothingItem);
      return response.data;
    },

    edit: async (id: String, clothingItem: ClothingItemI): Promise<ClothingItemI> => {
      const response = await axios.post(baseURL + "/clothing-items/edit/" + id, clothingItem);
      return response.data;
    },

    delete: async (clothingItemId: string): Promise<ClothingItemI> => {
      const response = await axios.delete(baseURL + "/clothing-items/delete/" + clothingItemId);
      return response.data;
    },

    addPhoto: async (id: string, file: FileUpload): Promise<ClothingItemI> => {
      const response = await axios.post(baseURL + "/clothing-items/add-photo/" + id, file);
      return response.data;
    },
  },

  outfits: {
    getAll: async (): Promise<OutfitI[]> => {
      const response = await axios.get(baseURL + "/outfits/all");
      return response.data;
    },
  },

  user: {
    me: async (): Promise<UserI> => {
      const response = await axios.get(baseURL + "/teacher/me/");
      return response.data;
    },
  },

  auth: {
    login: async (email: string, password: string): Promise<UserI> => {
      const response = await axios.post(baseURL + "/auth/login/", { email, password });
      return response.data;
    },

    signup: async (email: string, password: string, firstName: string, lastName: string): Promise<UserI> => {
      const response = await axios.post(baseURL + "/auth/signup/", { email, password, firstName, lastName });
      return response.data;
    },

    sellerLogin: async (email: string, password: string): Promise<UserI> => {
      const response = await axios.post(baseURL + "/auth/seller/login/", { email, password });
      return response.data;
    },

    serllerSignup: async (email: string, password: string, firstName: string, lastName: string): Promise<UserI> => {
      const response = await axios.post(baseURL + "/auth/seller/signup/", { email, password, firstName, lastName });
      return response.data;
    },
  },



}

export default Api;