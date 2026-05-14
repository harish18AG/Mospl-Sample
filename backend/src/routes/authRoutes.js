import { Router } from 'express';
import { body } from 'express-validator';
import { authenticate } from '../middleware/authMiddleware.js';
import { validate } from '../middleware/validationMiddleware.js';
import { asyncHandler } from '../utils/responseHandler.js';
import * as c from '../controllers/authController.js';

const router = Router();
router.post('/register', [body('name').notEmpty(), body('email').isEmail(), body('password').isLength({ min: 6 })], validate, asyncHandler(c.register));
router.post('/login', [body('email').isEmail(), body('password').isLength({ min: 6 })], validate, asyncHandler(c.login));
router.post('/google-login', [body('idToken').notEmpty()], validate, asyncHandler(c.googleLogin));
router.post('/otp-login', [body('phone').notEmpty()], validate, asyncHandler(c.otpLogin));
router.post('/verify-otp', [body('phone').notEmpty(), body('otp').isLength({ min: 6, max: 6 })], validate, asyncHandler(c.verifyOtp));
router.post('/forgot-password', [body('email').isEmail()], validate, asyncHandler(c.forgotPassword));
router.post('/reset-password', asyncHandler(c.resetPassword));
router.get('/profile', authenticate, asyncHandler(c.profile));
router.put('/profile', authenticate, asyncHandler(c.updateProfile));
router.post('/logout', authenticate, asyncHandler(c.logout));
export default router;
