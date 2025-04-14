import { PrismaClient } from "@prisma/client";
import { ApiError, httpStatus } from "../utils/Error";
import type { IReview } from "../types/reviewType";

const prisma = new PrismaClient();

class Reviewmodel {
  //get all reviews
  async getAllReviews(location?: string): Promise<IReview[]> {
    return await prisma.review.findMany({
      where: location ? { location } : undefined,
      orderBy: [{ createdAt: "desc" }],
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

  //update like and dislike
  async updateLikeReview(data: IReview): Promise<IReview> {
    const current = await this.findReviewById(data.id as number);
    if (!current) throw new ApiError(httpStatus.NOT_FOUND, "Review not found");

    const newRating = Math.max(0, current.rating! + (data.rating || 0));
    const newDislike = Math.max(0, current.dislike! + (data.dislike || 0));

    return await prisma.review.update({
      where: { id: data.id },
      data: {
        rating: newRating,
        dislike: newDislike,
      },
    });
  }
}

export const reviewModel = new Reviewmodel();
