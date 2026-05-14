import { COLLECTIONS } from '../utils/constants.js';
import { success } from '../utils/responseHandler.js';
import { addDoc, listDocs, setDoc } from '../services/firebaseService.js';

export async function productReviews(req, res) {
  return success(res, { reviews: await listDocs(COLLECTIONS.REVIEWS, { where: [['productId', '==', req.params.productId]], limit: 100 }) });
}
export async function createReview(req, res) {
  const review = await addDoc(COLLECTIONS.REVIEWS, { ...req.body, userId: req.user.uid, userName: req.body.userName || req.user.email || 'MOSPL Customer', isApproved: false });
  return success(res, { review }, 'Review submitted for moderation', 201);
}
export async function moderateReview(req, res) {
  return success(res, { review: await setDoc(COLLECTIONS.REVIEWS, req.params.reviewId, { isApproved: req.body.isApproved }) }, 'Review moderated');
}
