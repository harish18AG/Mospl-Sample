import { COLLECTIONS, ORDER_STATUS } from '../utils/constants.js';
import { fail, success } from '../utils/responseHandler.js';
import { createOrder as createOrderService } from '../services/orderService.js';
import { getDoc, listDocs, setDoc } from '../services/firebaseService.js';

export async function createOrder(req, res) {
  const order = await createOrderService({ userId: req.body.userId || req.user.uid, products: req.body.products, shippingAddress: req.body.shippingAddress, paymentMethod: req.body.paymentMethod, coupon: req.body.coupon });
  return success(res, { order }, 'Order created', 201);
}
export async function userOrders(req, res) {
  return success(res, { orders: await listDocs(COLLECTIONS.ORDERS, { where: [['userId', '==', req.params.userId]], limit: 100 }) });
}
export async function getOrder(req, res) {
  const order = await getDoc(COLLECTIONS.ORDERS, req.params.orderId);
  if (!order) throw fail('Order not found', 404);
  return success(res, { order });
}
export async function updateOrderStatus(req, res) {
  return success(res, { order: await setDoc(COLLECTIONS.ORDERS, req.params.orderId, { orderStatus: req.body.status, trackingStatus: req.body.trackingStatus || req.body.status }) }, 'Order status updated');
}
export async function orderTracking(req, res) {
  const order = await getDoc(COLLECTIONS.ORDERS, req.params.orderId);
  const tracking = await getDoc(COLLECTIONS.TRACKING, req.params.orderId);
  return success(res, { tracking: tracking || { orderId: req.params.orderId, status: order?.trackingStatus || 'Order created', timeline: [] } });
}
export async function cancelOrder(req, res) {
  return success(res, { order: await setDoc(COLLECTIONS.ORDERS, req.params.orderId, { orderStatus: ORDER_STATUS.CANCELLED, cancellationReason: req.body.reason }) }, 'Order cancelled');
}
