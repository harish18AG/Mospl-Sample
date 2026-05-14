import { validationResult } from 'express-validator';
import { fail } from '../utils/responseHandler.js';

export function validate(req, res, next) {
  const result = validationResult(req);
  if (!result.isEmpty()) return next(fail('Validation failed', 422, result.array()));
  return next();
}
