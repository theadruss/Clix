// Example Node.js script showing how to use a Firebase service account
// IMPORTANT: DO NOT commit your service account JSON into source control.
// Store it securely (environment variable, secrets manager) and rotate keys if leaked.

// Install deps: npm install firebase-admin

const admin = require('firebase-admin');
const fs = require('fs');

// Load service account JSON from environment variable or secure path
// Example: set SERVICE_ACCOUNT_JSON='{"type":"service_account",...}'
const serviceAccountJson = process.env.SERVICE_ACCOUNT_JSON;
if (!serviceAccountJson) {
  console.error('Set SERVICE_ACCOUNT_JSON environment variable with the service account JSON');
  process.exit(1);
}

const serviceAccount = JSON.parse(serviceAccountJson);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function listEvents() {
  const snapshot = await db.collection('events').limit(10).get();
  snapshot.forEach(doc => {
    console.log(doc.id, doc.data());
  });
}

listEvents().catch(err => {
  console.error('Error', err);
});
