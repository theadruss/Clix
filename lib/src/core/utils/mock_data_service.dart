class MockDataService {
  static final List<Map<String, dynamic>> clubs = [
    {
      'id': '1',
      'name': 'Computer Society',
      'description': 'Technology and programming enthusiasts community. We organize hackathons, workshops, and tech talks.',
      'imageUrl': 'https://picsum.photos/200/200?random=1',
      'memberCount': 150,
      'upcomingEvents': 3,
      'isMember': true,
      'userRole': 'member', // member, coordinator, subgroup_head
      'subgroups': ['Web Development', 'Mobile Development', 'AI/ML'],
    },
    {
      'id': '2', 
      'name': 'Cultural Committee',
      'description': 'Promoting arts and cultural activities across campus',
      'imageUrl': 'https://picsum.photos/200/200?random=2',
      'memberCount': 200,
      'upcomingEvents': 5,
      'isMember': false,
      'userRole': 'advisor',
      'subgroups': ['Dance', 'Music', 'Drama', 'Fine Arts'],
    },
    {
      'id': '3',
      'name': 'Entrepreneurship Cell',
      'description': 'Fostering innovation and startup culture among students',
      'imageUrl': 'https://picsum.photos/200/200?random=3',
      'memberCount': 120,
      'upcomingEvents': 2,
      'isMember': true,
      'userRole': 'coordinator',
      'subgroups': ['Startup Incubation', 'Business Development', 'Marketing'],
    },
  ];

  static final List<Map<String, dynamic>> events = [
    {
      'id': '1',
      'title': 'Tech Symposium 2024',
      'club': 'Computer Society',
      'date': 'Oct 15, 2024',
      'time': '2:00 PM - 5:00 PM',
      'venue': 'Auditorium',
      'description': 'Annual technology conference featuring industry experts and student projects',
      'interestedCount': 124,
      'imageUrl': 'https://picsum.photos/400/200?random=1',
      'status': 'approved',
      'category': 'Technology',
      'isRegistered': false,
      'needsVolunteers': true,
      'volunteerRoles': ['Registration', 'Technical Support'],
    },
    {
      'id': '2',
      'title': 'Cultural Fest Auditions',
      'club': 'Cultural Committee',
      'date': 'Oct 18, 2024',
      'time': '4:00 PM - 7:00 PM',
      'venue': 'Arts Block',
      'description': 'Annual cultural fest auditions for dance, music and drama performances',
      'interestedCount': 89,
      'imageUrl': 'https://picsum.photos/400/200?random=2',
      'status': 'approved',
      'category': 'Cultural',
      'isRegistered': true,
      'needsVolunteers': true,
      'volunteerRoles': ['Stage Management', 'Crowd Control'],
    },
  ];

  // Admin data
  static final List<Map<String, dynamic>> pendingApprovals = [
    {
      'id': 'a1',
      'title': 'AI Workshop Series',
      'club': 'Computer Society',
      'submittedBy': 'John Doe',
      'submittedDate': '2024-10-10',
      'type': 'event',
      'budget': 5000,
      'expectedParticipants': 100,
    },
    {
      'id': 'a2',
      'title': 'Dance Competition',
      'club': 'Cultural Committee',
      'submittedBy': 'Jane Smith',
      'submittedDate': '2024-10-09',
      'type': 'event',
      'budget': 3000,
      'expectedParticipants': 150,
    },
  ];

  static final Map<String, dynamic> adminStats = {
    'totalEvents': 45,
    'pendingApprovals': 8,
    'activeClubs': 12,
    'totalStudents': 2500,
    'revenue': 12500,
  };

  static void registerForEvent(String eventId) {
    final event = events.firstWhere((e) => e['id'] == eventId);
    event['isRegistered'] = true;
    event['interestedCount'] = (event['interestedCount'] as int) + 1;
  }

  static void unregisterFromEvent(String eventId) {
    final event = events.firstWhere((e) => e['id'] == eventId);
    event['isRegistered'] = false;
    event['interestedCount'] = (event['interestedCount'] as int) - 1;
  }

  static void joinClub(String clubId, [String role = 'member']) {
    final club = clubs.firstWhere((c) => c['id'] == clubId);
    club['isMember'] = true;
    club['userRole'] = role;
    club['memberCount'] = (club['memberCount'] as int) + 1;
  }

  static void leaveClub(String clubId) {
    final club = clubs.firstWhere((c) => c['id'] == clubId);
    club['isMember'] = false;
    club['userRole'] = null;
    club['memberCount'] = (club['memberCount'] as int) - 1;
  }

  static void updateUserRole(String clubId, String role) {
    final club = clubs.firstWhere((c) => c['id'] == clubId);
    club['userRole'] = role;
  }

  static List<Map<String, dynamic>> getClubsForUser() {
    return clubs;
  }

  static List<Map<String, dynamic>> getEventsForUser() {
    return events;
  }

  static List<Map<String, dynamic>> searchEvents(String query) {
    if (query.isEmpty) return events;
    
    return events.where((event) {
      return event['title'].toLowerCase().contains(query.toLowerCase()) ||
             event['club'].toLowerCase().contains(query.toLowerCase()) ||
             event['description'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<Map<String, dynamic>> searchClubs(String query) {
    if (query.isEmpty) return clubs;
    
    return clubs.where((club) {
      return club['name'].toLowerCase().contains(query.toLowerCase()) ||
             club['description'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static String getUserRoleDisplayName(String role) {
    switch (role) {
      case 'member':
        return 'Club Member';
      case 'coordinator':
        return 'Club Coordinator';
      case 'subgroup_head':
        return 'Subgroup Head';
      case 'advisor':
        return 'Club Advisor';
      default:
        return 'Member';
    }
  }

  // Add these methods to the MockDataService class

static List<Map<String, dynamic>> getClubsForAdvisor() {
  return clubs.where((club) => club['userRole'] == 'advisor').toList();
}

static List<Map<String, dynamic>> getAdvisorReports(String clubId) {
  return [
    {
      'id': 'r1',
      'title': 'Monthly Activity Report',
      'clubId': clubId,
      'period': 'October 2024',
      'generatedDate': '2024-10-25',
      'metrics': {
        'eventsHeld': 3,
        'newMembers': 15,
        'attendanceRate': '78%',
        'budgetUsed': '\$1,200',
      },
    },
    {
      'id': 'r2',
      'title': 'Budget Utilization Report',
      'clubId': clubId,
      'period': 'Q3 2024',
      'generatedDate': '2024-10-20',
      'metrics': {
        'totalBudget': '\$5,000',
        'usedBudget': '\$3,200',
        'remainingBudget': '\$1,800',
        'utilizationRate': '64%',
      },
    },
  ];
}

static Map<String, dynamic> getClubAnalytics(String clubId) {
  final club = clubs.firstWhere((c) => c['id'] == clubId);
  return {
    'clubId': clubId,
    'clubName': club['name'],
    'totalMembers': club['memberCount'],
    'activeMembers': (club['memberCount'] * 0.7).round(),
    'eventsThisMonth': 3,
    'upcomingEvents': club['upcomingEvents'],
    'attendanceRate': '78%',
    'budgetUtilization': '64%',
    'memberGrowth': '+12%',
  };
}

static List<Map<String, dynamic>> getPendingApprovalsForAdvisor(String clubId) {
  return [
    {
      'id': 'pa1',
      'title': 'New Event Proposal - AI Workshop',
      'clubId': clubId,
      'submittedBy': 'Student Coordinator',
      'submittedDate': '2024-10-24',
      'type': 'event',
      'budget': 1500,
      'status': 'pending_review',
    },
    {
      'id': 'pa2',
      'title': 'Budget Increase Request',
      'clubId': clubId,
      'submittedBy': 'Treasurer',
      'submittedDate': '2024-10-23',
      'type': 'budget',
      'amount': 2000,
      'status': 'pending_review',
    },
  ];
}

  // Feedback and ratings
  static final List<Map<String, dynamic>> feedbacks = [];

  // Payments
  static final List<Map<String, dynamic>> payments = [];
}