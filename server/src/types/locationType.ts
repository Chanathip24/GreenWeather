export interface locationResponse {
  locationName: { en?: string; th: string };
  lat: string;
  lon: string;
}

export interface locationInput {
  lang?: string;
  location : string;
}
