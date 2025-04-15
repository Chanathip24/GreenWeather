export interface IUser {
  id: string;
  email: string;
  password: string;
  fname: string;
  lname:string
  points: number;
}
export interface InsertUser {
  email: string;
  fname: string;
  lname : string;
  password: string;
}

export interface LoginInput {
  email: string;
  password: string;
}

export interface RegisterInput {
  email: string;
  password: string;
  fname: string;
  lname :string;
}

export interface UserResponse {
  id: string;
  email: string;
  fname: string;
  lname : string;
  points: number;
}
export interface Userinputid{
  userId: string;
}
type PointType = "ADD" | "SUBTRACT"
//user with add or subtract points
export interface UserWithPoints {
  id: string;
  type : PointType;
  points: number;
}


