import { COLLECTIONS } from '../utils/constants.js';
import { success } from '../utils/responseHandler.js';
import { getDoc, now, setDoc } from '../services/firebaseService.js';

export async function getCart(req, res) {
  return success(res, { cart: (await getDoc(COLLECTIONS.CART, req.params.userId)) || { userId: req.params.userId, items: [] } });
}
export async function addToCart(req, res) {
  const { userId, productId, quantity = 1, selectedColor, selectedSize, price } = req.body;
  const cart = (await getDoc(COLLECTIONS.CART, userId)) || { userId, items: [] };
  const existing = cart.items.find((item) => item.productId === productId && item.selectedColor === selectedColor && item.selectedSize === selectedSize);
  if (existing) existing.quantity += Number(quantity);
  else cart.items.push({ productId, quantity: Number(quantity), selectedColor, selectedSize, price, addedAt: now() });
  return success(res, { cart: await setDoc(COLLECTIONS.CART, userId, cart) }, 'Added to cart');
}
export async function updateCart(req, res) {
  const { userId, productId, quantity } = req.body;
  const cart = (await getDoc(COLLECTIONS.CART, userId)) || { userId, items: [] };
  cart.items = cart.items.map((item) => (item.productId === productId ? { ...item, quantity: Number(quantity) } : item));
  return success(res, { cart: await setDoc(COLLECTIONS.CART, userId, cart) }, 'Cart updated');
}
export async function removeFromCart(req, res) {
  const userId = req.user.uid;
  const cart = (await getDoc(COLLECTIONS.CART, userId)) || { userId, items: [] };
  cart.items = cart.items.filter((item) => item.productId !== req.params.productId);
  return success(res, { cart: await setDoc(COLLECTIONS.CART, userId, cart) }, 'Removed from cart');
}
export async function clearCart(req, res) {
  return success(res, { cart: await setDoc(COLLECTIONS.CART, req.params.userId, { userId: req.params.userId, items: [] }) }, 'Cart cleared');
}
