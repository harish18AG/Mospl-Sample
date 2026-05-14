import bcrypt from 'bcryptjs';
import { getFirebase } from '../config/firebase.js';
import { COLLECTIONS, ROLES } from '../utils/constants.js';
import { now } from '../services/firebaseService.js';

export async function seedAdmin() {
  const { db, auth } = getFirebase();
  const email = 'admin@onlinemadras.com';
  let user = await auth.getUserByEmail(email).catch(() => null);
  if (!user) {
    user = await auth.createUser({ email, password: 'Admin@123456', displayName: 'MOSPL Admin' });
  }
  await auth.setCustomUserClaims(user.uid, { role: ROLES.ADMIN });
  const admin = {
    uid: user.uid,
    name: 'MOSPL Admin',
    email,
    phone: '+919999999999',
    role: ROLES.ADMIN,
    permissions: ['products:write', 'orders:write', 'analytics:read', 'users:write', 'payments:read'],
    passwordHash: await bcrypt.hash('Admin@123456', 12),
    createdAt: now(),
    updatedAt: now(),
    lastLogin: null,
    isBlocked: false,
  };
  await db.collection(COLLECTIONS.ADMINS).doc(user.uid).set(admin, { merge: true });
  await db.collection(COLLECTIONS.USERS).doc(user.uid).set(admin, { merge: true });
  await db.collection(COLLECTIONS.ANALYTICS).doc('dashboard').set({ totalUsers: 0, totalOrders: 0, totalRevenue: 0, totalProducts: 120, monthlySales: [], categorySales: [], topSellingProducts: [], lowStockProducts: [], dailyVisitors: 0, updatedAt: now() }, { merge: true });
  console.log('Seeded MOSPL admin: admin@onlinemadras.com / Admin@123456');
}

if (import.meta.url === `file://${process.argv[1]}`) {
  seedAdmin().catch((error) => { console.error(error); process.exit(1); });
}
