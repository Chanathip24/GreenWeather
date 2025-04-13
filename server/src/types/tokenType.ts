export interface tokenOutput {
  accessToken: string;
  refreshToken: string;
}

export interface userWithToken {
  token: { accessToken: string; refreshToken: string };
  user: {
    id: string;
    fname: string;
    lname: string;
    email: string;
    points: number;
  };
}

export interface userUpdateRefreshToken {
  id: string;
  refreshToken: string | null;
}

export interface newAccessToken {
  accessToken: string;
}

export interface tokenInput {
  accessToken? : string;
  refreshToken: string;
}