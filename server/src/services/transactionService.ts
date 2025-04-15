import { transactionModel } from "../model/TransactionModel";
import type { Itranscation } from "../types/transcationType";
import type { Userinputid } from "../types/userType";
import { ApiError, httpStatus } from "../utils/Error";

export const getTransaction = async (data: Userinputid) => {
  const response: Itranscation[] =
    await transactionModel.getTransactionbyuserid(data);
  if (response.length === 0) {
    throw new ApiError(httpStatus.NOT_FOUND, "No transaction found");
  }
  return response;
};

export const createTransaction = async (data: Itranscation) => {
  const response = await transactionModel.createTransaction(data);
  if (!response) {
    throw new ApiError(httpStatus.NOT_FOUND, "Transaction not found");
  }
  return response;
}
