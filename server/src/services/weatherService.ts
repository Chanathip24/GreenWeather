import axios from "axios";
import { ApiError, httpStatus } from "../utils/Error";
import type { locationInput } from "../types/locationType";

const apikey = process.env.WEATHER_API_KEY || null;

//get weather forecast current
export const getWeatherdata = async (data: locationInput): Promise<any> => {
  if (!apikey) {
    throw new ApiError(
      httpStatus.FAILED,
      "Please insert your apikey on .env file"
    );
  }
  try {
    const response = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?q=${
        data.location
      }&units=metric&lang=${data.lang ?? "th"}&appid=${apikey}`
    );

    return response.data;
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to fetch weather data."
    );
  }
};
