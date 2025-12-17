# 🔐 CampusConnect - Test Credentials & Quick Start

## 🚀 Quick Start (2 minutes)

```bash
# 1. Connect Android device
adb devices

# 2. Navigate to project
cd d:\CampusConnect\campus_connect

# 3. Run app
flutter run -d RZCWA1SNFZD
```

**When app opens**:
- You'll see **LoginPage**
- Tap **"Don't have an account? Sign up"**
- Fill the registration form (see below)

---

## 📝 How to Register a New Test User

In the app, tap "Sign Up" and fill:

| Field | Value | Notes |
|-------|-------|-------|
| Name | `Alice Johnson` | Any name |
| Email | `alice@example.com` | Must be unique (no existing user) |
| Password | `password123` | Min 6 characters |
| Confirm | `password123` | Must match password |
| Role | **Student** | Choose from dropdown |

**Tap Register** → App creates account → Auto-navigates to **StudentDashboard** ✅

---

## ✅ What You Should See

After successful registration:

1. **StudentDashboard** displays with:
   - 5 Events (Tech Symposium, Cultural Fest, etc.)
   - 3 Clubs
   - Button to register for events

2. **Try registering for an event**:
   - Tap any event card
   - In EventDetailsPage, tap "Register for Event"
   - Should see: "Successfully registered!" ✅

3. **Logout & Login**:
   - Tap menu → Logout
   - Return to LoginPage
   - Login with: `alice@example.com` / `password123`
   - Should see StudentDashboard again ✅

---

## 🎓 Pre-Seeded Sample Data (Optional)

If you want to login with existing test accounts instead of registering:

### Step 1: Create Auth Accounts
You need to create these users in **Firebase Authentication**:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select **clix-campus** project
3. Go to **Authentication** tab
4. Click **Add User** (or `+` button)
5. Create these users:

| Email | Password | Role |
|-------|----------|------|
| `student1@example.com` | `password123` | Student |
| `student2@example.com` | `password123` | Student |
| `admin@example.com` | `password123` | Admin |
| `advisor1@example.com` | `password123` | Advisor |

### Step 2: Login in App
In the app LoginPage:
- **Email**: `student1@example.com`
- **Password**: `password123`
- **Tap Login** → See StudentDashboard with 5 events ✅

---

## 🔑 Firestore Database (Already Populated)

If you want to check the database directly:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select **clix-campus** project
3. Go to **Firestore Database**
4. View collections:

```
✅ users/          → 6 test users (all with password: 'password123')
✅ events/         → 5 events ready to register
✅ clubs/          → 3 clubs
✅ proposals/      → 3 event proposals
✅ payments/       → 3 payment records
```

---

## 🆘 If Something Doesn't Work

### "Registration failed"
- Try a different email (must be unique)
- Check password is at least 6 characters
- Ensure proper internet connection

### "Login shows 'User not found' error"
- User doesn't exist in Firebase Auth
- Either:
  - **Register in the app** (recommended), OR
  - **Create manually in Firebase Console** (see Pre-Seeded section above)

### "Events not showing after login"
- Pull down to refresh
- Check Firebase Firestore has `events` collection
- Check device internet connection

### "Can't register for event"
- App needs internet connection
- Check Firestore is accessible
- Try again after 2 seconds

### "App crashes on startup"
- Run `flutter clean` then `flutter pub get`
- Verify Firebase dependencies installed
- Check no linting errors: `flutter analyze`

---

## 🎯 Test Checklist

Complete these tests to verify everything works:

- [ ] **Registration**: Sign up → See StudentDashboard → 5 events visible
- [ ] **Event Register**: Tap event → Register → "Successfully registered" message
- [ ] **Logout**: Tap menu → Logout → Return to LoginPage  
- [ ] **Login**: Login with registered email → See StudentDashboard again
- [ ] **Firestore**: Open Firebase Console → Check `users` collection shows new user

**All checked? You're done! 🎉**

---

## 📱 Device Connection

```bash
# List connected devices
adb devices

# Expected output:
# List of attached devices
# RZCWA1SNFZD    device   <- Your device

# If device not showing:
# 1. Enable USB Debugging on device
# 2. Disconnect and reconnect USB cable
# 3. Run: adb devices again
```

---

## 🔧 Useful Commands

```bash
# Clean build (if stuck)
flutter clean

# Get dependencies
flutter pub get

# Check for errors
flutter analyze

# Run on specific device
flutter run -d RZCWA1SNFZD

# Run with verbose output
flutter run -d RZCWA1SNFZD -v

# Stop running app
Press 'q' in terminal
```

---

## 📞 Key Contacts

- **Firebase Project**: `clix-campus`
- **Firestore**: [Console Link](https://console.firebase.google.com/project/clix-campus/firestore)
- **Auth**: [Console Link](https://console.firebase.google.com/project/clix-campus/authentication)
- **Documentation**: Check [TESTING_GUIDE.md](TESTING_GUIDE.md) for detailed scenarios

---

## ✨ What's Included

✅ Firebase Authentication (login/register)  
✅ Firestore Database (events, users, clubs)  
✅ Event Registration System  
✅ Role-Based Navigation (Student/Admin/Advisor)  
✅ Mock Data Fallback (for offline testing)  
✅ Sample Data Pre-Seeded (5 events, 3 clubs)  
✅ Auto-Login after Registration  
✅ No Build Errors  

---

**You're all set! Start the app and register a new user. That's it! 🚀**
