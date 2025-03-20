import express from "express";
import dotenv from "dotenv";
import type { Request, Response } from "express";
import { Router } from "express";
import cors from "cors";

//Initialize env
dotenv.config();

const PORT = process.env.PORT || 3000;

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use(
  cors({ credentials: true, allowedHeaders: ["Content-Type", "Authorization"] })
);

const router = Router();

app.use(router);

router.get("/", (req: Request, res: Response) => {
  res.json({ word: "Hi this is green weather" });
});

app.listen(PORT, (err) => {
  console.log(`Server is running on port ${PORT}`);
});
