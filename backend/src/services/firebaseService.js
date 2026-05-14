import { getFirebase } from '../config/firebase.js';
import { COLLECTIONS } from '../utils/constants.js';

export function now() {
  return new Date().toISOString();
}

export async function getDoc(collection, id) {
  const { db } = getFirebase();
  const snap = await db.collection(collection).doc(id).get();
  return snap.exists ? { id: snap.id, ...snap.data() } : null;
}

export async function setDoc(collection, id, data, merge = true) {
  const { db } = getFirebase();
  const payload = { ...data, updatedAt: now() };
  await db.collection(collection).doc(id).set(payload, { merge });
  return { id, ...payload };
}

export async function addDoc(collection, data) {
  const { db } = getFirebase();
  const ref = db.collection(collection).doc();
  const payload = { ...data, createdAt: now(), updatedAt: now() };
  await ref.set(payload);
  return { id: ref.id, ...payload };
}

export async function deleteDoc(collection, id) {
  const { db } = getFirebase();
  await db.collection(collection).doc(id).delete();
  return { id, deleted: true };
}

export async function listDocs(collection, { limit = 50, where = [], orderBy } = {}) {
  const { db } = getFirebase();
  let query = db.collection(collection);
  for (const clause of where) query = query.where(...clause);
  if (orderBy) query = query.orderBy(...orderBy);
  const snap = await query.limit(Number(limit)).get();
  return snap.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

export async function uploadBuffer({ buffer, destination, contentType }) {
  const { bucket } = getFirebase();
  const file = bucket.file(destination);
  await file.save(buffer, { metadata: { contentType }, resumable: false });
  await file.makePublic();
  return `https://storage.googleapis.com/${bucket.name}/${destination}`;
}

export async function logActivity(actorId, action, entity, metadata = {}) {
  return addDoc(COLLECTIONS.ACTIVITY_LOGS, { actorId, action, entity, metadata });
}
