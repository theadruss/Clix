# Firebase Authentication Setup for Testing

Since the seeding script populates Firestore (database), but Firebase Authentication (for login/registration) is separate, you have two options:

## Option 1: Register Users Directly in App (RECOMMENDED)

1. **Run the app**: `flutter run -d RZCWA1SNFZD`
2. **Click "Don't have an account? Sign up"**
3. **Fill in registration form**:
   - Name: `Alice Johnson`
   - Email: `student1@example.com`
   - Password: `password123`
   - Confirm Password: `password123`
   - Role: **Student**
4. **Click Register** ✅

The app will:
- Create user in Firebase Authentication
- Create user document in Firestore with matching email
- Auto-login and show StudentDashboard with 5 real events

## Option 2: Create Users via Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select **clix-campus** project
3. Go to **Authentication** tab
4. Click **Add user** (or `+` button)
5. Create users with these emails:
   - `student1@example.com` (password: `password123`)
   - `student2@example.com` (password: `password123`)
   - `student3@example.com` (password: `password123`)
   - `advisor1@example.com` (password: `password123`)
   - `advisor2@example.com` (password: `password123`)
   - `admin@example.com` (password: `password123`)
6. Once created, login with these credentials in the app

## How to Fix Login Issues

If you see "Incorrect password or user doesn't exist":

1. Make sure the user exists in **Firebase Authentication** (not just Firestore)
2. Check the exact email and password match
3. If stuck, use **Option 1** (register in the app) to create a new test user

---

## Test Flow

After registration/login, you should see:
- ✅ 5 Events from Firestore (Tech Symposium, Cultural Fest, etc.)
- ✅ 3 Clubs with members
- ✅ Ability to register for events (data stored in Firestore)
- ✅ User dashboard matching their role (Student/Advisor/Admin)

---

## Troubleshooting

### Login shows "incorrect/malformed or has expired"
- User doesn't exist in Firebase Authentication
- Use **Option 1** to register in the app

### Registration shows error
- Check email isn't already used in Firebase Auth
- Make sure password is at least 6 characters
- Try a different email (e.g., `teststudent@example.com`)

### Can't see events after login
- Events should load from Firestore automatically
- Check Firebase Firestore has the `events` collection
- Pull down to refresh if needed

---

**Recommended**: Just register a new user in the app. It's the easiest way!
