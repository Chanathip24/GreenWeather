import { logoutService, refreshTokenService } from "./../services/authService";
import type { NextFunction, Request, Response } from "express";
import dotenv from "dotenv";
import { validationResult } from "express-validator";
import { loginService, registerService } from "../services/authService";
import { httpStatus } from "../utils/Error";
import type { userWithToken } from "../types/tokenType";
import type { UserResponse } from "../types/userType";

dotenv.config();

//user register
export const register = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  //validation the password and something else
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    res.status(400).json({
      status: httpStatus.FAILED,
      message: "failed",
      errors: errors.array(),
    });
    return;
  }
  //get user data from body
  const { email, fname, lname, password } = req.body;
  try {
    const data: userWithToken = await registerService({
      email,
      fname,
      lname,
      password,
    });
    res.status(httpStatus.CREATED).json({
      status: "success",
      data: data,
      message: "Register successfully",
    });
  } catch (error) {
    next(error);
  }
};

//user login
export const login = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  //data
  const { email, password } = req.body;
  try {
    const { user, token } = await loginService({ email, password });
    res.status(httpStatus.OK).json({
      status: "success",
      data: { token, user },
      message: "Login Successful",
    });
  } catch (error) {
    next(error);
  }
};

export const refreshTokenController = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    res.status(401).json({ message: "Unauthorized" });
    return;
  }
  try {
    const data = await refreshTokenService({ refreshToken: refreshToken });
    res.status(httpStatus.OK).json({
      status: "success",
      data: data,
      message: "Refresh Token Successful",
    });
  } catch (error) {
    next(error);
  }
};

export const logoutController = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  const { id } = req.user;

  if (!id) {
    res.status(httpStatus.UNAUTHORIZED).json({
      status: "failed",
      message: "Unauthorized",
    });
    return;
  }
  try {
    await logoutService(id);
    res.status(httpStatus.OK).json({
      status: "success",
      message: "Logout Successful",
    });
  } catch (error) {
    next(error);
  }
};

export const getUserController = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const user: UserResponse = req.user;
    if (!user) {
      res.status(httpStatus.UNAUTHORIZED).json({
        status: "failed",
        message: "Unauthorized",
      });
      return;
    }
    res.status(httpStatus.OK).json({
      status: "success",
      data: { user: user },
      message: "Get User Successfully",
    });
  } catch (error) {
    next(error);
  }
};
