import { COLLECTIONS } from '../utils/constants.js';
import { success } from '../utils/responseHandler.js';
import { getDoc, listDocs, setDoc } from '../services/firebaseService.js';
import { adminInsights, chatbotReply, recommendProducts } from '../services/aiService.js';
import { buildDashboard } from '../services/analyticsService.js';

export async function recommendations(req, res) {
  const [products, wishlist, orders] = await Promise.all([
    listDocs(COLLECTIONS.PRODUCTS, { limit: 500 }),
    getDoc(COLLECTIONS.WISHLIST, req.params.userId),
    listDocs(COLLECTIONS.ORDERS, { where: [['userId', '==', req.params.userId]], limit: 50 }),
  ]);
  const recommended = recommendProducts(products, { wishlistIds: wishlist?.productIds || [], previousOrders: orders, ...req.query });
  await setDoc(COLLECTIONS.AI_RECOMMENDATIONS, req.params.userId, { userId: req.params.userId, productIds: recommended.map((p) => p.productId || p.id) });
  return success(res, { recommendations: recommended });
}
export async function chatbot(req, res) { return success(res, { reply: chatbotReply(req.body.message, req.body.context) }); }
export async function smartSearch(req, res) {
  const q = String(req.query.q || '').toLowerCase();
  const products = (await listDocs(COLLECTIONS.PRODUCTS, { limit: 500 })).filter((p) => JSON.stringify(p).toLowerCase().includes(q));
  return success(res, { query: q, suggestions: products.slice(0, 10), recommendedFilters: ['category', 'price', 'rating', 'color', 'size'] });
}
export async function adminSalesInsights(req, res) { return success(res, { insights: adminInsights({ dashboard: await buildDashboard() }) }); }
