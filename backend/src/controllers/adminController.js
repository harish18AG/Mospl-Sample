import { COLLECTIONS } from '../utils/constants.js';
import { success } from '../utils/responseHandler.js';
import { buildDashboard } from '../services/analyticsService.js';
import { getDoc, listDocs, setDoc } from '../services/firebaseService.js';
import { adminInsights } from '../services/aiService.js';

export async function dashboard(req, res) {
  const data = await buildDashboard();
  return success(res, { ...data, aiSalesPrediction: adminInsights({ dashboard: data }) });
}
export async function users(req, res) { return success(res, { users: await listDocs(COLLECTIONS.USERS, { limit: 500 }) }); }
export async function blockUser(req, res) { return success(res, { user: await setDoc(COLLECTIONS.USERS, req.params.userId, { isBlocked: req.body.isBlocked ?? true }) }, 'User status updated'); }
export async function orders(req, res) { return success(res, { orders: await listDocs(COLLECTIONS.ORDERS, { limit: 500 }) }); }
export async function orderStatus(req, res) { return success(res, { order: await setDoc(COLLECTIONS.ORDERS, req.params.orderId, { orderStatus: req.body.status, trackingStatus: req.body.trackingStatus || req.body.status }) }); }
export async function sales(req, res) { return success(res, { sales: (await buildDashboard()).monthlySales }); }
export async function revenue(req, res) { const d = await buildDashboard(); return success(res, { totalRevenue: d.totalRevenue, monthlySales: d.monthlySales }); }
export async function lowStock(req, res) { return success(res, { products: (await buildDashboard()).lowStockProducts }); }
export async function analytics(req, res) { return success(res, await buildDashboard()); }
export async function adminProfile(req, res) { return success(res, { admin: await getDoc(COLLECTIONS.ADMINS, req.user.uid) }); }
