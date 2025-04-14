import type { Request, Response, NextFunction } from "express";
import { createReview, getAllReviews } from "./../services/reviewService";
import type { IReview } from "../types/reviewType";

class Reviewcontroller {
  //create review
  async createReview(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const data: IReview = req.body;
      const review = await createReview(data);

      res.status(201).json({
        status: "success",
        message: "Create review successfully",
        data: review,
      });
    } catch (error) {
      next(error);
    }
  }

  async getAllReviews(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const reviews = await getAllReviews();
      res.status(200).json({
        status: "success",
        message: "Fetch data successfully",
        data: reviews,
      });
    } catch (error) {
      next(error);
    }
  }

  async getReviewByLocation(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const location = req.query.location as string;
      if (!location) {
        res.status(400).json({
          status: "error",
          message: "Location is required",
        });
        return;
      }
      const reviews = await getAllReviews(location);

      res.status(200).json({
        status: "success",
        message: "Fetch data successfully",
        data: reviews,
      });
    } catch (error) {
      next(error);
    }
  }
}

export const reviewController = new Reviewcontroller();
