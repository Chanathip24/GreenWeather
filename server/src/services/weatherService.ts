import axios from "axios";
import { ApiError, httpStatus } from "../utils/Error";
import type { locationInput } from "../types/locationType";

const apikey = process.env.WEATHER_API_KEY || null;

const BASE_FORECAST_DAILY_URL =
  "https://api.openweathermap.org/data/2.5/forecast/daily";
const BASE_FORECAST_HOURLY_URL =
  "https://api.openweathermap.org/data/2.5/forecast";
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

export const getWeatherforecast = async (data: locationInput): Promise<any> => {
  if (!apikey) {
    throw new ApiError(
      httpStatus.FAILED,
      "Please insert your apikey on .env file"
    );
  }
  try {
    const response = await axios.get(BASE_FORECAST_DAILY_URL, {
      params: {
        q: data.location,
        units: "metric",
        lang: data.lang ?? "th",
        appid: apikey,
      },
    });

    return response.data;
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to fetch weather data."
    );
  }
};
//get date service
const getDate = (dt: Date): string => dt.toISOString().split("T")[0];

export const getWeatherforecastHourly = async (
  data: locationInput
): Promise<any> => {
  if (!apikey) {
    throw new ApiError(
      httpStatus.FAILED,
      "Please insert your apikey on .env file"
    );
  }
  try {
    const response = await axios.get(BASE_FORECAST_HOURLY_URL, {
      params: {
        q: data.location,
        units: "metric",
        lang: data.lang ?? "th",
        appid: apikey,
      },
    });
    const today = getDate(new Date());
    const hourlyToday = response.data.list.filter((item: any) =>
      item.dt_txt.startsWith(today)
    );
    return { city: response.data.city.name, hourly: hourlyToday };
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to fetch weather data."
    );
  }
};
