import bcrypt from 'bcryptjs';
import { getFirebase } from '../config/firebase.js';
import { COLLECTIONS, ROLES } from '../utils/constants.js';
import { fail, success } from '../utils/responseHandler.js';
import { generateToken } from '../utils/generateToken.js';
import { getDoc, now, setDoc } from '../services/firebaseService.js';

function publicUser(user) {
  const { passwordHash, ...safe } = user;
  return safe;
}

export async function register(req, res) {
  const { name, email, phone, password } = req.body;
  const { auth } = getFirebase();
  const userRecord = await auth.createUser({ email, phoneNumber: phone, password, displayName: name });
  const user = {
    uid: userRecord.uid,
    name,
    email,
    phone,
    profileImage: '',
    role: ROLES.CUSTOMER,
    addresses: [],
    createdAt: now(),
    updatedAt: now(),
    lastLogin: now(),
    isBlocked: false,
    rewardPoints: 0,
    loginProvider: 'password',
    passwordHash: await bcrypt.hash(password, 12),
  };
  await setDoc(COLLECTIONS.USERS, user.uid, user, false);
  const token = generateToken({ uid: user.uid, email, role: user.role });
  return success(res, { token, user: publicUser(user) }, 'Registered successfully', 201);
}

export async function login(req, res) {
  const { email, password } = req.body;
  const { auth } = getFirebase();
  const firebaseUser = await auth.getUserByEmail(email).catch(() => null);
  if (!firebaseUser) throw fail('Invalid credentials', 401);
  const user = await getDoc(COLLECTIONS.USERS, firebaseUser.uid);
  if (!user || user.isBlocked) throw fail('User is blocked or unavailable', 403);
  const matches = user.passwordHash ? await bcrypt.compare(password, user.passwordHash) : true;
  if (!matches) throw fail('Invalid credentials', 401);
  await setDoc(COLLECTIONS.USERS, firebaseUser.uid, { lastLogin: now(), loginProvider: 'password' });
  const token = generateToken({ uid: firebaseUser.uid, email, role: user.role || ROLES.CUSTOMER });
  return success(res, { token, user: publicUser({ ...user, lastLogin: now() }) }, 'Logged in successfully');
}

export async function googleLogin(req, res) {
  const { idToken } = req.body;
  const { auth } = getFirebase();
  const decoded = await auth.verifyIdToken(idToken);
  const user = {
    uid: decoded.uid,
    name: decoded.name || decoded.email?.split('@')[0] || 'MOSPL User',
    email: decoded.email,
    phone: decoded.phone_number || '',
    profileImage: decoded.picture || '',
    role: decoded.role || ROLES.CUSTOMER,
    addresses: [],
    lastLogin: now(),
    isBlocked: false,
    rewardPoints: 0,
    loginProvider: 'google',
  };
  await setDoc(COLLECTIONS.USERS, decoded.uid, { ...user, createdAt: now() });
  const token = generateToken({ uid: decoded.uid, email: decoded.email, role: user.role });
  return success(res, { token, user }, 'Google login successful');
}

export async function otpLogin(req, res) {
  return success(res, { verificationId: `mospl-test-${Date.now()}`, expiresInSeconds: 300 }, 'OTP sent in test mode');
}

export async function verifyOtp(req, res) {
  const { phone, otp } = req.body;
  if (otp !== '123456') throw fail('Invalid test OTP', 401);
  const uid = `phone-${phone.replace(/\D/g, '')}`;
  const user = { uid, name: 'MOSPL Customer', email: '', phone, role: ROLES.CUSTOMER, loginProvider: 'otp', lastLogin: now(), isBlocked: false, rewardPoints: 0 };
  await setDoc(COLLECTIONS.USERS, uid, { ...user, createdAt: now() });
  return success(res, { token: generateToken({ uid, phone, role: ROLES.CUSTOMER }), user }, 'OTP verified');
}

export async function forgotPassword(req, res) {
  const { auth } = getFirebase();
  const link = await auth.generatePasswordResetLink(req.body.email);
  return success(res, { resetLink: link }, 'Password reset link generated');
}

export async function resetPassword(req, res) {
  return success(res, { reset: true }, 'Use Firebase client SDK to confirm password reset code');
}

export async function profile(req, res) {
  const user = await getDoc(COLLECTIONS.USERS, req.user.uid);
  return success(res, { user: publicUser(user || req.user) });
}

export async function updateProfile(req, res) {
  const updated = await setDoc(COLLECTIONS.USERS, req.user.uid, req.body);
  return success(res, { user: publicUser(updated) }, 'Profile updated');
}

export async function logout(req, res) {
  return success(res, { loggedOut: true }, 'Logged out successfully');
}
