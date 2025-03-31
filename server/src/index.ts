import express from "express";
import dotenv from "dotenv";

import cors from "cors";
//routes
import authenticationRoute from './routes/authenticationRoute';
import weatherRoute from './routes/weatherRoute';
import { errorHandler } from "./middlewares/errorHandler";
//Initialize env
dotenv.config();

const PORT = process.env.PORT || 3000;

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use(
  cors({ credentials: true, allowedHeaders: ["Content-Type", "Authorization"] })
);

app.use("/authentication",authenticationRoute);
app.use("/weather",weatherRoute);


app.use(errorHandler);
app.listen(PORT, (err) => {
  console.log(`Server is running on port ${PORT}`);
});
