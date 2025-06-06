import { userModel } from "./../model/UserModel";
import { generateToken } from "./generateToken";
import bcrypt from "bcrypt";

import type {
  InsertUser,
  IUser,
  LoginInput,
  RegisterInput,
  UserResponse,
} from "../types/userType";
import type {
  tokenInput,
  tokenOutput,
  userWithToken,
} from "../types/tokenType";
import { ApiError, httpStatus } from "../utils/Error";

//map user
export const mapUserResponse = (data: IUser): UserResponse => {
  return {
    id: data.id,
    role : data.role,
    email: data.email,
    fname: data.fname,
    lname: data.lname,
    points: data.points,
  };
};

//register service
export const registerService = async (
  data: RegisterInput
): Promise<userWithToken> => {
  //check existing user
  const existingUser: IUser | null = await userModel.getUserbyEmail(data.email);

  if (existingUser) {
    throw new ApiError(httpStatus.CONFLICT, "Email is already taken");
  }

  //hash password
  const salt = await bcrypt.genSalt(10);
  const hashedpassword = await bcrypt.hash(data.password, salt);

  //insert to table
  const newUser: InsertUser = {
    fname: data.fname,
    lname: data.lname,
    email: data.email,
    password: hashedpassword,
  };
  const user: IUser = await userModel.createUser(newUser);

  //generate token
  const { accessToken, refreshToken } = generateToken(mapUserResponse(user));
  //add refresh token to db
  const response = await userModel.updateUserRefreshToken({
    id: user.id,
    refreshToken: refreshToken,
  });
  return { token: { accessToken, refreshToken }, user: mapUserResponse(user) };
};

//login service
export const loginService = async (
  data: LoginInput
): Promise<userWithToken> => {
  const user: IUser | null = await userModel.getUserbyEmail(data.email);
  if (!user) {
    throw new ApiError(httpStatus.CONFLICT, "Invalid email or password");
  }

  //compare password
  const isPasswordMatch: boolean = await bcrypt.compare(
    data.password,
    user.password
  );

  if (!isPasswordMatch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Invalid email or password");
  }

  //login successfully
  //map user
  const User: UserResponse = mapUserResponse(user);
  const { accessToken, refreshToken }: tokenOutput = generateToken(User);

  //add refresh token to db
  const response = await userModel.updateUserRefreshToken({
    id: User.id,
    refreshToken: refreshToken,
  });
  return { token: { accessToken, refreshToken }, user: User };
};

export const refreshTokenService = async (data: tokenInput): Promise<tokenOutput> => {
  const user: UserResponse | null = await userModel.getUserByRefreshToken(data);

  if (!user) {
    throw new ApiError(httpStatus.UNAUTHORIZED, "Unauthorized");
  }

  //generate new token
  const { accessToken, refreshToken } = generateToken(user);

  //update refresh token in db
  await userModel.updateUserRefreshToken({
    id: user.id,
    refreshToken: refreshToken,
  });
  return { accessToken, refreshToken };
};

export const logoutService = async ( id : string): Promise<IUser> => {
  //remove refresh token from db
  const response: IUser = await userModel.updateUserRefreshToken({
    id: id,
    refreshToken: null,
  });
  return response;
}
