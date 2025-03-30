import { PrismaClient } from "@prisma/client";
import type { IUser } from "../types/userType";

const prisma = new PrismaClient();

class Usermodel {
  //get all user
  async getAllUser(): Promise<IUser[]> {
    return await prisma.user.findMany({
      select: {
        id: true,
        email: true,
        name: true,
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
        name: true,
        points: true,
        email: true,
        password:true
      },
    });
  }

  //delete user by id
  async deleteUserByID(id: number) {
    return await prisma.user.delete({
      where: { id: id },
    });
  }

  //update userdata
  async updateUser(user: IUser) {
    return await prisma.user.update({
      where: { id: user.id },
      data: {
        email: user.email,
        name: user.name,
        password: user.password,
        points: user.points,
      },
    });
  }

  //register
  async createUser(user: IUser): Promise<IUser> {
    return await prisma.user.create({
      data: { name: user.name!, email: user.email, password: user.password! },
    });
  }
}

export const userModel = new Usermodel();
