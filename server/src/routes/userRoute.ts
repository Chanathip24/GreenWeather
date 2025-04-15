import express from "express";
import { userController } from "../controllers/userController";
import { verifyUser } from "../middlewares/verifyUser";


const router = express.Router();

//end point
router.get("/getusernoemail", userController.getAllUsersnoEmail)
router.put("/update",verifyUser, userController.updateUser)

export default router;