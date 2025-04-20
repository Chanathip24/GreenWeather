export interface IReview{
    id?:  number;
    userId: string;
    location: string;
    aqi: number;
    rating?: number;
    dislike?: number;
    detail: string | null;
    createdAt?: Date;
    main? : string | null;
}

export interface reviewLike{
    userId? : string;
    reviewId : number;
    rating? : number;
}