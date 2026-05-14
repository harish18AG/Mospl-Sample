import { success } from '../utils/responseHandler.js';
import { buildDashboard } from '../services/analyticsService.js';

export async function overview(req, res) { return success(res, await buildDashboard()); }
