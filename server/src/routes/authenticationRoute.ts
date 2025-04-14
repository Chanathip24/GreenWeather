import express from "express";
import { getUserController, login, logoutController, refreshTokenController, register } from "../controllers/authController";
import type { Request, Response } from "express";
//validator
import { registerValidator } from "../middlewares/validator";
import jwt from "jsonwebtoken";
import { verifyUser } from "../middlewares/verifyUser";
// initialize router
const router = express.Router();

router.post("/login", login);
router.post("/register", registerValidator, register);
router.post("/refresh", refreshTokenController)
router.get('/logout',verifyUser,logoutController)
router.get('/getuser',verifyUser,getUserController)


export default router;
