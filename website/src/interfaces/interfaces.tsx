export interface SellerI {
  _id?: string;
  shopName: string;
  email: string;
  avatar?: string;
}

export interface ClothingItemI {
  _id?: string;
  name: string;
  seller: string | SellerI;
  // sellerName: string;
  files?: FileI[];
  description: string;
  sizesInStock: string;
  sizes: string;
  overlayURLs: string;
  torsoOverlayURLs: string;
  saleAmount: string;
  dontGoToRevery?: string;
  itemsPageIndex?: string;
  reviews?: string;
  shippingCost?: string;
  videoURL?: string;
  price: string;

  gender: string;
  clothingType: string;
  purchaseUrl: string;

  saleIsFinal: string;
  promoCode: string;
  tags: string;
}

export interface OutfitI {
  _id?: string;
  stylist: UserI | string | UserI;
  gender: string;
  clothingItems: ClothingItemI[] | string[];
  modelPhoto: string;
  tags: string;
  accessoryOverlays: string;
}

//fileName: string, base64: string
export interface FileUpload {
  fileName: string;
  base64: any;
  file?: File;
}

export interface FileI {
  _id?: string,
  url: string,
  name: string,
  extension: string,
}

export interface UserI {
  _id?: string;
  firstName: string;
  lastName: string;
  email: string;
  password: string;
}

export type SellerId = string | SellerI;

