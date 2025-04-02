import jwt from "jsonwebtoken";
import type { IUser } from "../types/userType";
import dotenv from 'dotenv'
//init
dotenv.config()

const JWT_KEY = process.env.JWT_KEY || "JWT_KEY"
export const generateToken = (user: IUser):{refreshToken:string,accessToken:string} => {

    const refreshToken = jwt.sign(user,JWT_KEY,{expiresIn:"7d"}) 
    const accessToken = jwt.sign(user,JWT_KEY,{expiresIn:"1m"})
    return {refreshToken,accessToken}
};
