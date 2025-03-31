export interface tokenOutput {
  accessToken: string;
  refreshToken: string;
}

export interface userWithToken {
  token: { accessToken: string; refreshToken: string };
  user: { id: string; name: string; email: string; points: number };
}

export interface userUpdateRefreshToken {
  id: string;
  refreshToken: string | null;
}
