# Quick Start: Connect to Firebase

## Option 1: Automated Setup (Recommended)

Run the PowerShell script:

```powershell
.\setup_firebase.ps1
```

## Option 2: Manual Setup

### 1. Login to Firebase
```bash
firebase login
```

### 2. Configure Firebase
```bash
flutterfire configure
```

**What happens:**
- You'll see a list of Firebase projects
- Select an existing project OR create a new one
- Select platforms (Android, iOS, Web, Windows)
- `firebase_options.dart` will be auto-generated

### 3. Enable Authentication in Firebase Console

1. Go to: https://console.firebase.google.com/
2. Select your project
3. Click **Authentication** → **Get started**
4. Go to **Sign-in method** tab
5. Click **Email/Password**
6. Enable it (toggle ON)
7. Click **Save**

### 4. Create Firestore Database

1. In Firebase Console, click **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (for development)
4. Select a location (closest to you)
5. Click **Enable**

### 5. Set Security Rules

1. In Firestore, go to **Rules** tab
2. Replace with these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create, update: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    match /events/{eventId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /clubs/{clubId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

3. Click **Publish**

### 6. Test It!

```bash
flutter run
```

Try registering a new user. Check:
- Firebase Console → Authentication → Users (should see your user)
- Firestore Database → Data → users collection (should see user document)

## ✅ Done!

Your app is now connected to Firebase! Authentication and database operations will work with real Firebase services.

