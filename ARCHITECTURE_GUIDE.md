# CampusConnect - Architecture & Navigation Guide

## 🏗️ Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      CampusConnect App                      │
│                    (main.dart → app.dart)                   │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────▼─────────┐
                    │   Auth Provider   │
                    │   & Login Page    │
                    └─────────┬─────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
    ┌────────────┐      ┌────────────┐      ┌────────────┐
    │   Admin    │      │  Student   │      │    Club    │
    │ Dashboard  │      │ Dashboard  │      │ Dashboard  │
    └────────────┘      └────────────┘      └────────────┘
        │                     │                     │
        ▼                     ▼                     ▼
    ┌─────────┐          ┌─────────┐         ┌─────────┐
    │         │          │         │         │         │
    │ Events  │          │ Events  │         │ Events  │
    │ Approval│          │ Browse  │         │Proposal │
    │         │          │         │         │         │
    └─────────┘          └─────────┘         └─────────┘
        │                     │                     │
    ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
    │   Analytics  │     │  Payment &   │     │  Volunteer   │
    │  & Reports   │     │  Feedback    │     │  Management  │
    │              │     │              │     │              │
    └──────────────┘     └──────────────┘     └──────────────┘
```

---

## 🧭 Navigation Flow

### Login → Role Detection → Dashboard Selection

```
┌────────────────┐
│  Login Page    │
│                │
│ [Demo Buttons] │
└────────┬───────┘
         │
    ┌────▼──────────────────────────────────┐
    │  Authenticate User                    │
    │  (AuthProvider.login())               │
    └────┬─────────────────────────────────┘
         │
    ┌────▼──────────────────────────────────┐
    │  Get User Role                        │
    │  (admin, student, coordinator, etc)  │
    └────┬─────────────────────────────────┘
         │
         ▼
    ┌─────────────────┬─────────────────┬──────────────┬─────────┬──────────────┐
    │                 │                 │              │         │              │
    ▼                 ▼                 ▼              ▼         ▼              ▼
  Admin         Student           Coordinator      Advisor   External
 Dashboard     Dashboard         Dashboard        Dashboard  Dashboard
```

---

## 📱 Screen Map

### Admin Flow
```
Login
  ↓
Admin Dashboard (Home)
  ├─ Event Approvals Tab
  │  ├─ All Events List
  │  ├─ Filter (Pending/Approved/Rejected)
  │  └─ Approval Detail Card
  │     ├─ [Approve] → Add to Events
  │     └─ [Reject]  → Update Status
  │
  ├─ Analytics Tab
  │  ├─ Event Participation Stats
  │  ├─ Club Engagement Chart
  │  ├─ Revenue Growth Graph
  │  └─ Export Reports
  │
  ├─ Users Tab
  │  ├─ User List
  │  ├─ [Approve User]
  │  └─ [Remove User]
  │
  └─ Settings Tab
     ├─ Email Templates
     ├─ Notification Preferences
     └─ System Parameters
```

### Student Flow
```
Login
  ↓
Student Dashboard (Home)
  ├─ Calendar View
  ├─ Featured Events
  ├─ Search Bar
  └─ Quick Actions
     
Events Tab
  ├─ Browse All Events
  ├─ Filter by Category
  ├─ Event Detail
  │  ├─ Description
  │  ├─ [Register] → Add to My Events
  │  ├─ [Interested] → Increase Count
  │  └─ [Volunteer] → Select Roles
  │
  └─ My Events
     ├─ Registered Events
     └─ [Pay if Needed] → Payment Page
        ├─ Select Payment Method
        ├─ Enter Card/UPI Details
        └─ [Confirm Payment] → Receipt
     
     └─ Past Events → [Rate Event] → Feedback Page
        ├─ 5-Star Rating
        ├─ Write Review
        ├─ Select Tags
        └─ [Submit Feedback]

Club Tab
  ├─ Browse Clubs
  ├─ Join Club
  └─ Club Details
     ├─ Members List
     └─ Upcoming Events

Notifications Tab
  ├─ All Notifications
  ├─ Filter by Type
  ├─ Mark as Read
  └─ Delete

Profile Tab
  ├─ User Info
  ├─ My Statistics
  ├─ My Events
  ├─ My Feedback
  └─ [Logout]
```

### Club Coordinator Flow
```
Login
  ↓
Club Dashboard (Home)
  ├─ Quick Stats
  ├─ Pending Approvals
  └─ Quick Actions
     
Proposals Tab
  ├─ [+ New Event] → Event Proposal Form
  │  ├─ Event Title
  │  ├─ Description
  │  ├─ Date & Time Selection
  │  ├─ Venue Selection
  │  ├─ Capacity
  │  ├─ Budget
  │  ├─ Volunteer Roles
  │  └─ [Submit] → MockDataService.pendingApprovals.add()
  │
  └─ My Proposals
     ├─ Submitted Events
     ├─ Filter by Status
     │  ├─ Pending Coordinator
     │  ├─ Pending Advisor
     │  ├─ Pending Admin
     │  └─ Approved/Rejected
     └─ Event Details with Feedback

Members Tab
  ├─ Member List
  ├─ [+ Add Member] → Selection Dialog
  ├─ Assign Roles
  │  ├─ Member
  │  ├─ Coordinator
  │  └─ Subgroup Head
  └─ [Remove Member]

Volunteers Tab
  ├─ Define Volunteer Roles
  ├─ Assign Volunteers
  ├─ Track Assignments
  └─ Generate Reports

Analytics Tab
  ├─ Member Engagement
  ├─ Event Performance
  ├─ Budget Tracking
  └─ [Export Report]
```

### Club Advisor Flow
```
Login
  ↓
Club Dashboard (Advisor View)
  ├─ Quick Stats
  ├─ Pending Approvals
  └─ Club Selection Dropdown
     
Approvals Tab
  ├─ Pending Proposals List
  └─ Proposal Card
     ├─ Event Details
     ├─ Budget Info
     ├─ [Request Changes] → Update Status
     └─ [Approve] → Forward to Admin

Budget Tab
  ├─ Budget Requests List
  ├─ [Approve] / [Reject] Budget
  └─ Budget Reports

Members Tab
  ├─ Club Members List
  ├─ Member Roles
  └─ Engagement Metrics

Analytics Tab
  ├─ Member Stats
  ├─ Event Performance
  └─ Reports
```

### External Organizer Flow
```
Login
  ↓
External Dashboard (Home)
  ├─ Quick Stats
  │  ├─ Active Events
  │  ├─ Registrations
  │  ├─ Revenue
  │  └─ Pending
  │
  ├─ [Submit New Event] → External Event Proposal
  │  ├─ Organization Details
  │  ├─ Event Information
  │  ├─ Contact Person
  │  ├─ Budget & Pricing
  │  ├─ Volunteer Needs
  │  └─ [Submit] → Admin Review
  │
  └─ Recent Activity List

Proposals Tab
  ├─ All Proposals
  ├─ Filter by Status
  │  ├─ Pending
  │  ├─ Approved
  │  └─ Rejected
  └─ Proposal Details with Feedback

Analytics Tab
  ├─ Total Registrations
  ├─ Revenue Generated
  ├─ Average Rating
  └─ Attendance Rate

Profile Tab
  ├─ Organization Info
  ├─ Contact Details
  ├─ Tax ID
  ├─ [Edit Profile]
  └─ [Logout]
```

---

## 🔄 Data Flow

### Event Registration Flow
```
Student Dashboard
      │
      ▼
Browse Events
      │
      ├─ Search/Filter
      │
      ▼
Event Detail Card
      │
      ├─ View Info
      │
      ├─ [Register] ─────────────┐
      │                          │
      ├─ [Interested] ───────────┤── MockDataService.events
      │                          │   [Update registration]
      └─ [Volunteer] ────────────┘
            │
            ▼
    Add to My Events
            │
            ▼ (if paid event)
    Payment Page
            │
      ┌─────┼─────┐
      │     │     │
      ▼     ▼     ▼
   Razorpay Stripe UPI
      │     │     │
      └─────┼─────┘
            │
            ▼
    PaymentGatewayService
            │
            ▼
    MockDataService.payments.add()
            │
            ▼
    Send Notification
            │
            ▼
    Show Confirmation
```

### Event Approval Workflow
```
Event Proposal Created
      │
      ▼
Coordinator Review
      │
      ├─ [Request Changes]
      │  └─ Status: pending_coordinator
      │
      └─ [Forward to Advisor]
         └─ Status: pending_advisor
            │
            ▼
         Advisor Review
            │
            ├─ [Request Changes]
            │  └─ Status: pending_advisor
            │
            └─ [Approve to Admin]
               └─ Status: pending_admin
                  │
                  ▼
               Admin Review
                  │
                  ├─ Check Venue Conflict
                  │  └─ If conflict → Show Dialog → Reject
                  │
                  ├─ [Reject]
                  │  └─ Status: rejected
                  │
                  └─ [Approve]
                     └─ Status: approved
                        │
                        ▼
                     Add to Events List
                        │
                        ▼
                     Send Notifications
                        │
                        ▼
                     Publish Event
```

### Feedback Submission Flow
```
Student Completes Event
      │
      ▼
"Rate Event" Button
      │
      ▼
Feedback Page
      │
      ├─ Select Rating (1-5 stars)
      ├─ Write Review
      ├─ Select Tags
      ├─ Toggle "Would Attend Again"
      │
      ▼
[Submit Feedback]
      │
      ▼
FeedbackModel Created
      │
      ▼
MockDataService.feedbacks.add()
      │
      ▼
Send Notification
      │
      ▼
Show Confirmation
```

---

## 🗄️ Data Storage (Mock Implementation)

```
MockDataService
├── List<Map> clubs
├── List<Map> events
├── List<Map> users
├── List<Map> pendingApprovals
├── List<Map> payments ──────────────── NEW
├── List<Map> feedbacks ──────────────── NEW
└── List<Map> approvalRequests
```

---

## 🎨 Widget Tree Structure

### Admin Dashboard
```
AdminDashboard (StatefulWidget)
├── Scaffold
│   ├── AppBar
│   ├── Body (IndexedStack)
│   │   ├─ _HomeTab
│   │   ├─ _ApprovalsTab
│   │   │  └─ ListView
│   │   │     └─ _ApprovalCard
│   │   │        ├─ Event Details
│   │   │        ├─ Status Badge
│   │   │        ├─ [Approve Button]
│   │   │        └─ [Reject Button]
│   │   │
│   │   ├─ _AnalyticsTab
│   │   │  └─ Column
│   │   │     ├─ _AnalyticsCard
│   │   │     ├─ _AnalyticsCard
│   │   │     └─ ...
│   │   │
│   │   └─ _SettingsTab
│   │
│   └── BottomNavigationBar
│       ├─ _BottomNavItem (Home)
│       ├─ _BottomNavItem (Approvals)
│       ├─ _BottomNavItem (Analytics)
│       └─ _BottomNavItem (Settings)
```

### Student Dashboard
```
StudentDashboard (StatefulWidget)
├── Scaffold
│   ├── Body (IndexedStack)
│   │   ├─ _HomeContent
│   │   ├─ EventsPage
│   │   ├─ ClubPage
│   │   └─ ProfilePage
│   │
│   └── BottomNavigationBar
│       ├─ Home
│       ├─ Events
│       ├─ Club
│       └─ Profile
```

### Payment Page
```
PaymentPage (StatefulWidget)
├── Scaffold
│   ├── AppBar
│   ├── Body (SingleChildScrollView)
│   │   └─ Column
│   │      ├─ Order Summary Card
│   │      ├─ Payment Method Selection
│   │      │  └─ ListView
│   │      │     └─ _PaymentMethodCard (x3)
│   │      │        ├─ Icon
│   │      │        ├─ Name
│   │      │        ├─ Description
│   │      │        └─ CheckMark
│   │      │
│   │      ├─ Terms & Conditions
│   │      ├─ Security Info
│   │      ├─ [Pay Button]
│   │      └─ [Cancel Button]
```

### Feedback Page
```
EventFeedbackPage (StatefulWidget)
├── Scaffold
│   ├── AppBar
│   ├── Body (SingleChildScrollView)
│   │   └─ Form
│   │      ├─ Event Info Card
│   │      ├─ Star Rating (5 interactive icons)
│   │      ├─ Review TextFormField
│   │      ├─ Tag Selection (Wrap of Chips)
│   │      ├─ "Would Attend Again" Toggle
│   │      ├─ [Submit Button]
│   │      └─ [Skip Button]
```

### Notifications Page
```
NotificationsPage (StatefulWidget)
├── Scaffold
│   ├── AppBar
│   ├── Filter Tabs (Row)
│   │   ├─ _FilterChip (All)
│   │   ├─ _FilterChip (Unread)
│   │   ├─ _FilterChip (Events)
│   │   ├─ _FilterChip (Approvals)
│   │   └─ _FilterChip (Payments)
│   │
│   └── Notifications List (Expanded)
│       └─ ListView
│          └─ Dismissible (Swipe to Delete)
│             └─ _NotificationItem
│                ├─ Icon
│                ├─ Title & Message
│                ├─ Timestamp
│                ├─ Unread Badge
│                └─ PopupMenu
```

---

## 🔐 Authentication Flow

```
User Input (Email/Password)
      │
      ▼
AuthProvider.login()
      │
      ▼
AuthApi.login() (Mock)
      │
      ├─ Validate Credentials
      │  └─ Check Against Demo Accounts
      │
      ├─ Match Found
      │  └─ Return UserModel
      │
      └─ No Match
         └─ Throw Exception
               │
               ▼
               Show Error Dialog
      
      ├─ Success
      │  ├─ Store User in Provider
      │  ├─ Notify Listeners
      │  └─ App Rebuilds (Consumer<AuthProvider>)
      │     └─ _getDashboardForRole(role)
      │
      └─ Get User Role
         └─ Route to Appropriate Dashboard
```

---

## 🎯 State Management

### Provider Pattern Usage

```
AuthProvider (ChangeNotifier)
├── _user: UserModel?
├── _isLoading: bool
├── _error: String?
│
├── Getters
│   ├── user
│   ├── isLoading
│   ├── error
│   └── isLoggedIn
│
└── Methods
    ├── login(email, password)
    ├── logout()
    └── register(userData)
         │
         ▼
    notifyListeners() → Rebuilds Consumers
```

---

## 📊 Database Schema (Mock)

```
User {
  id: String
  email: String
  name: String
  role: String ('admin'|'student'|'coordinator'|'advisor'|'external')
  profileImage: String?
  phoneNumber: String?
  collegeId: String?
  createdAt: DateTime
  isEmailVerified: bool
}

Event {
  id: String
  title: String
  description: String
  club: String
  date: String
  time: String
  venue: String
  capacity: int
  registeredCount: int
  status: String ('pending'|'approved'|'rejected')
  imageUrl: String
  fee: double?
  category: String
  needsVolunteers: bool
  volunteerRoles: List<String>
}

Approval {
  id: String
  title: String
  club: String
  submittedBy: String
  date: String
  venue: String
  capacity: int
  budget: double
  status: String
  description: String?
  startTime: String?
  endTime: String?
  category: String?
}

Payment {
  id: String
  eventId: String
  userId: String
  eventTitle: String
  amount: double
  paymentMethod: String ('razorpay'|'stripe'|'upi')
  status: String ('pending'|'completed'|'failed'|'refunded')
  transactionId: String?
  createdAt: DateTime
  completedAt: DateTime?
  refundId: String?
  receiptUrl: String?
}

Feedback {
  id: String
  eventId: String
  userId: String
  userName: String
  rating: int (1-5)
  review: String
  tags: List<String>
  helpfulCount: int
  wouldAttendAgain: bool
  createdAt: DateTime
  updatedAt: DateTime?
}

Notification {
  id: String
  userId: String
  title: String
  message: String
  type: String ('event'|'approval'|'payment'|'system'|'feedback')
  relatedId: String?
  isRead: bool
  createdAt: DateTime
  actionUrl: String?
}
```

---

## 🚀 Navigation Enhancements

### Recommended Next Steps for Navigation
1. Implement named routes in `RouteGenerator`
2. Add GoRouter for advanced navigation
3. Implement deep linking support
4. Add back button handlers

---

This architecture document provides a complete visual understanding of how CampusConnect flows and is structured.
