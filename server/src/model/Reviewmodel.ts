import { PrismaClient } from "@prisma/client";
import { ApiError, httpStatus } from "../utils/Error";
import type { IReview, reviewLike } from "../types/reviewType";

const prisma = new PrismaClient();

class Reviewmodel {
  //get all reviews
  async getAllReviews(location?: string): Promise<IReview[]> {
    return await prisma.review.findMany({
      where: location ? { location } : undefined,
      orderBy: [{ createdAt: "desc" }],
      select: {
        id: true,
        userId: true, //id
        location: true,
        aqi: true,
        createdAt: true,
        rating: true,
        dislike: true,
        detail: true,
        user: {
          select: {
            fname: true,
          },
        },
      },
    });
  }
  //create review
  async createReview(data: IReview): Promise<IReview> {
    return await prisma.review.create({
      data: {
        userId: data.userId,
        location: data.location ?? "Unknown location",
        aqi: data.aqi,
        detail: data.detail,
      },
    });
  }

  //find by id
  async findReviewById(id: number): Promise<IReview | null> {
    return await prisma.review.findUnique({
      where: { id: id },
      select: {
        id: true,
        userId: true,
        location: true,
        aqi: true,
        createdAt: true,
        rating: true,
        dislike: true,
        detail: true,
      },
    });
  }
  //save like for user
  async saveLikeuser(data: reviewLike): Promise<reviewLike> {
    try {
      const response = await prisma.reviewLike.create({
        data: {
          userId: data.userId!,
          reviewId: data.reviewId,
        },
      });
      return response;
    } catch (error) {
      throw new ApiError(
        httpStatus.INTERNAL_SERVER_ERROR,
        "Failed to like the post."
      );
    }
  }
  //delete like for user
  async deleteLikeuser(data: reviewLike): Promise<reviewLike> {
    try {
      const response = await prisma.reviewLike.delete({
        where: {
          userId_reviewId: {
            userId: data.userId!,
            reviewId: data.reviewId,
          },
        },
      });
      return response;
    } catch (error) {
      throw new ApiError(
        httpStatus.INTERNAL_SERVER_ERROR,
        "Failed to like the post."
      );
    }
  }

  //get like for user
  async getLikeuser(id: string): Promise<reviewLike[]> {
    try {
      const response = await prisma.reviewLike.findMany({
        where: { userId: id },
        select: {
          userId: true,
          reviewId: true,
        },
      });

      return response;
    } catch (error) {
      throw new ApiError(
        httpStatus.INTERNAL_SERVER_ERROR,
        "Failed to get data"
      );
    }
  }
  //update like and dislike
  async updateLikeReview(data: reviewLike): Promise<IReview | null> {
    const currentReview = await this.findReviewById(data.reviewId as number);
    if (!currentReview) return null;

    const newRating = Math.max(0, currentReview.rating! + (data.rating || 0));
    // const newDislike = Math.max(0, currentReview.dislike! + (data.dislike || 0));

    return await prisma.review.update({
      where: { id: data.reviewId },
      data: {
        rating: newRating,
        // dislike: newDislike,
      },
    });
  }
}

export const reviewModel = new Reviewmodel();
