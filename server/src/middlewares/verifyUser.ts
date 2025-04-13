import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();
const JWT_KEY = process.env.JWT_KEY || "JWT_KEY";

declare global {
  namespace Express {
    interface Request {
      user?: any;
    }
  }
}

export const verifyUser = (req: Request, res: Response, next: NextFunction) => {
  const Bearertoken = req.headers["authorization"];

  if (!Bearertoken) {
    res.status(401).json({ msg: "No token provided" });
    return;
  }

  const token: string = Bearertoken.split(" ")[1];
  if (!token) {
    res.status(401).json({ msg: "Invalid token format" });
    return;
  }

  try {
    const decoded = jwt.verify(token, JWT_KEY);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(500).json(error);
    return;
  }
};

//protected route
export const protectedRoute = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (!req.user) {
    return res.status(401).json({ msg: "User not authenticated" });
  }
  next();
};
