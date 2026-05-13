// backend/src/routes/review.routes.js
const express = require('express');
const router = express.Router();
const admin = require('../config/firebase.config');
const { verifyToken, verifyAdmin } = require('../middleware/auth.middleware');

// GET /reviews/:productId
router.get('/:productId', async (req, res) => {
  try {
    const snapshot = await admin.firestore()
      .collection('reviews')
      .where('productId', '==', req.params.productId)
      .where('isApproved', '==', true)
      .orderBy('createdAt', 'desc')
      .get();
    const reviews = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json({ success: true, data: reviews });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// POST /reviews
router.post('/', verifyToken, async (req, res) => {
  try {
    const { productId, rating, title, comment, images } = req.body;
    if (!productId || !rating) {
      return res.status(400).json({ success: false, message: 'productId and rating are required' });
    }
    const userDoc = await admin.firestore().collection('users').doc(req.user.uid).get();
    const review = {
      productId,
      userId: req.user.uid,
      userName: userDoc.data()?.name || 'Anonymous',
      userImage: userDoc.data()?.profileImage || null,
      rating,
      title: title || '',
      comment: comment || '',
      images: images || [],
      isVerifiedPurchase: false,
      isApproved: true,
      helpfulCount: 0,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    const ref = await admin.firestore().collection('reviews').add(review);
    // Update product rating
    const prodSnap = await admin.firestore().collection('products').doc(productId).get();
    if (prodSnap.exists) {
      const { rating: oldRating = 0, reviewCount = 0 } = prodSnap.data();
      const newRating = ((oldRating * reviewCount) + rating) / (reviewCount + 1);
      await admin.firestore().collection('products').doc(productId).update({
        rating: Math.round(newRating * 10) / 10,
        reviewCount: reviewCount + 1,
      });
    }
    res.status(201).json({ success: true, data: { id: ref.id, ...review } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /reviews/:id/helpful
router.put('/:id/helpful', verifyToken, async (req, res) => {
  try {
    await admin.firestore().collection('reviews').doc(req.params.id).update({
      helpfulCount: admin.firestore.FieldValue.increment(1),
    });
    res.json({ success: true, message: 'Marked as helpful' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// DELETE /reviews/:id (Admin or owner)
router.delete('/:id', verifyToken, async (req, res) => {
  try {
    const doc = await admin.firestore().collection('reviews').doc(req.params.id).get();
    if (!doc.exists) return res.status(404).json({ success: false, message: 'Review not found' });
    const userDoc = await admin.firestore().collection('users').doc(req.user.uid).get();
    const isAdmin = userDoc.data()?.role === 'admin';
    if (!isAdmin && doc.data().userId !== req.user.uid) {
      return res.status(403).json({ success: false, message: 'Not authorized' });
    }
    await admin.firestore().collection('reviews').doc(req.params.id).delete();
    res.json({ success: true, message: 'Review deleted' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = router;

// ==================== backend/src/routes/cart.routes.js ====================
const cartRouter = express.Router();

// GET /cart
cartRouter.get('/', verifyToken, async (req, res) => {
  try {
    const doc = await admin.firestore().collection('cart').doc(req.user.uid).get();
    const items = doc.exists ? doc.data().items || [] : [];
    res.json({ success: true, data: { items } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /cart — Save entire cart
cartRouter.put('/', verifyToken, async (req, res) => {
  try {
    const { items } = req.body;
    await admin.firestore().collection('cart').doc(req.user.uid).set({
      items: items || [],
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.json({ success: true, message: 'Cart updated' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// DELETE /cart — Clear cart
cartRouter.delete('/', verifyToken, async (req, res) => {
  try {
    await admin.firestore().collection('cart').doc(req.user.uid).set({
      items: [],
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.json({ success: true, message: 'Cart cleared' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = cartRouter;

// ==================== backend/src/routes/wishlist.routes.js ====================
const wishlistRouter = express.Router();

// GET /wishlist
wishlistRouter.get('/', verifyToken, async (req, res) => {
  try {
    const doc = await admin.firestore().collection('wishlist').doc(req.user.uid).get();
    const productIds = doc.exists ? doc.data().productIds || [] : [];
    res.json({ success: true, data: { productIds } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// POST /wishlist/toggle
wishlistRouter.post('/toggle', verifyToken, async (req, res) => {
  try {
    const { productId } = req.body;
    const doc = await admin.firestore().collection('wishlist').doc(req.user.uid).get();
    let productIds = doc.exists ? doc.data().productIds || [] : [];
    let added;
    if (productIds.includes(productId)) {
      productIds = productIds.filter(id => id !== productId);
      added = false;
    } else {
      productIds.push(productId);
      added = true;
    }
    await admin.firestore().collection('wishlist').doc(req.user.uid).set({
      productIds,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.json({ success: true, data: { productIds, added } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = wishlistRouter;

// ==================== backend/src/routes/category.routes.js ====================
const categoryRouter = express.Router();

// GET /categories
categoryRouter.get('/', async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('categories')
      .where('isActive', '==', true)
      .orderBy('sortOrder')
      .get();
    const categories = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json({ success: true, data: categories });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// POST /categories (Admin)
categoryRouter.post('/', verifyAdmin, async (req, res) => {
  try {
    const ref = await admin.firestore().collection('categories').add({
      ...req.body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.status(201).json({ success: true, data: { id: ref.id } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /categories/:id (Admin)
categoryRouter.put('/:id', verifyAdmin, async (req, res) => {
  try {
    await admin.firestore().collection('categories').doc(req.params.id).update(req.body);
    res.json({ success: true, message: 'Category updated' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// DELETE /categories/:id (Admin)
categoryRouter.delete('/:id', verifyAdmin, async (req, res) => {
  try {
    await admin.firestore().collection('categories').doc(req.params.id).delete();
    res.json({ success: true, message: 'Category deleted' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = categoryRouter;

// ==================== backend/src/routes/coupon.routes.js ====================
const couponRouter = express.Router();

// GET /coupons — All active coupons
couponRouter.get('/', verifyToken, async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('coupons')
      .where('isActive', '==', true)
      .get();
    const now = new Date();
    const coupons = snapshot.docs
      .map(d => ({ id: d.id, ...d.data() }))
      .filter(c => c.expiryDate.toDate() > now && c.usedCount < c.usageLimit);
    res.json({ success: true, data: coupons });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// POST /coupons/validate
couponRouter.post('/validate', verifyToken, async (req, res) => {
  try {
    const { code, orderTotal } = req.body;
    const snapshot = await admin.firestore().collection('coupons')
      .where('code', '==', code.toUpperCase())
      .limit(1)
      .get();
    if (snapshot.empty) {
      return res.status(404).json({ success: false, message: 'Invalid coupon code' });
    }
    const coupon = { id: snapshot.docs[0].id, ...snapshot.docs[0].data() };
    if (!coupon.isActive) return res.status(400).json({ success: false, message: 'This coupon is no longer active' });
    if (coupon.expiryDate.toDate() < new Date()) return res.status(400).json({ success: false, message: 'Coupon has expired' });
    if (coupon.usedCount >= coupon.usageLimit) return res.status(400).json({ success: false, message: 'Coupon usage limit reached' });
    if (orderTotal < coupon.minOrderValue) {
      return res.status(400).json({ success: false, message: `Add ₹${coupon.minOrderValue - orderTotal} more to use this coupon` });
    }
    let discount = coupon.discountType === 'percentage'
      ? (orderTotal * coupon.discountValue / 100)
      : coupon.discountValue;
    if (discount > coupon.maxDiscount) discount = coupon.maxDiscount;
    res.json({ success: true, data: { coupon, discount } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// POST /coupons (Admin)
couponRouter.post('/', verifyAdmin, async (req, res) => {
  try {
    const ref = await admin.firestore().collection('coupons').add({
      ...req.body,
      usedCount: 0,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.status(201).json({ success: true, data: { id: ref.id } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = couponRouter;

// ==================== backend/src/routes/analytics.routes.js ====================
const analyticsRouter = express.Router();

// GET /analytics/dashboard (Admin)
analyticsRouter.get('/dashboard', verifyAdmin, async (req, res) => {
  try {
    const [ordersSnap, usersSnap, productsSnap] = await Promise.all([
      admin.firestore().collection('orders').get(),
      admin.firestore().collection('users').get(),
      admin.firestore().collection('products').get(),
    ]);

    const orders = ordersSnap.docs.map(d => d.data());
    const totalRevenue = orders.reduce((sum, o) => sum + (o.total || 0), 0);
    const totalOrders = orders.length;
    const totalUsers = usersSnap.size;
    const totalProducts = productsSnap.size;

    // Monthly revenue (last 6 months)
    const monthlyRevenue = {};
    orders.forEach(o => {
      if (o.createdAt) {
        const date = o.createdAt.toDate();
        const key = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
        monthlyRevenue[key] = (monthlyRevenue[key] || 0) + (o.total || 0);
      }
    });

    // Status breakdown
    const statusBreakdown = {};
    orders.forEach(o => {
      statusBreakdown[o.orderStatus] = (statusBreakdown[o.orderStatus] || 0) + 1;
    });

    // Category revenue
    const categoryRevenue = {};
    orders.forEach(o => {
      (o.items || []).forEach(item => {
        categoryRevenue[item.categoryId || 'unknown'] =
          (categoryRevenue[item.categoryId || 'unknown'] || 0) + item.price * item.quantity;
      });
    });

    res.json({
      success: true,
      data: {
        kpis: { totalRevenue, totalOrders, totalUsers, totalProducts },
        monthlyRevenue,
        statusBreakdown,
        categoryRevenue,
        avgOrderValue: totalOrders > 0 ? totalRevenue / totalOrders : 0,
      },
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// GET /analytics/top-products (Admin)
analyticsRouter.get('/top-products', verifyAdmin, async (req, res) => {
  try {
    const { limit = 10 } = req.query;
    const snapshot = await admin.firestore().collection('products')
      .orderBy('reviewCount', 'desc')
      .limit(Number(limit))
      .get();
    const products = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json({ success: true, data: products });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = analyticsRouter;

// ==================== backend/src/routes/notification.routes.js ====================
const notifRouter = express.Router();

// GET /notifications
notifRouter.get('/', verifyToken, async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('notifications')
      .where('userId', '==', req.user.uid)
      .orderBy('createdAt', 'desc')
      .limit(50)
      .get();
    const notifications = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json({ success: true, data: notifications });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /notifications/:id/read
notifRouter.put('/:id/read', verifyToken, async (req, res) => {
  try {
    await admin.firestore().collection('notifications').doc(req.params.id).update({ isRead: true });
    res.json({ success: true, message: 'Marked as read' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /notifications/read-all
notifRouter.put('/read-all', verifyToken, async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('notifications')
      .where('userId', '==', req.user.uid)
      .where('isRead', '==', false)
      .get();
    const batch = admin.firestore().batch();
    snapshot.docs.forEach(doc => batch.update(doc.ref, { isRead: true }));
    await batch.commit();
    res.json({ success: true, message: 'All marked as read' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// POST /notifications/send (Admin)
notifRouter.post('/send', verifyAdmin, async (req, res) => {
  try {
    const { userId, title, body, type, actionUrl } = req.body;
    const notification = {
      userId,
      title,
      body,
      type: type || 'system',
      actionUrl: actionUrl || null,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    const ref = await admin.firestore().collection('notifications').add(notification);
    res.status(201).json({ success: true, data: { id: ref.id } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = notifRouter;

// ==================== backend/src/routes/admin.routes.js ====================
const adminRouter = express.Router();

// GET /admin/stats — Quick stats for dashboard
adminRouter.get('/stats', verifyAdmin, async (req, res) => {
  try {
    const [orders, users, products] = await Promise.all([
      admin.firestore().collection('orders').get(),
      admin.firestore().collection('users').get(),
      admin.firestore().collection('products').get(),
    ]);
    const revenue = orders.docs.reduce((s, d) => s + (d.data().total || 0), 0);
    res.json({
      success: true,
      data: {
        totalOrders: orders.size,
        totalUsers: users.size,
        totalProducts: products.size,
        totalRevenue: revenue,
        pendingOrders: orders.docs.filter(d => d.data().orderStatus === 'placed').length,
        todayOrders: orders.docs.filter(d => {
          const t = d.data().createdAt?.toDate();
          if (!t) return false;
          const today = new Date();
          return t.toDateString() === today.toDateString();
        }).length,
      },
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /admin/orders/:id/status (Admin)
adminRouter.put('/orders/:id/status', verifyAdmin, async (req, res) => {
  try {
    const { status, message } = req.body;
    await admin.firestore().collection('orders').doc(req.params.id).update({
      orderStatus: status,
      statusHistory: admin.firestore.FieldValue.arrayUnion({
        status,
        message: message || `Order ${status}`,
        timestamp: new Date(),
      }),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.json({ success: true, message: `Order status updated to ${status}` });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// GET /admin/orders — All orders with pagination
adminRouter.get('/orders', verifyAdmin, async (req, res) => {
  try {
    const { status, page = 1, limit = 20 } = req.query;
    let query = admin.firestore().collection('orders').orderBy('createdAt', 'desc');
    if (status) query = query.where('orderStatus', '==', status);
    const snapshot = await query.get();
    const allOrders = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    const start = (Number(page) - 1) * Number(limit);
    const paginated = allOrders.slice(start, start + Number(limit));
    res.json({
      success: true,
      data: paginated,
      total: allOrders.length,
      page: Number(page),
      pages: Math.ceil(allOrders.length / Number(limit)),
    });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// GET /admin/users — All users
adminRouter.get('/users', verifyAdmin, async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('users')
      .orderBy('createdAt', 'desc')
      .get();
    const users = snapshot.docs.map(d => {
      const data = d.data();
      // Remove sensitive fields
      delete data.addresses;
      return { id: d.id, ...data };
    });
    res.json({ success: true, data: users });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /admin/users/:id/status (Admin)
adminRouter.put('/users/:id/status', verifyAdmin, async (req, res) => {
  try {
    const { isActive } = req.body;
    await admin.firestore().collection('users').doc(req.params.id).update({ isActive });
    res.json({ success: true, message: `User ${isActive ? 'activated' : 'deactivated'}` });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// GET /admin/inventory — Low stock products
adminRouter.get('/inventory', verifyAdmin, async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('products')
      .where('stockCount', '<=', 10)
      .get();
    const products = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json({ success: true, data: products, count: products.length });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /admin/inventory/:productId — Update stock
adminRouter.put('/inventory/:productId', verifyAdmin, async (req, res) => {
  try {
    const { stockCount } = req.body;
    await admin.firestore().collection('products').doc(req.params.productId).update({
      stockCount,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.json({ success: true, message: 'Stock updated' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = adminRouter;

// ==================== backend/src/routes/banner.routes.js ====================
const bannerRouter = express.Router();

// GET /banners — Active banners
bannerRouter.get('/', async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('banners')
      .where('isActive', '==', true)
      .orderBy('sortOrder')
      .get();
    const banners = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json({ success: true, data: banners });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// POST /banners (Admin)
bannerRouter.post('/', verifyAdmin, async (req, res) => {
  try {
    const ref = await admin.firestore().collection('banners').add({
      ...req.body,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    res.status(201).json({ success: true, data: { id: ref.id } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// PUT /banners/:id (Admin)
bannerRouter.put('/:id', verifyAdmin, async (req, res) => {
  try {
    await admin.firestore().collection('banners').doc(req.params.id).update(req.body);
    res.json({ success: true, message: 'Banner updated' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// DELETE /banners/:id (Admin)
bannerRouter.delete('/:id', verifyAdmin, async (req, res) => {
  try {
    await admin.firestore().collection('banners').doc(req.params.id).delete();
    res.json({ success: true, message: 'Banner deleted' });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = bannerRouter;

// ==================== backend/src/routes/support.routes.js ====================
const supportRouter = express.Router();

// POST /support/ticket
supportRouter.post('/ticket', verifyToken, async (req, res) => {
  try {
    const { subject, message, category, orderId } = req.body;
    const userDoc = await admin.firestore().collection('users').doc(req.user.uid).get();
    const ticket = {
      userId: req.user.uid,
      userName: userDoc.data()?.name || 'User',
      orderId: orderId || null,
      subject,
      category: category || 'General',
      message,
      status: 'open',
      priority: 'medium',
      messages: [{
        senderId: req.user.uid,
        message,
        isAdmin: false,
        timestamp: new Date(),
      }],
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    const ref = await admin.firestore().collection('support').add(ticket);
    res.status(201).json({ success: true, data: { id: ref.id, ticketNumber: `TKT${Date.now()}` } });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

// GET /support/tickets — User's tickets
supportRouter.get('/tickets', verifyToken, async (req, res) => {
  try {
    const snapshot = await admin.firestore().collection('support')
      .where('userId', '==', req.user.uid)
      .orderBy('createdAt', 'desc')
      .get();
    const tickets = snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
    res.json({ success: true, data: tickets });
  } catch (e) {
    res.status(500).json({ success: false, message: e.message });
  }
});

module.exports = supportRouter;

// ==================== Exports note ====================
// In backend/src/server.js, add these additional route registrations:
//
// app.use('/api/v1/reviews', require('./routes/review.routes'));
// app.use('/api/v1/cart', require('./routes/cart.routes'));
// app.use('/api/v1/wishlist', require('./routes/wishlist.routes'));
// app.use('/api/v1/categories', require('./routes/category.routes'));
// app.use('/api/v1/coupons', require('./routes/coupon.routes'));
// app.use('/api/v1/analytics', require('./routes/analytics.routes'));
// app.use('/api/v1/notifications', require('./routes/notification.routes'));
// app.use('/api/v1/admin', require('./routes/admin.routes'));
// app.use('/api/v1/banners', require('./routes/banner.routes'));
// app.use('/api/v1/support', require('./routes/support.routes'));