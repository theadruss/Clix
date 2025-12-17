# Quick Firebase Setup Guide

Follow these steps to connect your CampusConnect app to Firebase:

## Step 1: Install FlutterFire CLI

Open PowerShell or Command Prompt in your project directory and run:

```bash
dart pub global activate flutterfire_cli
```

## Step 2: Login to Firebase

```bash
firebase login
```

This will open your browser to authenticate with Firebase.

## Step 3: Create Firebase Project (if you don't have one)

1. Go to https://console.firebase.google.com/
2. Click "Add project" or "Create a project"
3. Enter project name: `campus-connect` (or your preferred name)
4. Disable Google Analytics (optional, for now)
5. Click "Create project"
6. Wait for project creation to complete

## Step 4: Configure Firebase in Your App

Run this command in your project root (`campus_connect` folder):

```bash
flutterfire configure
```

**What to do:**
- Select your Firebase project from the list (or create a new one)
- Select platforms: Android, iOS, Web, Windows (select all you need)
- The command will automatically generate `firebase_options.dart` with your credentials

## Step 5: Enable Authentication

1. Go to Firebase Console: https://console.firebase.google.com/
2. Select your project
3. Click "Authentication" in the left menu
4. Click "Get started"
5. Go to "Sign-in method" tab
6. Click "Email/Password"
7. Enable "Email/Password" (toggle ON)
8. Click "Save"

## Step 6: Create Firestore Database

1. In Firebase Console, click "Firestore Database" in the left menu
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location (choose closest to you)
5. Click "Enable"

## Step 7: Set Firestore Security Rules

1. In Firestore Database, go to "Rules" tab
2. Replace the rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      // Users can read their own data, authenticated users can read any user
      allow read: if request.auth != null;
      // Users can only write their own data
      allow create, update: if request.auth != null && request.auth.uid == userId;
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

3. Click "Publish"

## Step 8: Install Dependencies

```bash
flutter pub get
```

## Step 9: Test the Connection

1. Run your app: `flutter run`
2. Try registering a new user
3. Check Firebase Console → Authentication → Users (should see your new user)
4. Check Firestore Database → Data → users collection (should see user document)

## Troubleshooting

### "firebase: command not found"
- Make sure FlutterFire CLI is installed: `dart pub global activate flutterfire_cli`
- Add to PATH if needed: `dart pub global activate flutterfire_cli --executable=firebase`

### "No Firebase projects found"
- Make sure you're logged in: `firebase login`
- Create a project in Firebase Console first

### Firebase initialization error in app
- Check that `firebase_options.dart` was generated correctly
- Verify all API keys are present (not "YOUR_PROJECT_ID")
- Make sure you selected the correct platforms in `flutterfire configure`

### Authentication not working
- Verify Email/Password is enabled in Firebase Console → Authentication
- Check that Firestore database is created
- Verify security rules are published

## Next Steps

Once Firebase is connected:
- ✅ Authentication will work with real Firebase Auth
- ✅ User data will be stored in Firestore
- ✅ You can add more collections (events, clubs, etc.)
- ✅ You can add Firebase Storage for file uploads
- ✅ You can add Cloud Functions for backend logic

