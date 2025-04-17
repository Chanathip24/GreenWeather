import { PrismaClient } from "@prisma/client";
import type { IReward } from "../types/rewardType";
import type { IRedemption } from "../types/redemptionType";
import type { IRewardValue } from "../types/rewardType"; // Add this type!

const prisma = new PrismaClient();

class Rewardmodel {
  // Get Reward by ID (with reward values)
  async getRewardbyId(id: number): Promise<IReward | null> {
    return await prisma.reward.findUnique({
      where: { id },
      select: {
        id: true,
        name: true,
        description: true,
        cost: true,
        type: true,
        imgUrl: true,
        values: {
          select: {
            id: true,
            value: true,
            isUsed: true,
            rewardId: true,
            createdAt: true,
          },
        },
      },
    });
  }

  // Get all rewards
  async getAllreward(): Promise<IReward[]> {
    return await prisma.reward.findMany({
      select: {
        id: true,
        name: true,
        description: true,
        cost: true,
        type: true,
        imgUrl: true,
        values: {
          select: {
            id: true,
            value: true,
            isUsed: true,
            rewardId: true,
            createdAt: true,
          },
        },
      },
    });
  }

  // Create reward แต่ยังไม่สร้างค่าข้างใน
  async createReward(data: IReward): Promise<IReward> {
    return await prisma.reward.create({
      data: {
        name: data.name,
        description: data.description ?? null,
        cost: data.cost,
        type: data.type,
        imgUrl: data.imgUrl ?? null,
      },
      include: {
        values: true,
      },
    });
  }

  // Update reward
  async updateReward(data: Partial<IReward>): Promise<IReward> {
    const { id, values, ...rest } = data;

    if (!id) {
      throw new Error("ID is required for update operation");
    }

    const updatedReward = await prisma.reward.update({
      where: { id },
      data: { ...rest },
      include: { values: true },
    });

    return {
      id: updatedReward.id,
      name: updatedReward.name,
      description: updatedReward.description,
      cost: updatedReward.cost,
      type: updatedReward.type,
      imgUrl: updatedReward.imgUrl,
      values: updatedReward.values.map((v) => ({
        id: v.id,
        rewardId: v.rewardId,
        value: v.value,
        isUsed: v.isUsed,
        createdAt: v.createdAt,
      })),
    };
  }

  // Create reward value ***admin
  async createRewardValue(data: IRewardValue): Promise<IRewardValue> {
    return await prisma.rewardValue.create({
      data,
    });
  }

  // Get one available value (not used) for specific reward
  async getAvailableRewardValue(
    rewardId: number
  ): Promise<IRewardValue | null> {
    return await prisma.rewardValue.findFirst({
      where: {
        rewardId,
        isUsed: false,
      },
    });
  }

  // Mark value as used
  async markRewardValueAsUsed(id: number): Promise<void> {
    await prisma.rewardValue.update({
      where: { id },
      data: { isUsed: true },
    });
  }

  // Create redemption สร้างผลลัพธ์ที่ user กดใช้แต้ม
  async createRedemption(data: IRedemption): Promise<IRedemption> {
    return await prisma.redemption.create({
      data: {
        userId: data.userId,
        rewardId: data.rewardId,
        rewardValueId: data.rewardValueId, // <-- link to value
      },
      include: {
        rewardValue: {
          select: {
            value: true,
          },
        },
      },
    });
  }

  // Get all redemptions ของ user แต่ละคน
  async getAllredemption(userId?: string): Promise<IRedemption[]> {
    return await prisma.redemption.findMany({
      where: userId ? { userId } : undefined,
      select: {
        id: true,
        userId: true,
        rewardId: true,
        rewardValueId: true,
        rewardValue: {
          select: {
            value: true,
          },
        },
        createdAt: true,
      },
    });
  }
}

export const rewardModel = new Rewardmodel();
