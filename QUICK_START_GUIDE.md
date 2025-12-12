# CampusConnect - Quick Start Guide

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for device emulation)
- Git (for version control)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/theadruss/Clix.git
cd Clix

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Build APK (Android)
flutter build apk --release

# 5. Build IPA (iOS)
flutter build ios --release
```

---

## 🎯 First Time Usage

### Login Credentials

Click on the role buttons in the app to auto-fill these credentials:

| Role | Email | Password |
|------|-------|----------|
| **Admin** | `admin@campus.edu` | `password` |
| **Student** | `student@campus.edu` | `password` |
| **Club Coordinator** | `club@campus.edu` | `password` |
| **Advisor** | `advisor@campus.edu` | `password` |
| **External Organizer** | `external@org.com` | `password` |

---

## 👨‍🎓 Student User Journey

### Step 1: Browse Events
1. Login as **Student** (`student@campus.edu`)
2. Land on **Home** tab
3. View "Featured Events" and "Upcoming Events"
4. Use search bar to find specific events
5. Tap event card to see details

### Step 2: Register for Event
1. On event detail, tap **"Register"** or **"Interested"**
2. Choose to volunteer (if event needs volunteers)
3. See confirmation message

### Step 3: Make Payment
1. Tap **"Register"** on a paid event
2. Select payment method:
   - Razorpay
   - Stripe (Credit/Debit Card)
   - UPI
3. Complete payment flow
4. Receive payment confirmation

### Step 4: Submit Feedback
1. Go to **Profile** → **"My Events"**
2. Find a past event
3. Tap **"Rate Event"**
4. Give rating (1-5 stars)
5. Write review
6. Select feedback tags
7. Submit feedback

### Step 5: Manage Notifications
1. Tap **Notifications icon** (or bell icon)
2. View all notifications
3. Filter by type (Events, Approvals, Payments)
4. Mark as read or delete
5. Tap to see details

---

## 🏛️ Club Coordinator Journey

### Step 1: Submit Event Proposal
1. Login as **Club Coordinator** (`club@campus.edu`)
2. Go to **"Proposals"** tab
3. Tap **"Create New Event"**
4. Fill event details:
   - Title, description
   - Date, time, venue
   - Capacity, budget
   - Volunteer roles (if needed)
5. Submit proposal
6. Get confirmation

### Step 2: Manage Members
1. Go to **"Members"** tab
2. View all club members
3. Tap **+ icon** to add member
4. Assign roles (Member, Coordinator, Subgroup Head)
5. Remove inactive members

### Step 3: Track Approval Status
1. Check **Pending Approvals** in dashboard
2. See advisor feedback
3. Make requested changes
4. Resubmit if needed
5. Track final admin approval

---

## 👨‍🏫 Club Advisor Journey

### Step 1: Review Proposals
1. Login as **Advisor** (`advisor@campus.edu`)
2. Go to **"Approvals"** tab
3. View pending proposals from coordinator
4. Check event details, budget, resources
5. **Approve** or **Request Changes**

### Step 2: Manage Club Budget
1. Go to **"Budget"** tab
2. Review budget requests
3. Approve or reject allocations
4. Set spending limits
5. Generate budget reports

### Step 3: View Club Analytics
1. Go to **"Analytics"** tab
2. See member engagement stats
3. Track event performance
4. Review financial summaries
5. Export reports

---

## 👨‍💼 Admin Journey

### Step 1: Review & Approve Events
1. Login as **Admin** (`admin@campus.edu`)
2. Go to **"Approvals"** tab
3. View advisor-approved events
4. Check for venue conflicts
5. **Approve** or **Reject**

### Step 2: Check Venue Conflicts
1. System automatically detects conflicts
2. Dialog shows conflicting events
3. Reject to prevent double-booking
4. Approve only if no conflicts

### Step 3: View Analytics Dashboard
1. Go to **"Analytics"** tab
2. See:
   - Event participation rates
   - Club engagement metrics
   - Revenue tracking
   - User statistics
3. Export reports

### Step 4: Manage Users
1. Go to **"Users"** tab
2. View all registered users
3. Approve new registrations
4. Remove inactive users
5. Manage roles

### Step 5: System Settings
1. Go to **"Settings"** tab
2. Configure:
   - Email templates
   - Notification preferences
   - System parameters
   - Maintenance modes

---

## 🏢 External Organizer Journey

### Step 1: Submit Event Directly
1. Login as **External Organizer** (`external@org.com`)
2. Land on dashboard with stats
3. Tap **"Submit New Event"**
4. Fill comprehensive form:
   - Event details
   - Organizer information
   - Contact details
   - Budget and pricing
5. Submit proposal
6. Get confirmation

### Step 2: Track Proposal Status
1. Go to **"Proposals"** tab
2. See all submitted proposals
3. Filter by status:
   - Pending
   - Approved
   - Rejected
4. Click to see details and feedback

### Step 3: View Analytics
1. Go to **"Analytics"** tab
2. See:
   - Total registrations
   - Revenue generated
   - Average rating
   - Attendance rates
3. Track performance metrics

### Step 4: Communicate with Admin
1. Tap **"Contact Admin"** button
2. Send messages
3. Get notifications of responses
4. Manage communication history

---

## 🔧 Common Tasks

### How to Test Payment Flow
1. Login as **Student**
2. Find event with fee
3. Tap **"Register"**
4. Select payment method
5. Complete checkout (mock payment)
6. See confirmation

### How to Submit Feedback
1. Go to **"My Events"**
2. Select past event
3. Tap **"Rate Event"**
4. Provide rating and review
5. Select relevant tags
6. Submit

### How to See Notifications
1. Tap **Notifications icon** (top-right)
2. View unread notifications
3. Filter by category
4. Mark as read or delete

### How to Manage Club
1. Login as **Coordinator** or **Advisor**
2. Go to **Club** tab
3. Select club from dropdown
4. Navigate between:
   - Dashboard (overview)
   - Members (management)
   - Events (proposals)
   - Analytics (reports)

---

## 🐛 Troubleshooting

### App Won't Start
```bash
# Clear dependencies and rebuild
flutter clean
flutter pub get
flutter run
```

### Login Fails
- Ensure you're using correct credentials
- Check the demo credentials table above
- Clear app data and try again

### Payment Page Not Working
- All payment processing is mocked
- No real charges are made
- Submit completes after 3-second delay

### Venue Conflict Not Detected
- Conflict detection checks:
  - Same venue
  - Same date
  - Overlapping time
- Only detects within same date

### Can't Create Event
- Ensure all required fields are filled
- Select a valid date (today or future)
- Select time for event

---

## 📊 Feature Matrix

| Feature | Student | Coordinator | Advisor | Admin | External |
|---------|---------|-------------|---------|-------|----------|
| Browse Events | ✅ | ✅ | ✅ | ✅ | ❌ |
| Register Events | ✅ | ✅ | ✅ | ❌ | ❌ |
| Make Payments | ✅ | ✅ | ✅ | ❌ | ❌ |
| Submit Feedback | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create Proposal | ❌ | ✅ | ❌ | ❌ | ✅ |
| Manage Members | ❌ | ✅ | ✅ | ❌ | ❌ |
| Approve Events | ❌ | ❌ | ✅ | ✅ | ❌ |
| View Analytics | ✅ | ✅ | ✅ | ✅ | ✅ |
| Manage Users | ❌ | ❌ | ❌ | ✅ | ❌ |
| System Settings | ❌ | ❌ | ❌ | ✅ | ❌ |
| Notifications | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## 🎓 Project Architecture

```
Authentication Layer
  ↓
Role Detection
  ↓
Dashboard Selection
  ↓
Feature Modules (by Role)
  ↓
Shared Components
  ↓
Data Services (Mock/API)
```

### Key Patterns Used
- **Provider Pattern**: State management
- **Repository Pattern**: Data access
- **Model-View Architecture**: UI organization
- **Dependency Injection**: Service initialization

---

## 📱 Responsive Design

The app is designed for:
- **Mobile** (360px - 480px width)
- **Tablet** (480px+ width)
- **Both Orientations** (Portrait & Landscape)

All layouts use flexible and responsive containers.

---

## 🔐 Security Notes

### Current Implementation (Development)
- Mock authentication
- Local data storage
- No encryption
- Demo credentials visible

### Production Recommendations
1. Implement real authentication (Firebase, OAuth)
2. Add JWT token management
3. Encrypt sensitive data
4. Use secure storage (Keystore/Keychain)
5. Implement certificate pinning
6. Add API rate limiting
7. Regular security audits

---

## 📈 Performance Tips

1. **Avoid Rebuilds**: Use `const` constructors
2. **Lazy Loading**: Load data on demand
3. **Image Optimization**: Use cached network images
4. **Efficient Lists**: Use `ListView.builder`
5. **Memory Management**: Dispose controllers properly

---

## 🎨 Customization

### Change Theme Colors
Edit `/lib/src/core/theme/color_palette.dart`:
```dart
class AppColors {
  static const Color primaryBlack = Color(0xFF0A0E27);
  // ... change hex values
}
```

### Add New Role
1. Update `AuthApi.login()` with new credentials
2. Add role case in `app.dart._getDashboardForRole()`
3. Create role-specific dashboard

### Add New Page
1. Create file in appropriate `/pages/` folder
2. Implement StatefulWidget with `State`
3. Add to navigation/dashboard
4. Update routing if needed

---

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language](https://dart.dev)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design](https://material.io/design)

---

## 🤝 Contributing

1. Follow the existing code structure
2. Use meaningful variable names
3. Add comments for complex logic
4. Test all features before committing
5. Keep functions small and focused

---

## 📞 Support

For issues or questions:
1. Check this guide
2. Review the FEATURES_DOCUMENTATION.md
3. Check existing code for patterns
4. Test with different roles

---

**Happy Building with CampusConnect! 🎉**
