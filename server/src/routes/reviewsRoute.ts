import express from "express";
import { reviewController } from "../controllers/reviewController";
import { verifyUser } from "../middlewares/verifyUser";
const router = express.Router();

router.get("/getallreviews", reviewController.getAllReviews);
router.get("/getallreviewslocate", reviewController.getReviewByLocation);
router.post("/createreview", reviewController.createReview);
router.put("/addlikereview", reviewController.updateLikeReview);


//debug route
router.get("/like/all",verifyUser,reviewController.getUserlike)
router.post("/like/savelike",verifyUser,reviewController.saveUserlike)
router.delete("/like/deletelike",verifyUser,reviewController.deleteUserlike)

export default router;