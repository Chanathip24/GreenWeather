import express from "express";
import { reviewController } from "../controllers/reviewController";
const router = express.Router();

router.get("/getallreviews", reviewController.getAllReviews);
router.get("/getallreviewslocate", reviewController.getReviewByLocation);
router.post("/createreview", reviewController.createReview);

export default router;