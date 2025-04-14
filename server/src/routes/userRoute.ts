import express from "express";
import { userController } from "../controllers/userController";


const router = express.Router();

//end point
router.get("/getusernoemail", userController.getAllUsersnoEmail)
router.put("/update", userController.updateUser)

export default router;