
import { reviewModel } from "../model/Reviewmodel";
import { userModel } from "../model/UserModel";
import type { IReview } from "../types/reviewType";
import { ApiError, httpStatus } from "../utils/Error";

const rewardPoint: number = Number(process.env.POINT_REVIEW_REWARD) || 1;

export const createReview = async (data: IReview): Promise<IReview> => {
  if (!data) {
    throw new ApiError(httpStatus.NOT_FOUND,"No data provided.");
  }

  const review: IReview = await reviewModel.createReview({
    userId: data.userId,
    location: data.location,
    aqi: data.aqi,
    detail: data.detail,
  });

  await userModel.addPoints({
    id: data.userId,
    type: "ADD",
    points: rewardPoint,
  }); // Add 1 point for creating a review

  return review;
};

export const getAllReviews = async (location? : string): Promise<IReview[]> => {
  const reviews: IReview[] = await reviewModel.getAllReviews(location);
  if (reviews.length === 0) {
    throw new ApiError(httpStatus.NOT_FOUND, "No reviews found.");
  }
  return reviews;
};

export const addLikeReview = async (data : Partial<IReview>): Promise<IReview> => {
  const review: IReview = await reviewModel.updateLikeReview(data);
  if (!review) {
    throw new ApiError(httpStatus.NOT_FOUND, "Review not found.");
  }
  return review;
}