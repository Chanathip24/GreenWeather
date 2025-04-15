export interface Itranscation{
    id?: number;
    userId: string;
    points: number;
    type: "ADD" | "SUBTRACT";
    reason: string;
    createdAt?: Date;
}