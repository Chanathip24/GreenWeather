import type { NextFunction, Request, Response } from "express";
import {
  createReward,
  getAllRedemptionsByUserId,
  getAllReward,
  redeemReward,
  updateReward,
  getRewardById,
  createRewardValue,
  bulkCreateRewardValues,
} from "../services/rewardService";
import { httpStatus } from "../utils/Error";
import type { IReward } from "../types/rewardType";
import type { IRedemption } from "../types/redemptionType";

class RewardController {
  // Create a new reward
  async createNewReward(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const { name, description, cost, type, imgUrl } = req.body;

      const data: IReward = await createReward({
        name,
        description,
        cost,
        type,
        imgUrl,
      });

      res.status(httpStatus.CREATED).json({
        status: "success",
        message: "Reward created successfully",
        data,
      });
    } catch (error) {
      next(error);
    }
  }

  // Update an existing reward
  async updateReward(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const { id } = req.params;
      const updateData = req.body;

      const data = await updateReward({
        id: Number(id),
        ...updateData,
      });

      res.status(httpStatus.OK).json({
        status: "success",
        message: "Reward updated successfully",
        data,
      });
    } catch (error) {
      next(error);
    }
  }

  // Get reward by ID
  async getRewardById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const { id } = req.params;
      const reward = await getRewardById(Number(id));

      res.status(httpStatus.OK).json({
        status: "success",
        message: "Reward retrieved successfully",
        data: reward,
      });
    } catch (error) {
      next(error);
    }
  }

  // Get all rewards
  async getAllRewards(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const rewards = await getAllReward();

      res.status(httpStatus.OK).json({
        status: "success",
        message: "Rewards retrieved successfully",
        data: rewards,
      });
    } catch (error) {
      next(error);
    }
  }

  // Create a reward value
  async createRewardValue(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const { rewardId, value, isUsed = false } = req.body;

      const rewardValue = await createRewardValue({
        rewardId,
        value,
        isUsed,
      });

      res.status(httpStatus.CREATED).json({
        status: "success",
        message: "Reward value created successfully",
        data: rewardValue,
      });
    } catch (error) {
      next(error);
    }
  }

  // Bulk create reward values
  async bulkCreateRewardValues(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const { rewardId, values, isUsed = false } = req.body;

      const rewardValues = await bulkCreateRewardValues(
        rewardId,
        values,
        isUsed
      );

      res.status(httpStatus.CREATED).json({
        status: "success",
        message: "Reward values created successfully",
        data: rewardValues,
      });
    } catch (error) {
      next(error);
    }
  }

  // Get user's redemptions
  async getUserRedemptions(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      // Get user ID from authenticated session
      const userId = req.user?.id || "09555765-bce0-4fe8-85dd-2bb6a07d3bbe";

      if (!userId) {
        res.status(httpStatus.FAILED).json({
          status: "failed",
          message: "User ID is required",
        });
        return;
      }

      const redemptions = await getAllRedemptionsByUserId(userId);

      res.status(httpStatus.OK).json({
        status: "success",
        message: "User redemptions retrieved successfully",
        data: redemptions,
      });
    } catch (error) {
      next(error);
    }
  }

  // Redeem a reward
  async redeemReward(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      // Get user ID from authenticated session
      const userId = req.user?.id || req.body.userId;

      if (!userId) {
        res.status(httpStatus.FAILED).json({
          status: "failed",
          message: "User ID is required",
        });
        return;
      }

      const { rewardId } = req.body;

      const result = await redeemReward({
        userId,
        rewardId,
      });

      res.status(httpStatus.OK).json({
        status: "success",
        message: "Reward redeemed successfully",
        data: result,
      });
    } catch (error) {
      next(error);
    }
  }
}

export const rewardController = new RewardController();
