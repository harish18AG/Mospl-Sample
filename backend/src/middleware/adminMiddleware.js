import { ROLES } from '../utils/constants.js';
import { fail } from '../utils/responseHandler.js';

export function requireAdmin(req, res, next) {
  if (req.user?.role !== ROLES.ADMIN) return next(fail('Admin access required', 403));
  return next();
}
