import axios from "axios";
import { ApiError, httpStatus } from "../utils/Error";
import type { locationResponse } from "../types/locationType";

const API_KEY = process.env.WEATHER_API_KEY;

export const getLocation = async (
  location: string
): Promise<locationResponse> => {
  try {
    const response = await axios.get(
      `http://api.openweathermap.org/geo/1.0/direct?q=${location}&limit=5&appid=${API_KEY}`
    );

    //จังหวัด
    const provinceData = response.data[0];

    return {
      locationName: {
        th: provinceData.local_names.th,
        en: provinceData.local_names.en,
      },
      lat: provinceData.lat,
      lon: provinceData.lon,
    };
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to fetch location."
    );
  }
};
