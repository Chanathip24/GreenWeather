import axios from "axios";
import { ApiError, httpStatus } from "../utils/Error";
import type { locationInput, locationResponse } from "../types/locationType";
import { getLocation } from "./locationService";

const apiKey = process.env.WAQI_KEY || null;

export const getPM = async (data: locationInput): Promise<any> => {
  try {
    const response = await axios.get(
      `https://api.waqi.info/feed/${data.location}/?token=${apiKey}`
    );
    // console.log(response.data, data.location);
    return response.data.data;
  } catch (error) {
    // console.log(error);
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to fetch Air Pollution api"
    );
  }
};

export const getPMIQAIR = async (data: locationInput): Promise<any> => {
  try {
    const location: locationResponse = await getLocation(data.location);
    const response = await axios.get(
      `https://api.airvisual.com/v2/nearest_city?lat=${location.lat}&lon=${location.lon}&key=ad8009ff-ef7b-407e-aec7-5f576327ef56`
    );

    return response.data;
  } catch (error) {
    console.log(error);
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to fetch Air Pollution api"
    );
  }
};
