import { rewardModel } from "../model/Rewardmodel";
import { userModel } from "../model/UserModel";
import type { IRedemption } from "../types/redemptionType";
import type { IReward, IRewardValue } from "../types/rewardType";
import type { UserResponse } from "../types/userType";
import { ApiError, httpStatus } from "../utils/Error";
import { createTransaction } from "./transactionService";

export const createReward = async (data: IReward): Promise<IReward> => {
  try {
    const response: IReward = await rewardModel.createReward(data);
    return response;
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to create reward."
    );
  }
};

export const updateReward = async (
  data: Partial<IReward>
): Promise<IReward> => {
  if (!data.id) {
    throw new ApiError(httpStatus.FAILED, "Please provide reward id");
  }

  try {
    const response: IReward = await rewardModel.updateReward(data);
    return response;
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to update reward"
    );
  }
};

export const getRewardById = async (id: number): Promise<IReward> => {
  const reward = await rewardModel.getRewardbyId(id);

  if (!reward) {
    throw new ApiError(httpStatus.NOT_FOUND, `Reward with id ${id} not found`);
  }

  return reward;
};

export const getAllReward = async (): Promise<IReward[]> => {
  const data: IReward[] = await rewardModel.getAllreward();

  if (data.length === 0) {
    throw new ApiError(httpStatus.NOT_FOUND, "Not found any reward.");
  }

  return data;
};

export const getAllRedemptionsByUserId = async (
  userId: string
): Promise<IRedemption[]> => {
  const result = await rewardModel.getAllredemption(userId);

  if (result.length === 0) {
    throw new ApiError(
      httpStatus.NOT_FOUND,
      `No redemptions found for userID: ${userId}`
    );
  }
  return result;
};

export const createRewardValue = async (
  data: IRewardValue
): Promise<IRewardValue> => {
  try {
    return await rewardModel.createRewardValue(data);
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to create reward value"
    );
  }
};

export const bulkCreateRewardValues = async (
  rewardId: number,
  values: string[],
  isUsed: boolean = false
): Promise<IRewardValue[]> => {
  try {
    const createdValues: IRewardValue[] = [];

    for (const value of values) {
      const rewardValue = await rewardModel.createRewardValue({
        rewardId,
        value,
        isUsed,
      });

      createdValues.push(rewardValue);
    }

    return createdValues;
  } catch (error) {
    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to bulk create reward values"
    );
  }
};

export const redeemReward = async (
  data: Partial<IRedemption>
): Promise<IRedemption> => {
  try {
    if (!data.userId || !data.rewardId) {
      throw new ApiError(
        httpStatus.FAILED,
        "User ID and Reward ID are required"
      );
    }

    // Fetch the reward
    const reward: IReward | null = await rewardModel.getRewardbyId(
      data.rewardId
    );

    if (!reward) {
      throw new ApiError(httpStatus.NOT_FOUND, "Reward not found");
    }

    // // Check if any rewards are left
    // if (reward.total <= 0) {
    //   throw new ApiError(httpStatus.FAILED, "No rewards left to redeem");
    // }

    // Get user to check points
    const user = await userModel.getUserById(data.userId);

    if (!user) {
      throw new ApiError(httpStatus.NOT_FOUND, "User not found");
    }

    if (user.points < reward.cost) {
      throw new ApiError(
        httpStatus.FAILED,
        `Insufficient points. Required: ${reward.cost}, Available: ${user.points}`
      );
    }

    // Get an available reward value
    const rewardValue = await rewardModel.getAvailableRewardValue(
      data.rewardId
    );

    if (!rewardValue && reward.type !== "VIRTUAL") {
      throw new ApiError(
        httpStatus.FAILED,
        "No available reward values for this reward"
      );
    }

    // // Update reward total count
    // await rewardModel.updateReward({
    //   id: data.rewardId,
    //   total: reward.total - 1,
    // });

    // Subtract points from user
    await userModel.addPoints({
      type: "SUBTRACT",
      id: data.userId,
      points: reward.cost,
    });

    // Create transaction record
    await createTransaction({
      userId: data.userId,
      points: reward.cost,
      type: "SUBTRACT",
      reason: `Redeem ${reward.name} cost ${reward.cost} points`,
    });

    // If we have a reward value, mark it as used
    if (rewardValue) {
      await rewardModel.markRewardValueAsUsed(rewardValue.id!);
    }

    // Create redemption record
    const redemption: IRedemption = await rewardModel.createRedemption({
      userId: data.userId,
      rewardId: data.rewardId,
      rewardValueId: rewardValue?.id || 0,
    });

    return redemption;
  } catch (error) {
    if (error instanceof ApiError) {
      throw error;
    }

    throw new ApiError(
      httpStatus.INTERNAL_SERVER_ERROR,
      "Failed to redeem reward"
    );
  }
};
