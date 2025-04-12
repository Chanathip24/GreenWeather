import express from "express";
import { airPollution } from "../controllers/airpollutionController";

const router = express.Router();

//route
router.get("/", airPollution.getPollution);

// //iqair
// router.get("/iq", airPollution.iqair);

export default router;
