import { PrismaClient } from "@prisma/client";
import type { InsertUser, IUser, UserResponse } from "../types/userType";
import type { tokenInput, userUpdateRefreshToken } from "../types/tokenType";

const prisma = new PrismaClient();

class Usermodel {
  //get all user
  async getAllUser(): Promise<UserResponse[]> {
    return await prisma.user.findMany({
      select: {
        id: true,
        email: true,
        fname: true,
        lname: true,
        points: true,
      },
    });
  }

  //getuserbyEmail
  async getUserbyEmail(email: string): Promise<IUser | null> {
    return await prisma.user.findUnique({
      where: { email: email },
      select: {
        id: true,
        fname: true,
        lname: true,
        points: true,
        email: true,
        password: true,
      },
    });
  }

  //delete user by id
  async deleteUserByID(id: string):Promise<IUser> {
    return await prisma.user.delete({
      where: { id: id },
    });
  }
  //update refreshToken
  async updateUserRefreshToken(data: userUpdateRefreshToken): Promise<IUser> {
    return await prisma.user.update({
      where: { id: data.id },
      data: { refreshToken: data.refreshToken },
    });
  }
  //update userdata
  async updateUser(user: IUser) {
    return await prisma.user.update({
      where: { id: user.id },
      data: {
        email: user.email,
        fname: user.fname,
        lname: user.lname,
        password: user.password,
        points: user.points,
      },
    });
  }

  //register
  async createUser(user: InsertUser): Promise<IUser> {
    return await prisma.user.create({
      data: { fname: user.fname,lname : user.lname, email: user.email, password: user.password },
    });
  }

  //get user by refreshtoken
  async getUserByRefreshToken( data : tokenInput): Promise<UserResponse | null> {
    return await prisma.user.findFirst({
      where: { refreshToken: data.refreshToken },
      select: {
        id: true,
        fname: true,
        lname: true,
        points: true,
        email: true,
      },
    });
  }

}


export const userModel = new Usermodel();
