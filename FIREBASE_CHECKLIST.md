# Firebase Setup Checklist ✅

## ✅ Completed
- [x] Firebase project created: `clix-college-app`
- [x] FlutterFire CLI configured
- [x] `firebase_options.dart` generated with real credentials
- [x] Web platform configured
- [x] Android platform configured  
- [x] iOS platform configured
- [x] Dependencies installed

## 🔲 Remaining Steps (Do these in Firebase Console)

### Step 1: Enable Authentication
1. Go to: https://console.firebase.google.com/project/clix-college-app/authentication
2. Click **"Get started"** (if not already enabled)
3. Go to **"Sign-in method"** tab
4. Click **"Email/Password"**
5. **Enable** Email/Password (toggle ON)
6. Click **"Save"**

### Step 2: Create Firestore Database
1. Go to: https://console.firebase.google.com/project/clix-college-app/firestore
2. Click **"Create database"**
3. Choose **"Start in test mode"** (for development)
4. Select a **location** (choose closest to you, e.g., `us-central`, `asia-south1`)
5. Click **"Enable"**

### Step 3: Set Firestore Security Rules
1. In Firestore, go to **"Rules"** tab
2. Replace the rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      // Authenticated users can read any user profile
      allow read: if request.auth != null;
      // Users can only create/update their own profile
      allow create, update: if request.auth != null && request.auth.uid == userId;
      // Users can delete their own profile
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Events collection
    match /events/{eventId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    
    // Clubs collection
    match /clubs/{clubId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

3. Click **"Publish"**

## 🧪 Test the Connection

After completing the steps above:

1. Run your app:
   ```bash
   flutter run
   ```

2. Try registering a new user:
   - Use the registration form in your app
   - Enter email and password

3. Verify in Firebase Console:
   - **Authentication → Users**: Should see your new user
   - **Firestore Database → Data → users collection**: Should see user document with profile data

## 🎉 Success Indicators

- ✅ App runs without Firebase initialization errors
- ✅ User registration creates account in Firebase Auth
- ✅ User data appears in Firestore `users` collection
- ✅ Login works with registered credentials
- ✅ User can logout successfully

## 🔗 Quick Links

- **Firebase Console**: https://console.firebase.google.com/project/clix-college-app
- **Authentication**: https://console.firebase.google.com/project/clix-college-app/authentication
- **Firestore Database**: https://console.firebase.google.com/project/clix-college-app/firestore

## ⚠️ Troubleshooting

### "Firebase initialization error"
- Check that `firebase_options.dart` has real values (not "YOUR_PROJECT_ID")
- Verify project ID matches: `clix-college-app`

### "Authentication failed"
- Make sure Email/Password is enabled in Firebase Console
- Check that Firestore database is created

### "Permission denied" errors
- Verify Firestore security rules are published
- Check that user is authenticated before accessing Firestore

### "No user document found"
- User registration should create document automatically
- Check Firestore → users collection
- Verify document ID matches Firebase Auth UID

