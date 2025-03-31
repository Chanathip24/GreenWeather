import express from "express";
import type { Response, Request, NextFunction } from "express";
import axios from "axios";
import { getLocation } from "../services/locationService";
import { httpStatus } from "../utils/Error";
import { getWeatherdata } from "../services/weatherService";
import { weatherController } from "../controllers/weatherController";

const router = express.Router();

const apikey = process.env.WEATHER_API_KEY;
const data = { lat: 51.4969, lon: -0.0087 };

//check weather
router.get("/",weatherController.currentForecast);

//check pollution
router.get("/pm25", async (req: Request, res: Response) => {
  try {
    const response = await axios.get(
      `http://api.openweathermap.org/data/2.5/air_pollution?lat=${data.lat}&lon=${data.lon}&lang=th&appid=${apikey}`
    );
    res.json(response.data);
  } catch (error) {
    res.status(500).json(error);
  }
});

router.get("/find", async (req: Request, res: Response, next: NextFunction) => {
  //ขอชื่อจังหวัด
  const province: string = (req.query.location as string) ?? "กรุงเทพ";
  try {
    const data = await getLocation(province);
    res.status(httpStatus.OK).json({
      status: "success",
      message: "Fetch data successfully",
      data: data,
    });
  } catch (error) {
    next(error);
  }
});

export default router;
