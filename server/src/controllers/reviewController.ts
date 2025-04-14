import type { Request, Response, NextFunction } from "express";
import { addLikeReview, createReview, getAllReviews } from "./../services/reviewService";
import type { IReview } from "../types/reviewType";
import { httpStatus } from "../utils/Error";

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
        res.status(httpStatus.FAILED).json({
          status: "error",
          message: "Location is required",
        });
        return;
      }
      const reviews = await getAllReviews(location);

      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data: reviews,
      });
    } catch (error) {
      next(error);
    }
  }

  async updateLikeReview(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const data:Partial<IReview> = req.body
      const review = await addLikeReview(data);

      res.status(httpStatus.OK).json({
        status: "success",
        message: "Update review successfully",
        data: review,
      });
    } catch (error) {
      next(error);
    }
  }
}

export const reviewController = new Reviewcontroller();
