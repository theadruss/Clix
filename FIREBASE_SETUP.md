# Firebase Setup Guide

This guide will help you set up Firebase for your CampusConnect application.

## Prerequisites

1. A Firebase account (create one at https://firebase.google.com/)
2. FlutterFire CLI installed globally

## Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

## Step 2: Configure Firebase

Run the following command in your project root:

```bash
flutterfire configure
```

This will:
- Prompt you to select or create a Firebase project
- Generate the `firebase_options.dart` file with your project credentials
- Configure Firebase for all platforms (Android, iOS, Web, etc.)

## Step 3: Enable Authentication Methods

1. Go to Firebase Console → Authentication → Sign-in method
2. Enable **Email/Password** authentication
3. Optionally enable other methods (Google, Apple, etc.)

## Step 4: Set Up Firestore Database

1. Go to Firebase Console → Firestore Database
2. Click "Create database"
3. Start in **test mode** (for development) or **production mode** (for production)
4. Select your preferred location

### Firestore Security Rules (Development)

For development, you can use these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      allow read: if request.auth != null;
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

**Note:** Update these rules for production with proper security constraints.

## Step 5: Install Dependencies

Run the following command to install all Firebase dependencies:

```bash
flutter pub get
```

## Step 6: Test the Connection

1. Run your app: `flutter run`
2. Try registering a new user
3. Check Firebase Console → Authentication to see the new user
4. Check Firestore Database → users collection to see user data

## Firestore Collections Structure

The app uses the following Firestore collections:

- **users**: Stores user profile information
  - Document ID: User UID from Firebase Auth
  - Fields: id, email, name, role, collegeId, createdAt, isEmailVerified, etc.

- **events**: (To be implemented) Stores event information
- **clubs**: (To be implemented) Stores club information

## Troubleshooting

### Firebase initialization error
- Make sure `firebase_options.dart` is properly generated
- Verify your Firebase project credentials are correct
- Check that Firebase is enabled in your Firebase Console

### Authentication errors
- Ensure Email/Password authentication is enabled in Firebase Console
- Check that your email format is valid
- Verify password meets Firebase requirements (minimum 6 characters)

### Firestore permission errors
- Check your Firestore security rules
- Ensure the user is authenticated before accessing Firestore
- Verify collection and document paths are correct

## Next Steps

After Firebase is set up, you can:
1. Implement additional Firebase features (Storage, Cloud Functions, etc.)
2. Set up proper Firestore security rules for production
3. Add Firebase Analytics and Crashlytics
4. Configure Firebase Cloud Messaging for push notifications

