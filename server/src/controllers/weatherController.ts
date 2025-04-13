import type { Response, Request, NextFunction } from "express";

//services
import { getLocation } from "../services/locationService";
import { getWeatherdata,getWeatherforecast, getWeatherforecastHourly } from "../services/weatherService";

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
      //get weather forecast
      const data = await getWeatherdata({ location:province, lang });
      //return
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data: { province, ...data },
      });
    } catch (error) {
      next(error);
    }
  }
  //get hourly weather f orecast
  async getWeatherforecastHourly(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
    //ขอชื่อจังหวัด
    const province: string = (req.query.location as string) ?? "กรุงเทพ";
    //ขอชื่อภาษา
    const lang = (req.query.lang as string) ?? null;
    try {
      //get weather forecast
      const data = await getWeatherforecastHourly({ location: province, lang });
      //return
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data: { province, ...data },
      });
    } catch (error) {
      next(error);
    }
  }
  //get 7 days weather forecast
  async getWeatherforecast(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
    //ขอชื่อจังหวัด
    const province: string = (req.query.location as string) ?? "กรุงเทพ";
    //ขอชื่อภาษา
    const lang = (req.query.lang as string) ?? null;
    try {
      //get weather forecast
      const data = await getWeatherforecast({ location: province, lang });
      //return
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data: { province, ...data },
      });
    } catch (error) {
      
      next(error);
    }
  }
}
export const weatherController = new weather();
