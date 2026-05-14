import { COLLECTIONS } from '../utils/constants.js';
import { success } from '../utils/responseHandler.js';
import { addDoc, listDocs, setDoc } from '../services/firebaseService.js';

export async function listNotifications(req, res) {
  return success(res, { notifications: await listDocs(COLLECTIONS.NOTIFICATIONS, { where: [['userId', '==', req.params.userId]], limit: 100 }) });
}
export async function createNotification(req, res) {
  return success(res, { notification: await addDoc(COLLECTIONS.NOTIFICATIONS, { ...req.body, read: false }) }, 'Notification created', 201);
}
export async function markRead(req, res) {
  return success(res, { notification: await setDoc(COLLECTIONS.NOTIFICATIONS, req.params.notificationId, { read: true }) }, 'Notification marked read');
}
