export interface IReward {
  id?: number;
  name: string;
  description: string | null;
  cost: number;
  type: string;
  imgUrl?: string | null;
  values?: IRewardValue[]; 
}

export interface IRewardValue {
  id?: number;
  rewardId: number;
  value: string;
  isUsed: boolean;
  createdAt?: Date;
}
