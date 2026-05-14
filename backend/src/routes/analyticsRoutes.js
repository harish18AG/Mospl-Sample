import { Router } from 'express';
import { authenticate } from '../middleware/authMiddleware.js';
import { requireAdmin } from '../middleware/adminMiddleware.js';
import { asyncHandler } from '../utils/responseHandler.js';
import * as c from '../controllers/analyticsController.js';
const router = Router();
router.get('/overview', authenticate, requireAdmin, asyncHandler(c.overview));
export default router;
