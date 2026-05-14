import { COLLECTIONS } from '../utils/constants.js';
import { listDocs } from './firebaseService.js';

export async function buildDashboard() {
  const [users, orders, products] = await Promise.all([
    listDocs(COLLECTIONS.USERS, { limit: 1000 }),
    listDocs(COLLECTIONS.ORDERS, { limit: 1000 }),
    listDocs(COLLECTIONS.PRODUCTS, { limit: 1000 }),
  ]);
  const totalRevenue = orders.reduce((sum, order) => sum + Number(order.finalAmount || 0), 0);
  const pendingOrders = orders.filter((o) => o.orderStatus === 'pending').length;
  const deliveredOrders = orders.filter((o) => o.orderStatus === 'delivered').length;
  const cancelledOrders = orders.filter((o) => o.orderStatus === 'cancelled').length;
  const lowStockProducts = products.filter((p) => Number(p.stock ?? p.stockCount ?? 0) <= 10);
  const monthlySales = Array.from({ length: 12 }, (_, index) => ({ month: index + 1, sales: 0, revenue: 0 }));
  for (const order of orders) {
    const month = new Date(order.createdAt || Date.now()).getMonth();
    monthlySales[month].sales += 1;
    monthlySales[month].revenue += Number(order.finalAmount || 0);
  }
  const categorySalesMap = {};
  for (const order of orders) {
    for (const item of order.products || []) {
      const key = item.categoryName || item.category || 'Uncategorized';
      categorySalesMap[key] = (categorySalesMap[key] || 0) + Number(item.quantity || 1);
    }
  }
  return {
    totalSales: orders.length,
    totalRevenue,
    totalOrders: orders.length,
    totalUsers: users.length,
    totalProducts: products.length,
    pendingOrders,
    deliveredOrders,
    cancelledOrders,
    lowStockProducts,
    monthlySales,
    categorySales: Object.entries(categorySalesMap).map(([category, units]) => ({ category, units })),
    topSellingProducts: products.slice(0, 10),
    recentOrders: orders.slice(0, 10),
    customerActivity: users.slice(0, 10).map((u) => ({ userId: u.uid || u.id, lastLogin: u.lastLogin, rewardPoints: u.rewardPoints || 0 })),
  };
}
