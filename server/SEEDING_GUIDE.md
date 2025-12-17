# Firestore Seeding Guide

This guide walks you through populating your Firebase Firestore with sample data for CampusConnect.

## Collections Structure

The seeding script creates the following collections:

```
Firestore Database
├── users/
│   ├── student_001 { name, email, role, createdAt, ... }
│   ├── student_002
│   ├── advisor_001
│   └── admin_001
│
├── clubs/
│   ├── club_001 { name, description, memberCount, advisorId, ... }
│   ├── club_002
│   └── club_003
│       └── members/ (subcollection)
│           ├── student_001 { role, joinedAt }
│           ├── student_002
│           └── advisor_001
│
├── events/
│   ├── event_001 { title, club, date, registeredCount, ... }
│   ├── event_002
│   ├── event_003
│   ├── event_004
│   └── event_005
│       └── registrations/ (subcollection)
│           ├── student_001 { registeredAt }
│           └── student_002
│
├── proposals/
│   ├── proposal_001 { title, clubId, status, budget, ... }
│   ├── proposal_002
│   └── proposal_003
│
└── payments/
    ├── payment_001 { eventId, userId, amount, status, ... }
    ├── payment_002
    └── payment_003
```

## Setup Steps

### 1. Get Firebase Service Account Key

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your **clix-campus** project
3. Click ⚙️ **Settings** (top-left corner)
4. Go to **Service Accounts** tab
5. Click **Generate New Private Key** → Save the JSON file safely
   - ⚠️ **NEVER commit this file to Git!**

### 2. Install Dependencies

Navigate to the server folder and install Firebase Admin SDK:

```powershell
cd d:\CampusConnect\campus_connect\server
npm install firebase-admin
```

### 3. Run the Seeding Script

**Windows PowerShell:**

```powershell
# Read the service account JSON file and set as environment variable
$serviceAccountJson = Get-Content "path/to/your/service-account-key.json" -Raw
$env:SERVICE_ACCOUNT_JSON = $serviceAccountJson
node seed_firestore.js
```

**Windows CMD:**

```cmd
set /p SERVICE_ACCOUNT_JSON=< path\to\your\service-account-key.json
node seed_firestore.js
```

**Mac/Linux:**

```bash
export SERVICE_ACCOUNT_JSON=$(cat /path/to/service-account-key.json)
node seed_firestore.js
```

### 4. Verify in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project → **Firestore Database**
3. You should see collections: `users`, `clubs`, `events`, `proposals`, `payments`

## Sample Data Overview

### Users (6 total)
- **3 Students**: Alice, Bob, Carol
- **2 Advisors**: Prof. Emily Wilson, Dr. Michael Brown
- **1 Admin**: Dr. Principal Admin

### Clubs (3 total)
1. Computer Society (150 members)
2. Cultural Committee (200 members)
3. Entrepreneurship Cell (120 members)

### Events (5 total)
- Tech Symposium 2024 (Free, 200 capacity)
- Cultural Fest Auditions ($50, 150 capacity)
- Web Development Workshop ($200, 60 capacity)
- Startup Pitch Competition ($100, 100 capacity)
- AI/ML Bootcamp ($500, 40 capacity)

### Proposals (3 total)
- AI Workshop Series (pending review)
- Dance Competition (advisor approved)
- Tech Fest 2024 (rejected)

### Payments (3 total)
- Sample payment records for events

## Using Data in Flutter App

Your Flutter app is configured to fetch from Firestore:

```dart
// Events from Firestore
await EventProvider.loadEvents(); // Fetches from events collection

// Users from Firestore
await AuthProvider.login(email, password); // Reads from users collection

// User registration
await EventProvider.registerForEvent(eventId); // Writes to events/{eventId}/registrations
```

## Troubleshooting

### ❌ "SERVICE_ACCOUNT_JSON environment variable not set"
Make sure you set the environment variable before running the script. The JSON must be a single line.

### ❌ "Permission denied" when writing to Firestore
Check your Firestore Rules in Firebase Console. For development, use:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### ❌ "Collection not found" in Flutter app
Verify the seeding script completed successfully and check Firestore Collections list in Firebase Console.

## Adding More Data

You can easily extend `seed_firestore.js` to add more users, events, or clubs. Just add objects to the arrays and re-run the script.

## Cleanup (Optional)

To delete all seeded collections and start fresh:

```javascript
// Add this to seed_firestore.js before seeding
async function cleanup() {
  const collections = ['users', 'clubs', 'events', 'proposals', 'payments'];
  for (const collection of collections) {
    const docs = await db.collection(collection).get();
    for (const doc of docs.docs) {
      await doc.ref.delete();
    }
  }
}
```

---

**Next Steps**: Once seeded, run your Flutter app and test registration, login, and event fetching!
