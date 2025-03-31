import express from "express";
import { login, register } from "../controllers/authController";

//validator
import { registerValidator} from "../middlewares/validator";

// initialize router
const router = express.Router();

router.post("/login",login);
router.post("/register", registerValidator, register);

export default router;
