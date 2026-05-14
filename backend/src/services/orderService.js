import { getFirebase } from '../config/firebase.js';
import { COLLECTIONS, ORDER_STATUS, PAYMENT_STATUS } from '../utils/constants.js';
import { now } from './firebaseService.js';

export function calculateTotals(items = [], coupon = null) {
  const totalAmount = items.reduce((sum, item) => sum + Number(item.price || 0) * Number(item.quantity || 1), 0);
  const discountAmount = coupon?.discountAmount || 0;
  const deliveryCharge = totalAmount >= 1999 ? 0 : 99;
  const finalAmount = Math.max(totalAmount - discountAmount + deliveryCharge, 0);
  return { totalAmount, discountAmount, deliveryCharge, finalAmount };
}

export async function createOrder({ userId, products, shippingAddress, paymentMethod = 'razorpay', coupon }) {
  const { db } = getFirebase();
  const ref = db.collection(COLLECTIONS.ORDERS).doc();
  const totals = calculateTotals(products, coupon);
  const order = {
    orderId: ref.id,
    userId,
    products,
    ...totals,
    paymentStatus: PAYMENT_STATUS.CREATED,
    paymentMethod,
    orderStatus: ORDER_STATUS.PENDING,
    shippingAddress,
    trackingStatus: 'Order created',
    createdAt: now(),
    updatedAt: now(),
  };
  await ref.set(order);
  return order;
}

export async function updateOrderPayment({ orderId, razorpayOrderId, razorpayPaymentId, status }) {
  const { db } = getFirebase();
  const update = {
    razorpayOrderId,
    razorpayPaymentId,
    paymentStatus: status,
    orderStatus: status === PAYMENT_STATUS.PAID ? ORDER_STATUS.CONFIRMED : ORDER_STATUS.PENDING,
    trackingStatus: status === PAYMENT_STATUS.PAID ? 'Payment confirmed' : 'Payment pending',
    updatedAt: now(),
  };
  await db.collection(COLLECTIONS.ORDERS).doc(orderId).set(update, { merge: true });
  return update;
}
