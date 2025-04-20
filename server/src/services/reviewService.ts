import { reviewModel } from "../model/Reviewmodel";
import { userModel } from "../model/UserModel";
import type { IReview, reviewLike } from "../types/reviewType";
import { ApiError, httpStatus } from "../utils/Error";
import { createTransaction } from "./transactionService";

const rewardPoint: number = Number(process.env.POINT_REVIEW_REWARD) || 1;

export const createReview = async (data: IReview): Promise<IReview> => {
  if (!data) {
    throw new ApiError(httpStatus.NOT_FOUND, "No data provided.");
  }

  const review: IReview = await reviewModel.createReview(data);

  await userModel.addPoints({
    id: data.userId,
    type: "ADD",
    points: rewardPoint,
  }); // Add 1 point for creating a review

  await createTransaction({
    userId: data.userId,
    points: rewardPoint,
    type: "ADD",
    reason: "Create review",
  });

  return review;
};

export const getAllReviews = async (location?: string): Promise<IReview[]> => {
  const reviews: IReview[] = await reviewModel.getAllReviews(location);
  if (reviews.length === 0) {
    throw new ApiError(httpStatus.NOT_FOUND, "No reviews found.");
  }
  return reviews;
};

export const addLikeReview = async (
  data: reviewLike
): Promise<IReview> => {
  const review: IReview | null = await reviewModel.updateLikeReview(data);
  if (!review) {
    throw new ApiError(httpStatus.NOT_FOUND, "Review not found.");
  }
  return review;
};

//add user's like table
export const adduserlike = async (data: reviewLike): Promise<reviewLike> => {
  const response: reviewLike = await reviewModel.saveLikeuser(data);

  if (!response) {
    throw new ApiError(httpStatus.FAILED, "Failed to create review like user");
  }
  return response;
};

//delete user's like table
export const removeUserlike = async (data : reviewLike): Promise<reviewLike> =>{
  const response : reviewLike = await reviewModel.deleteLikeuser(data)
  if (!response) {
    throw new ApiError(httpStatus.FAILED, "Failed to create review like user");
  }
  return response;
}
//get user's like
export const getuserlike = async (
  data: Partial<reviewLike>
): Promise<reviewLike[]> => {
  if (!data.userId)
    throw new ApiError(httpStatus.FORBIDDEN, "No userId provided");
  const review: reviewLike[] = await reviewModel.getLikeuser(data.userId!);

  if(review.length === 0 ) throw new ApiError(httpStatus.NOT_FOUND,"No like found");
  return review;
};
