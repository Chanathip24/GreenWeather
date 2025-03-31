import { type tokenOutput } from "./../types/tokenType";
import jwt from "jsonwebtoken";
import type { IUser, UserResponse } from "../types/userType";
import dotenv from "dotenv";

//init
dotenv.config();

const JWT_KEY = process.env.JWT_KEY || "JWT_KEY";

export const generateToken = (user: UserResponse): tokenOutput => {
  const refreshToken = jwt.sign(user, JWT_KEY, { expiresIn: "60d" });
  const accessToken = jwt.sign(user, JWT_KEY, { expiresIn: "15m" });
  return { accessToken, refreshToken };
};
