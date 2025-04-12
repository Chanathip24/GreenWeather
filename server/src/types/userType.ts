export interface IUser {
  id: string;
  email: string;
  password: string;
  name: string;
  points: number;
}
export interface InsertUser {
  email: string;
  name: string;
  password: string;
}

export interface LoginInput {
  email: string;
  password: string;
}

export interface RegisterInput {
  email: string;
  password: string;
  name: string;
}

export interface UserResponse {
  id: string;
  email: string;
  name: string;
  points: number;
}
