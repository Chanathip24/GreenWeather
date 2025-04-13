import type { NextFunction, Request, Response } from "express";
import { getPM, getPMIQAIR } from "../services/pmService";
import { httpStatus } from "../utils/Error";
class Airpollution {
  async iqair(req: Request, res: Response, next: NextFunction): Promise<void> {
    //ขอชื่อจังหวัด
    const province: string = (req.query.location as string) ?? "กรุงเทพ";

    try {
      const data = await getPMIQAIR({ location: province });
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data,
      });
      return;
    } catch (error) {
      next(error);
    }
  }
  async getPollution(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    //ขอชื่อจังหวัด
    const province: string = (req.query.location as string) ?? "กรุงเทพ";
    //ขอชื่อภาษา
    const lang = (req.query.lang as string) ?? null;
    try {
      const data = await getPM({ location: province, lang });
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data,
      });
      return;
    } catch (error) {
      next(error);
    }
  }
}

export const airPollution = new Airpollution();
