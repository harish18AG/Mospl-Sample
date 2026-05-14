import { COLLECTIONS, PAYMENT_STATUS } from '../utils/constants.js';
import { fail, success } from '../utils/responseHandler.js';
import { createRefund, createRazorpayOrder, verifyRazorpaySignature } from '../services/razorpayService.js';
import { getDoc, listDocs, now, setDoc, addDoc } from '../services/firebaseService.js';
import { updateOrderPayment } from '../services/orderService.js';

export async function createPaymentOrder(req, res) {
  const { orderId } = req.body;
  const order = await getDoc(COLLECTIONS.ORDERS, orderId);
  if (!order) throw fail('Order not found', 404);
  const razorpayOrder = await createRazorpayOrder({ amount: order.finalAmount, receipt: orderId, notes: { orderId, userId: order.userId } });
  await setDoc(COLLECTIONS.ORDERS, orderId, { razorpayOrderId: razorpayOrder.id, paymentStatus: PAYMENT_STATUS.CREATED });
  return success(res, { razorpayOrderId: razorpayOrder.id, amount: razorpayOrder.amount, currency: razorpayOrder.currency, keyId: process.env.RAZORPAY_KEY_ID || 'rzp_test_dummyKeyId' }, 'Razorpay order created');
}

export async function verifyPayment(req, res) {
  const { orderId, razorpayOrderId, razorpayPaymentId, razorpaySignature, method = 'razorpay' } = req.body;
  if (!verifyRazorpaySignature({ razorpayOrderId, razorpayPaymentId, razorpaySignature })) throw fail('Invalid Razorpay payment signature', 400);
  const order = await getDoc(COLLECTIONS.ORDERS, orderId);
  if (!order) throw fail('Order not found', 404);
  const payment = await setDoc(COLLECTIONS.PAYMENTS, razorpayPaymentId, { paymentId: razorpayPaymentId, userId: order.userId, orderId, razorpayOrderId, razorpayPaymentId, razorpaySignature, amount: order.finalAmount, currency: 'INR', status: PAYMENT_STATUS.PAID, method, createdAt: now() }, false);
  await updateOrderPayment({ orderId, razorpayOrderId, razorpayPaymentId, status: PAYMENT_STATUS.PAID });
  return success(res, { payment }, 'Payment verified and order confirmed');
}

export async function failedPayment(req, res) {
  const payment = await addDoc(COLLECTIONS.PAYMENTS, { ...req.body, status: PAYMENT_STATUS.FAILED, createdAt: now() });
  if (req.body.orderId) await setDoc(COLLECTIONS.ORDERS, req.body.orderId, { paymentStatus: PAYMENT_STATUS.FAILED });
  return success(res, { payment }, 'Payment failure recorded');
}

export async function paymentHistory(req, res) {
  return success(res, { payments: await listDocs(COLLECTIONS.PAYMENTS, { where: [['userId', '==', req.params.userId]], limit: 100 }) });
}

export async function refundPayment(req, res) {
  const refund = await createRefund(req.body.razorpayPaymentId, req.body.amount, { orderId: req.body.orderId, reason: req.body.reason });
  const record = await addDoc(COLLECTIONS.REFUNDS, { ...req.body, refundId: refund.id, status: refund.status || PAYMENT_STATUS.REFUNDED, createdAt: now() });
  return success(res, { refund: record }, 'Refund requested');
}

export async function invoice(req, res) {
  const order = await getDoc(COLLECTIONS.ORDERS, req.params.orderId);
  if (!order) throw fail('Order not found', 404);
  return success(res, { invoice: { invoiceNumber: `MOSPL-${order.orderId}`, company: 'onlinemadras.com', gstNote: 'Tax invoice generated for test mode', order } });
}
