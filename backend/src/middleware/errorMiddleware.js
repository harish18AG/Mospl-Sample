export function notFound(req, res) {
  return res.status(404).json({ success: false, message: `Route not found: ${req.method} ${req.originalUrl}` });
}

export function errorMiddleware(err, req, res, next) {
  const statusCode = err.statusCode || 500;
  const payload = { success: false, message: err.message || 'Internal server error' };
  if (err.details) payload.details = err.details;
  if (process.env.NODE_ENV !== 'production') payload.stack = err.stack;
  console.error(`[error] ${req.method} ${req.originalUrl}`, err);
  return res.status(statusCode).json(payload);
}
