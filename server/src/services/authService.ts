import { userModel } from "./../model/UserModel";
import { generateToken } from "./generateToken";
import bcrypt from "bcrypt";

import type {
  InsertUser,
  IUser,
  LoginInput,
  RegisterInput,
  UserResponse,
} from "../types/userType";
import type { tokenOutput, userWithToken } from "../types/tokenType";
import { ApiError, httpStatus } from "../utils/Error";

//map user
const mapUserResponse = (data: IUser): UserResponse => {
  return {
    id: data.id,
    email: data.email,
    name: data.name,
    points: data.points,
  };
};

//register service
export const registerService = async (
  data: RegisterInput
): Promise<userWithToken> => {
  //check existing user
  const existingUser: IUser | null = await userModel.getUserbyEmail(data.email);

  if (existingUser) {
    throw new ApiError(httpStatus.CONFLICT, "Email is already taken");
  }

  //hash password
  const salt = await bcrypt.genSalt(10);
  const hashedpassword = await bcrypt.hash(data.password, salt);

  //insert to table
  const newUser: InsertUser = {
    name: data.name,
    email: data.email,
    password: hashedpassword,
  };
  const user: IUser = await userModel.createUser(newUser);

  //generate token
  const { accessToken, refreshToken } = generateToken(mapUserResponse(user));
  //add refresh token to db
  const response = await userModel.updateUserRefreshToken({
    id: user.id,
    refreshToken: refreshToken,
  });
  return { token: { accessToken, refreshToken }, user: mapUserResponse(user) };
};
//login service
export const loginService = async (
  data: LoginInput
): Promise<userWithToken> => {
  const user: IUser | null = await userModel.getUserbyEmail(data.email);
  if (!user) {
    throw new ApiError(httpStatus.CONFLICT, "Invalid email or password");
  }

  //compare password
  const isPasswordMatch: boolean = await bcrypt.compare(
    data.password,
    user.password
  );

  if (!isPasswordMatch) {
    throw new ApiError(httpStatus.NOT_FOUND, "Invalid email or password");
  }

  //login successfully
  //map user
  const User: UserResponse = mapUserResponse(user);
  const { accessToken, refreshToken }: tokenOutput = generateToken(User);

  //add refresh token to db
  const response = await userModel.updateUserRefreshToken({
    id: User.id,
    refreshToken: refreshToken,
  });
  return { token: { accessToken, refreshToken }, user: User };
};


//refresh token service
// router.post("/refresh", async (req: Request, res: Response): Promise<void> => {
//   const { authorization } = req.headers;
//   const token: undefined | string = authorization?.split(" ")[1];
//   if (!token) {
//     res.status(401).json({ message: "Unauthorized" });
//     return;
//   }
//   let decoded: any;
//   try {
//     decoded = jwt.verify(token, process.env.JWT_KEY as string);
//   } catch (error) {
//     res.status(401).json({ message: "Unauthorized" });
//     return;
//   }

//   //return new access token
//   // Check if the token is expired
//   const currentTime = Math.floor(Date.now() / 1000); // Current time in seconds
//   if (decoded.exp && decoded.exp < currentTime) {
//     res.status(401).json({ message: "Token is expired" });
//   }

//   //new token
//   const accessToken = jwt.sign(
//     {
//       userId: decoded.id,
//       email: decoded.email,
//       name: decoded.name,
//       points: decoded.points,
//     },
//     process.env.JWT_KEY as string,
//     { expiresIn: "15m" }
//   );
//   //find user that contain token first
  
//   //return new token
//   res.status(200).json({
//     status: "success",
//     message: "Refresh token successfully",
//     data: { decoded, accessToken },
//   });
//   return;
// });