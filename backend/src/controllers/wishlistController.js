import { COLLECTIONS } from '../utils/constants.js';
import { success } from '../utils/responseHandler.js';
import { getDoc, now, setDoc } from '../services/firebaseService.js';

export async function getWishlist(req, res) {
  return success(res, { wishlist: (await getDoc(COLLECTIONS.WISHLIST, req.params.userId)) || { userId: req.params.userId, productIds: [] } });
}
export async function addWishlist(req, res) {
  const { userId, productId } = req.body;
  const wishlist = (await getDoc(COLLECTIONS.WISHLIST, userId)) || { userId, productIds: [], createdAt: now() };
  if (!wishlist.productIds.includes(productId)) wishlist.productIds.push(productId);
  return success(res, { wishlist: await setDoc(COLLECTIONS.WISHLIST, userId, wishlist) }, 'Added to wishlist');
}
export async function removeWishlist(req, res) {
  const userId = req.user.uid;
  const wishlist = (await getDoc(COLLECTIONS.WISHLIST, userId)) || { userId, productIds: [] };
  wishlist.productIds = wishlist.productIds.filter((id) => id !== req.params.productId);
  return success(res, { wishlist: await setDoc(COLLECTIONS.WISHLIST, userId, wishlist) }, 'Removed from wishlist');
}
