import express from "express";
import dotenv from "dotenv";

import cors from "cors";
//routes
import authenticationRoute from "./routes/authenticationRoute";
import weatherRoute from "./routes/weatherRoute";
import airpollutionRoute from "./routes/airpollutionRoute";
import userRoute from "./routes/userRoute";
import reviewsRoute from "./routes/reviewsRoute";

//error
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

app.use("/authentication", authenticationRoute);
app.use("/weather", weatherRoute);
app.use("/pm", airpollutionRoute);
app.use("/user", userRoute);
app.use("/review", reviewsRoute);

//error handler
app.use(errorHandler);

app.listen(PORT, (err?: Error) => {
  if (err) {
    console.error("❌ Error starting server:", err);
    return;
  }
  const asciiLogo = `
  _____ _             _   
 / ____| |           | |  
| (___ | |_ __ _ _ __| |_ 
 \\___ \\| __/ _\` | '__| __|
 ____) | || (_| | |  | |_ 
|_____/ \\__\\__,_|_|   \\__|

        GreenWeather 🌿
`;

  console.log(asciiLogo);
  console.log("\n" + "=".repeat(40));
  console.log(`✅ Server is running at : http://localhost:${PORT}`);
  console.log(`🕒 Started at : ${new Date().toLocaleString()}`);
  console.log("=".repeat(40) + "\n");
});
