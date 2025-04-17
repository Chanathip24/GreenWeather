import { PrismaClient } from "@prisma/client";
import type { Userinputid } from "../types/userType";
import type { Itranscation } from "../types/transcationType";
const prisma = new PrismaClient();

class Transcationmodel {
  async getTransactionbyuserid(data: Userinputid): Promise<Itranscation[]> {
    return await prisma.pointTransaction.findMany({
      where: { userId: data.userId },
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        id: true,
        userId: true,
        points: true,
        type: true,
        createdAt: true,
        reason: true,
      },
    });
  }

  //create transaction
  async createTransaction(data: Itranscation): Promise<any> {
    return await prisma.pointTransaction.create({
      data: {
        userId: data.userId,
        points: data.points,
        type: data.type,
        reason: data.reason,
      },
    });
  }
}
export const transactionModel = new Transcationmodel();
