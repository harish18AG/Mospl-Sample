import admin from 'firebase-admin';
import { env } from './env.js';

function credential() {
  if (env.firebase.projectId && env.firebase.clientEmail && env.firebase.privateKey) {
    return admin.credential.cert({
      projectId: env.firebase.projectId,
      clientEmail: env.firebase.clientEmail,
      privateKey: env.firebase.privateKey,
    });
  }
  return admin.credential.applicationDefault();
}

export function getFirebase() {
  if (!admin.apps.length) {
    admin.initializeApp({
      credential: credential(),
      storageBucket: env.firebase.storageBucket,
    });
  }
  return {
    admin,
    auth: admin.auth(),
    db: admin.firestore(),
    bucket: admin.storage().bucket(),
    fieldValue: admin.firestore.FieldValue,
    timestamp: admin.firestore.Timestamp,
  };
}
