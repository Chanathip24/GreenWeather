import express from "express";
import type { Response, Request } from "express";
import axios from "axios";


const router = express.Router();


const apikey = process.env.WEATHER_API_KEY;
const data = { lat: 51.4969, lon: -0.0087 };

//check weather
router.get("/weather", async (req: Request, res: Response) => {
  try {
    const response = await axios.get(
      `https://api.openweathermap.org/data/3.0/onecall?lat=51.4969&lon=-0.0087&units=metric&lang=th&appid=${apikey}`
    );
    res.json(response.data);
  } catch (error) {
    res.status(500).json(error);
  }
});

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

router.get("/find", async (req: Request, res: Response) => {
  try {
    const response = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?lat=${data.lat}&lon=${data.lon}&appid=${apikey}`
    );
    res.json(response.data);
  } catch (error) {
    res.status(500).json(error);
  }
});


export default router;
