import express from "express";
import { login, register } from "../controllers/authController";
import type { Request, Response } from "express";
//validator
import { registerValidator } from "../middlewares/validator";
import jwt from "jsonwebtoken";
// initialize router
const router = express.Router();

router.post("/login", login);
router.post("/register", registerValidator, register);


export default router;
