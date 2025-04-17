import express from 'express';
import { rewardController } from '../controllers/rewardController';
import { verifyUser } from '../middlewares/verifyUser';

const router = express.Router();

// Admin routes
router.post('/create', rewardController.createNewReward);
router.put('/:id',  rewardController.updateReward);
router.get('/:id', rewardController.getRewardById);
router.get('/', rewardController.getAllRewards);

// Reward value management
router.post('/value',  rewardController.createRewardValue);
router.post('/values/bulk', rewardController.bulkCreateRewardValues);

// User routes
router.get('/user/redemptions',  rewardController.getUserRedemptions);
router.post('/user/redeem',  rewardController.redeemReward);


export default router;