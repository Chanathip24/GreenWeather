import { PrismaClient } from "@prisma/client";
import type {
  InsertUser,
  IUser,
  UserResponse,
  UserWithPoints,
} from "../types/userType";
import type { tokenInput, userUpdateRefreshToken } from "../types/tokenType";
import { ApiError, httpStatus } from "../utils/Error";

const prisma = new PrismaClient();

class Usermodel {
  //get all user
  async getAllUser(includeEmail: boolean = true): Promise<UserResponse[]> {
    return await prisma.user.findMany({
      orderBy: [{ points: "desc" }, { fname: "asc" }],
      select: {
        id: true,
        ...(includeEmail && { email: true }),
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
  async deleteUserByID(id: string): Promise<IUser> {
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
  async updateUser(user: Partial<IUser>): Promise<IUser> {
    if (!user.id) throw new ApiError(httpStatus.FAILED, "User id is required");
    const { id, ...rest } = user;
    return await prisma.user.update({
      where: { id: id },
      data: {
        ...rest,
      },
    });
  }

  //register
  async createUser(user: InsertUser): Promise<IUser> {
    return await prisma.user.create({
      data: {
        fname: user.fname,
        lname: user.lname,
        email: user.email,
        password: user.password,
      },
    });
  }

  //get user by refreshtoken
  async getUserByRefreshToken(data: tokenInput): Promise<UserResponse | null> {
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
  //get user by id
  async getUserById(id: string): Promise<UserResponse | null> {
    return await prisma.user.findUnique({
      where: { id: id },
      select: {
        id: true,
        fname: true,
        lname: true,
        points: true,
        email: true,
      },
    });
  }

  async addPoints(data: UserWithPoints): Promise<IUser> {
    const current = await this.getUserById(data.id);
    if (!current) throw new ApiError(httpStatus.NOT_FOUND, "User not found");

    let point: number = current.points;
    
    //point
    if (!data.type)
      throw new ApiError(httpStatus.FAILED, "Type of points is required");
    if (data.type === "ADD") {
      point += data.points;
    } else if (data.type === "SUBTRACT") {
      if (current.points < data.points) {
        throw new ApiError(httpStatus.FAILED, "Not enough points to subtract");
      }
      //subtract points
      point -= data.points;
    } else {
      throw new ApiError(httpStatus.FAILED, "Invalid type of points");
    }

    return await this.updateUser({id : data.id, points: point});
  }
  //get user by id
}

export const userModel = new Usermodel();
