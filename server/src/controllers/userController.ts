import type { IUser } from "../types/userType";
import { httpStatus } from "../utils/Error";
import { getAllUsers, updateUser } from "./../services/userService";
import type { Request, Response, NextFunction } from "express";

class Usercontroller {
  //get all user no email
  async getAllUsersnoEmail(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const users = await getAllUsers(false);
      res.status(200).json({
        status: "success",
        message: "Fetch data successfully",
        data: users,
      });
    } catch (error) {
      next(error);
    }
  }

  //get all user with email
  async getAllUsers(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const users = await getAllUsers();
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Fetch data successfully",
        data: users,
      });
    } catch (error) {
      next(error);
    }
  }

  //update user
  async updateUser(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const user: Partial<IUser> = req.body;
      const { id } = req.user;
      // const id = "09555765-bce0-4fe8-85dd-2bb6a07d3bbe"
      
      if (user.id != id) {
        
        res.status(httpStatus.FORBIDDEN).json({
          status: "failed",
          message: "Failed to update user",
        });
        return;
      }
      const updatedUser = await updateUser(user);
      
      res.status(httpStatus.OK).json({
        status: "success",
        message: "Update user successfully",
        data: updatedUser,
      });
    } catch (error) {
      
      next(error);
    }
  }
}

export const userController = new Usercontroller();
