import crypto from 'node:crypto';
import { razorpay } from '../config/razorpay.js';
import { env } from '../config/env.js';
import { CURRENCY } from '../utils/constants.js';

export async function createRazorpayOrder({ amount, receipt, notes = {} }) {
  return razorpay.orders.create({
    amount: Math.round(Number(amount) * 100),
    currency: CURRENCY,
    receipt,
    notes: { app: 'MOSPL', company: 'onlinemadras.com', ...notes },
  });
}

export function verifyRazorpaySignature({ razorpayOrderId, razorpayPaymentId, razorpaySignature }) {
  const body = `${razorpayOrderId}|${razorpayPaymentId}`;
  const expected = crypto.createHmac('sha256', env.razorpay.keySecret).update(body).digest('hex');
  return crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(razorpaySignature));
}

export async function createRefund(paymentId, amount, notes = {}) {
  return razorpay.payments.refund(paymentId, {
    amount: amount ? Math.round(Number(amount) * 100) : undefined,
    notes: { app: 'MOSPL', ...notes },
  });
}
