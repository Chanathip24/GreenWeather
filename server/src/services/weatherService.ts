import axios from "axios";
import { ApiError, httpStatus } from "../utils/Error";
import type { locationInput } from "../types/locationType";

import moment from "moment-timezone";

const apikey = process.env.WEATHER_API_KEY || null;

//convert unix time stamp to thai date
export const unixToThaiDate = (unixTimestamp: number): string => {
  const thaiTime = moment.unix(unixTimestamp).tz("Asia/Bangkok");
  return thaiTime.format("YYYY-MM-DD HH:mm:ss");
};

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
      `https://api.openweathermap.org/data/2.5/weather?lat=${data.lat}&lon=${data.lon}&units=metric&lang=${data.lang ?? "th"}&appid=${apikey}`
    );

    return {
      country: response.data.sys.country,
      weather: {
        main: response.data.weather[0].main,
        description: response.data.weather[0].description,
      },
      main: {
        temp: response.data.main.temp,
        feels_like: response.data.main.feels_like,
        pressure: response.data.main.pressure,
        humidity: response.data.main.humidity,
      },
      sun: {
        sunrise: unixToThaiDate(Number(response.data.sys.sunrise)),
        sunset: unixToThaiDate(Number(response.data.sys.sunset)),
      },
      date: unixToThaiDate(Number(response.data.dt)),
    };
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to fetch weather data."
    );
  }
};
