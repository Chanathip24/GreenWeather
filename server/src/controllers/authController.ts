import type { IUser } from "./../types/userType";
import type { Request, Response } from "express";
import { userModel } from "../model/UserModel";
import bcrypt from "bcrypt";
import dotenv from "dotenv";
import { validationResult } from "express-validator";
import { generateToken } from "../services/generateToken";

dotenv.config();

//bcrypt round
const SALT_ROUND: number = Number(process.env.SALT_ROUND) || 10;

const JWT_KEY: string = process.env.JWT_KEY || "TESTKEY";

//user register
export const register = async (req: Request, res: Response): Promise<void> => {
  //validation the password and something else
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    res.status(400).json({ errors: errors.array() });
    return;
  }
  //get user data from body
  const { email, name, password } = req.body;

  try {
    //check existing user
    const existingUser: IUser | null = await userModel.getUserbyEmail(email);

    if (existingUser) {
      res.status(400).json({ msg: "User is already exist!" });
      return;
    }

    // Hash the password
    const hashedpassword: string = await bcrypt.hash(password, SALT_ROUND);
    //user object
    let user: IUser = { email: email, name: name, password: hashedpassword };

    //insert to table
    const newUser: IUser = await userModel.createUser(user);

    //remove password
    const { password: _, ...userWithnopassword } = newUser;

    //jwt sign
    //prepare for refresh token
    const { refreshToken, accessToken } = generateToken(newUser);
    res.status(201).json({
      msg: "User created successfully",
      user: userWithnopassword,
      token: accessToken,
    });
    return;
  } catch (error) {
    console.error("Error details:", error);
    res.status(500).json({ msg: "Failed to create user.", error: error });
    return;
  }
};

//user login
export const login = async (req: Request, res: Response): Promise<void> => {

  //data
  const { email, password } = req.body;
  try {
    //find user
    const existUser: IUser | null = await userModel.getUserbyEmail(email);

    //no user found
    if (!existUser) {
      res.status(404).json({ msg: "No user found." });
      return;
    }

    //compare password
    const compareResult = await bcrypt.compare(password, existUser.password!);

    //remove password field
    const { password: _, ...user } = existUser;

    //if wrong password
    if (!compareResult) {
      res.status(401).json({ msg: "Invalid password" });
      return;
    }

    //jwt sign
    //prepare for refresh token
    const { refreshToken, accessToken } = generateToken(user);
    res.json({ msg: "Login successfully", user, accessToken });
  } catch (error) {
    console.log(error);
    res.status(500).json({ msg: "Something error on server.", error });
  }
};
