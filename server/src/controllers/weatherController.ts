import type { Response, Request, NextFunction } from "express";

//services
import { getLocation } from "../services/locationService";
import { getWeatherdata } from "../services/weatherService";

//error
import { httpStatus } from "../utils/Error";
class weather {
  //get current forecast
  async currentForecast(req: Request, res: Response, next: NextFunction) {
    //ขอชื่อจังหวัด
    const province: string = (req.query.location as string) ?? "กรุงเทพ";
    //ขอชื่อภาษา
    const lang = (req.query.lang as string) ?? null;
    try {
      //get location lat and lon
      const { lat, lon, locationName } = await getLocation(province);
      //get weather forecast
      const data = await getWeatherdata({ lat, lon, lang });
      //return
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data: { locationName, ...data },
      });
    } catch (error) {
      next(error);
    }
  }

  //get current pm2.5
  //get 7 days weather forecast
}
export const weatherController = new weather();
