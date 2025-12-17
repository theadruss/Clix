// Create Firebase Auth users
const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const serviceAccountPath = path.join(__dirname, 'service-account-key.json');
if (!fs.existsSync(serviceAccountPath)) {
  console.error('ERROR: service-account-key.json not found');
  process.exit(1);
}

const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const auth = admin.auth();

const testUsers = [
  { email: 'student1@example.com', password: 'password123', displayName: 'Alice Johnson' },
  { email: 'student2@example.com', password: 'password123', displayName: 'Bob Smith' },
  { email: 'student3@example.com', password: 'password123', displayName: 'Carol Davis' },
  { email: 'advisor1@example.com', password: 'password123', displayName: 'Prof. Emily Wilson' },
  { email: 'advisor2@example.com', password: 'password123', displayName: 'Dr. Michael Brown' },
  { email: 'admin@example.com', password: 'password123', displayName: 'Dr. Principal Admin' },
];

async function createAuthUsers() {
  try {
    console.log('🔐 Creating Firebase Auth users...\n');

    for (const user of testUsers) {
      try {
        const userRecord = await auth.createUser({
          email: user.email,
          password: user.password,
          displayName: user.displayName,
        });
        console.log(`✅ Created: ${user.email}`);
      } catch (error) {
        if (error.code === 'auth/email-already-exists') {
          console.log(`⚠️  Already exists: ${user.email}`);
        } else {
          console.error(`❌ Error creating ${user.email}:`, error.message);
        }
      }
    }

    console.log('\n🎉 Firebase Auth setup completed!');
    console.log('\n📧 Test Credentials:');
    testUsers.forEach(user => {
      console.log(`  • ${user.email} / password123`);
    });
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  } finally {
    process.exit(0);
  }
}

createAuthUsers();
