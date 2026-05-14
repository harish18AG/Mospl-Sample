import dotenv from 'dotenv';

dotenv.config();

const required = ['JWT_SECRET', 'RAZORPAY_KEY_ID', 'RAZORPAY_KEY_SECRET'];
for (const key of required) {
  if (!process.env[key]) {
    console.warn(`[env] ${key} is not set. Use backend/.env for local development.`);
  }
}

export const env = {
  port: Number(process.env.PORT || 5000),
  nodeEnv: process.env.NODE_ENV || 'development',
  jwtSecret: process.env.JWT_SECRET || 'mospl_super_secure_jwt_secret',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '7d',
  firebase: {
    projectId: process.env.FIREBASE_PROJECT_ID,
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET || `${process.env.FIREBASE_PROJECT_ID || 'mospl'}.appspot.com`,
  },
  razorpay: {
    keyId: process.env.RAZORPAY_KEY_ID || 'rzp_test_dummyKeyId',
    keySecret: process.env.RAZORPAY_KEY_SECRET || 'rzp_test_dummyKeySecret',
  },
  corsOrigins: (process.env.CORS_ORIGINS || '*').split(',').map((origin) => origin.trim()),
};
