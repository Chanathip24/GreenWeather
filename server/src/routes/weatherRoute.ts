import express from "express";
import { weatherController } from "../controllers/weatherController";

const router = express.Router();

//check weather
router.get("/", weatherController.currentForecast);
router.get("/forecast/7days", weatherController.getWeatherforecast);
router.get("/forecast/hourly", weatherController.getWeatherforecastHourly);
export default router;
