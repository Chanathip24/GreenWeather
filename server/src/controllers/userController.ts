import type { IUser } from "./../types/userType";
import type { Request, Response } from "express";
import { userModel } from "../model/UserModel";
import bcrypt from "bcrypt";
import dotenv from "dotenv";
import jwt from "jsonwebtoken";

dotenv.config();

const SALT_ROUND = process.env.SALT_ROUND || 10;

//user register
export const register = async (req: Request, res: Response) => {
  //get user data from body
  const { email, name, password } = req.body;
  let user: IUser = { email: email, name: name };
  try {
    //check existing user
    const existingUser = await userModel.getUserbyEmail(user.email);
    if (existingUser) {
      return res.status(400).json({ msg: "User is already exist!" });
    }
    //hash password
    user.password = await bcrypt.hash(password, SALT_ROUND);
    //insert to table
    const newUser: IUser = await userModel.createUser(user);

    //jwt sign
    // const refreshToken = jwt.sign(user, "testkey", { expiresIn: "3m" });
    const accessToken = jwt.sign(user, "testkey", { expiresIn: "1d" });

    return res
      .status(201)
      .json({
        msg: "User created successfully",
        user: newUser,
        token: accessToken,
      });
  } catch (error) {
    res.status(500).json({ msg: "Failed to create user.", error: error });
  }
};

//user login
export const login = async (req: Request, res: Response) => {
  const { email, password } = req.body;
  const user: IUser = { email: email, password: password };

  try {
    const existingUser: IUser | null = await userModel.getUserbyEmail(email);
    if (!existingUser) {
      return res.status(404).json({ msg: "No user found." });
    }

    //compare password if user is exist
    const resultPassword = await bcrypt.compare(
      password,
      existingUser.password!
    );
    if (!resultPassword) {
      return res.status(401).json({ msg: "Password is invalid" });
    }

    //jwt sign
  } catch (error) {}
};
