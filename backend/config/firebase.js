import { applicationDefault, cert, getApps, initializeApp } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";

let firebaseApp;

function parseServiceAccount() {
  const raw = process.env.FIREBASE_SERVICE_ACCOUNT_JSON?.trim();
  if (!raw) return null;

  const serviceAccount = JSON.parse(raw);
  if (serviceAccount.private_key) {
    serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, "\n");
  }
  return serviceAccount;
}

export function getFirebaseMessaging() {
  if (!firebaseApp) {
    const existing = getApps()[0];
    if (existing) {
      firebaseApp = existing;
    } else {
      const serviceAccount = parseServiceAccount();
      firebaseApp = initializeApp({
        credential: serviceAccount ? cert(serviceAccount) : applicationDefault(),
      });
    }
  }

  return getMessaging(firebaseApp);
}

export function isFirebaseConfigured() {
  return Boolean(
    process.env.FIREBASE_SERVICE_ACCOUNT_JSON?.trim() ||
      process.env.GOOGLE_APPLICATION_CREDENTIALS?.trim()
  );
}
