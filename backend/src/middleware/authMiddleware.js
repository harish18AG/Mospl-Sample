import { getFirebase } from '../config/firebase.js';
import { fail } from '../utils/responseHandler.js';
import { verifyJwt } from '../utils/generateToken.js';

export async function authenticate(req, res, next) {
  try {
    const header = req.headers.authorization || '';
    const token = header.startsWith('Bearer ') ? header.slice(7) : null;
    if (!token) throw fail('Authentication token is required', 401);

    try {
      req.user = verifyJwt(token);
      return next();
    } catch {
      const { auth } = getFirebase();
      const decoded = await auth.verifyIdToken(token);
      req.user = { uid: decoded.uid, email: decoded.email, role: decoded.role || 'customer', firebase: true };
      return next();
    }
  } catch (error) {
    return next(error);
  }
}

export function optionalAuth(req, res, next) {
  if (!req.headers.authorization) return next();
  return authenticate(req, res, next);
}
