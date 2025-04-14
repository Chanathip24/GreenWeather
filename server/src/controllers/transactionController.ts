import type { Request, Response, NextFunction } from "express";
import { getTransaction } from "../services/transactionService";

class TransactionController {
  async getTransactionbyid(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user.id;
      if (!userId) {
        res.status(400).json({
          status: "error",
          message: "User ID is required",
        });
        return;
      }
      const transactions = await getTransaction({ userId });
      res.status(200).json({
        status: "success",
        message: "Fetch data successfully",
        data: transactions,
      });
    } catch (error) {
      next(error);
    }
  }
}

export const transactionController = new TransactionController();
