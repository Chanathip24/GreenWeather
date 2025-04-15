import { userModel } from "../model/UserModel";
import type { IUser, UserResponse } from "../types/userType";
import { ApiError, httpStatus } from "../utils/Error";
import { mapUserResponse } from "./authService";

export const getAllUsers = async (includeEmail: boolean = true) => {
  //no email
  const users = await userModel.getAllUser(includeEmail);

  if (!users) {
    throw new ApiError(httpStatus.NOT_FOUND, "No users found");
  }
  return users;
};

export const getUserbyId = async (id: string) => {
  const user = await userModel.getUserById(id);
  if (!user) {
    throw new ApiError(httpStatus.NOT_FOUND, "User not found");
  }
  return user;
};

export const updateUser = async (
  user: Partial<IUser>
): Promise<UserResponse> => {
  if (!user.id) throw new ApiError(httpStatus.FAILED, "User id is required");

  const { id, password, ...rest } = user;

  const updateUser = await userModel.updateUser({
    id: id,
    ...rest,
  });

  if (!updateUser) {
    throw new ApiError(httpStatus.NOT_FOUND, "User not found");
  }
  let result: UserResponse = mapUserResponse(updateUser);
  return result;
};
