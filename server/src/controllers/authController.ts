import type { NextFunction, Request, Response } from "express";
import dotenv from "dotenv";
import { validationResult } from "express-validator";
import { loginService, registerService } from "../services/authService";
import { httpStatus } from "../utils/Error";
import type { userWithToken } from "../types/tokenType";

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
    res
      .status(400)
      .json({
        status: httpStatus.FAILED,
        message: "failed",
        errors: errors.array(),
      });
    return;
  }
  //get user data from body
  const { email, name, password } = req.body;

  try {
    const data: userWithToken = await registerService({
      email,
      name,
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
    res
      .status(httpStatus.OK)
      .json({
        status: "success",
        data: { token, user },
        message: "Login Successful",
      });
  } catch (error) {
    console.log(error)
    next(error);
  }
};
