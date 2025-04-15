import express from 'express';
import { transactionController } from '../controllers/transactionController';
import { verifyUser } from '../middlewares/verifyUser';

const router = express.Router();

router.get('/gettransaction',verifyUser, transactionController.getTransactionbyid)

export default router;