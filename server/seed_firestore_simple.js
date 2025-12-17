// Firestore seeding script - reads from file
const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Load service account from JSON file
const serviceAccountPath = path.join(__dirname, 'service-account-key.json');
if (!fs.existsSync(serviceAccountPath)) {
  console.error('ERROR: service-account-key.json not found in server folder');
  process.exit(1);
}

const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

// Sample data
const users = [
  {
    id: 'student_001',
    email: 'student1@example.com',
    name: 'Alice Johnson',
    role: 'student',
    createdAt: new Date('2024-01-15'),
  },
  {
    id: 'student_002',
    email: 'student2@example.com',
    name: 'Bob Smith',
    role: 'student',
    createdAt: new Date('2024-02-10'),
  },
  {
    id: 'student_003',
    email: 'student3@example.com',
    name: 'Carol Davis',
    role: 'student',
    createdAt: new Date('2024-03-05'),
  },
  {
    id: 'advisor_001',
    email: 'advisor1@example.com',
    name: 'Prof. Emily Wilson',
    role: 'advisor',
    createdAt: new Date('2023-08-20'),
  },
  {
    id: 'advisor_002',
    email: 'advisor2@example.com',
    name: 'Dr. Michael Brown',
    role: 'advisor',
    createdAt: new Date('2023-09-15'),
  },
  {
    id: 'admin_001',
    email: 'admin@example.com',
    name: 'Dr. Principal Admin',
    role: 'admin',
    createdAt: new Date('2023-01-01'),
  },
];

const clubs = [
  {
    id: 'club_001',
    name: 'Computer Society',
    description: 'Technology and programming enthusiasts community. We organize hackathons, workshops, and tech talks.',
    imageUrl: 'https://picsum.photos/200/200?random=1',
    memberCount: 150,
    upcomingEvents: 3,
    subgroups: ['Web Development', 'Mobile Development', 'AI/ML'],
    createdAt: new Date('2023-08-10'),
    advisorId: 'advisor_001',
  },
  {
    id: 'club_002',
    name: 'Cultural Committee',
    description: 'Promoting arts and cultural activities across campus',
    imageUrl: 'https://picsum.photos/200/200?random=2',
    memberCount: 200,
    upcomingEvents: 5,
    subgroups: ['Dance', 'Music', 'Drama', 'Fine Arts'],
    createdAt: new Date('2023-07-15'),
    advisorId: 'advisor_002',
  },
  {
    id: 'club_003',
    name: 'Entrepreneurship Cell',
    description: 'Fostering innovation and startup culture among students',
    imageUrl: 'https://picsum.photos/200/200?random=3',
    memberCount: 120,
    upcomingEvents: 2,
    subgroups: ['Startup Incubation', 'Business Development', 'Marketing'],
    createdAt: new Date('2023-09-01'),
    advisorId: 'advisor_001',
  },
];

const events = [
  {
    id: 'event_001',
    title: 'Tech Symposium 2024',
    club: 'Computer Society',
    clubId: 'club_001',
    date: '2024-10-15',
    time: '2:00 PM - 5:00 PM',
    venue: 'Auditorium',
    description: 'Annual technology conference featuring industry experts and student projects. Explore cutting-edge technologies and network with professionals.',
    imageUrl: 'https://picsum.photos/400/200?random=1',
    status: 'approved',
    category: 'Technology',
    fee: 0,
    capacity: 200,
    registeredCount: 45,
    interestedCount: 124,
    needsVolunteers: true,
    volunteerRoles: ['Registration', 'Technical Support', 'Stage Management'],
    createdAt: new Date('2024-08-20'),
    createdBy: 'advisor_001',
  },
  {
    id: 'event_002',
    title: 'Cultural Fest Auditions',
    club: 'Cultural Committee',
    clubId: 'club_002',
    date: '2024-10-18',
    time: '4:00 PM - 7:00 PM',
    venue: 'Arts Block',
    description: 'Annual cultural fest auditions for dance, music and drama performances. Showcase your talent and win exciting prizes!',
    imageUrl: 'https://picsum.photos/400/200?random=2',
    status: 'approved',
    category: 'Cultural',
    fee: 50,
    capacity: 150,
    registeredCount: 32,
    interestedCount: 89,
    needsVolunteers: true,
    volunteerRoles: ['Stage Management', 'Crowd Control', 'Setup'],
    createdAt: new Date('2024-08-15'),
    createdBy: 'advisor_002',
  },
  {
    id: 'event_003',
    title: 'Web Development Workshop',
    club: 'Computer Society',
    clubId: 'club_001',
    date: '2024-10-22',
    time: '3:00 PM - 5:30 PM',
    venue: 'Lab Building - Room 301',
    description: 'Learn modern web development with React and Node.js. Hands-on workshop for beginners and intermediate developers.',
    imageUrl: 'https://picsum.photos/400/200?random=3',
    status: 'approved',
    category: 'Technology',
    fee: 200,
    capacity: 60,
    registeredCount: 28,
    interestedCount: 55,
    needsVolunteers: false,
    volunteerRoles: [],
    createdAt: new Date('2024-09-01'),
    createdBy: 'advisor_001',
  },
  {
    id: 'event_004',
    title: 'Startup Pitch Competition',
    club: 'Entrepreneurship Cell',
    clubId: 'club_003',
    date: '2024-10-25',
    time: '10:00 AM - 1:00 PM',
    venue: 'Conference Hall',
    description: 'Pitch your innovative startup idea to investors and industry mentors. Win seed funding and mentorship!',
    imageUrl: 'https://picsum.photos/400/200?random=4',
    status: 'pending',
    category: 'Business',
    fee: 100,
    capacity: 100,
    registeredCount: 15,
    interestedCount: 42,
    needsVolunteers: true,
    volunteerRoles: ['Registration', 'Time Management', 'Logistics'],
    createdAt: new Date('2024-08-25'),
    createdBy: 'advisor_001',
  },
  {
    id: 'event_005',
    title: 'AI/ML Bootcamp - Batch 1',
    club: 'Computer Society',
    clubId: 'club_001',
    date: '2024-11-01',
    time: '2:00 PM - 4:00 PM',
    venue: 'Data Science Lab',
    description: '4-week intensive bootcamp covering machine learning fundamentals, deep learning, and practical projects.',
    imageUrl: 'https://picsum.photos/400/200?random=5',
    status: 'approved',
    category: 'Technology',
    fee: 500,
    capacity: 40,
    registeredCount: 22,
    interestedCount: 78,
    needsVolunteers: false,
    volunteerRoles: [],
    createdAt: new Date('2024-09-05'),
    createdBy: 'advisor_001',
  },
];

const proposals = [
  {
    id: 'proposal_001',
    title: 'AI Workshop Series',
    clubId: 'club_001',
    clubName: 'Computer Society',
    submittedBy: 'student_001',
    submittedDate: new Date('2024-10-10'),
    type: 'event',
    status: 'pending_review',
    budget: 5000,
    expectedParticipants: 100,
    description: 'A comprehensive series of workshops covering AI/ML basics, advanced topics, and industry applications.',
    advisorId: 'advisor_001',
  },
  {
    id: 'proposal_002',
    title: 'Dance Competition',
    clubId: 'club_002',
    clubName: 'Cultural Committee',
    submittedBy: 'student_002',
    submittedDate: new Date('2024-10-09'),
    type: 'event',
    status: 'advisor_approved',
    budget: 3000,
    expectedParticipants: 150,
    description: 'Inter-college dance competition with prizes and certificates for winners.',
    advisorId: 'advisor_002',
  },
  {
    id: 'proposal_003',
    title: 'Tech Fest 2024',
    clubId: 'club_001',
    clubName: 'Computer Society',
    submittedBy: 'student_001',
    submittedDate: new Date('2024-10-05'),
    type: 'event',
    status: 'rejected',
    budget: 10000,
    expectedParticipants: 500,
    description: 'Large-scale technology festival with multiple events and competitions.',
    rejectionReason: 'Budget exceeds allocated quota. Please revise and resubmit.',
    advisorId: 'advisor_001',
  },
];

const payments = [
  {
    id: 'payment_001',
    eventId: 'event_002',
    eventTitle: 'Cultural Fest Auditions',
    userId: 'student_001',
    userName: 'Alice Johnson',
    amount: 50,
    paymentMethod: 'razorpay',
    status: 'completed',
    transactionId: 'TXN-2024101801',
    createdAt: new Date('2024-10-18'),
    completedAt: new Date('2024-10-18'),
  },
  {
    id: 'payment_002',
    eventId: 'event_003',
    eventTitle: 'Web Development Workshop',
    userId: 'student_002',
    userName: 'Bob Smith',
    amount: 200,
    paymentMethod: 'paypal',
    status: 'completed',
    transactionId: 'TXN-2024102202',
    createdAt: new Date('2024-10-22'),
    completedAt: new Date('2024-10-22'),
  },
  {
    id: 'payment_003',
    eventId: 'event_005',
    eventTitle: 'AI/ML Bootcamp - Batch 1',
    userId: 'student_003',
    userName: 'Carol Davis',
    amount: 500,
    paymentMethod: 'razorpay',
    status: 'completed',
    transactionId: 'TXN-2024110103',
    createdAt: new Date('2024-11-01'),
    completedAt: new Date('2024-11-01'),
  },
];

async function seedFirestore() {
  try {
    console.log('🌱 Starting Firestore seeding...\n');

    // Seed users
    console.log('📝 Seeding users collection...');
    for (const user of users) {
      await db.collection('users').doc(user.id).set(user);
    }
    console.log(`✅ Created ${users.length} users\n`);

    // Seed clubs
    console.log('🏢 Seeding clubs collection...');
    for (const club of clubs) {
      await db.collection('clubs').doc(club.id).set(club);
    }
    console.log(`✅ Created ${clubs.length} clubs\n`);

    // Seed events
    console.log('🎉 Seeding events collection...');
    for (const event of events) {
      await db.collection('events').doc(event.id).set(event);
    }
    console.log(`✅ Created ${events.length} events\n`);

    // Seed proposals
    console.log('📋 Seeding proposals collection...');
    for (const proposal of proposals) {
      await db.collection('proposals').doc(proposal.id).set(proposal);
    }
    console.log(`✅ Created ${proposals.length} proposals\n`);

    // Seed payments
    console.log('💳 Seeding payments collection...');
    for (const payment of payments) {
      await db.collection('payments').doc(payment.id).set(payment);
    }
    console.log(`✅ Created ${payments.length} payments\n`);

    // Create registrations as subcollections
    console.log('📌 Creating event registrations...');
    await db.collection('events').doc('event_001').collection('registrations').doc('student_001').set({
      registeredAt: new Date('2024-10-13'),
    });
    await db.collection('events').doc('event_001').collection('registrations').doc('student_002').set({
      registeredAt: new Date('2024-10-14'),
    });
    await db.collection('events').doc('event_002').collection('registrations').doc('student_001').set({
      registeredAt: new Date('2024-10-16'),
    });
    console.log('✅ Created event registrations\n');

    // Create club memberships as subcollections
    console.log('👥 Creating club memberships...');
    await db.collection('clubs').doc('club_001').collection('members').doc('student_001').set({
      role: 'member',
      joinedAt: new Date('2024-09-01'),
    });
    await db.collection('clubs').doc('club_001').collection('members').doc('student_002').set({
      role: 'member',
      joinedAt: new Date('2024-09-05'),
    });
    await db.collection('clubs').doc('club_001').collection('members').doc('advisor_001').set({
      role: 'advisor',
      joinedAt: new Date('2023-08-10'),
    });
    console.log('✅ Created club memberships\n');

    console.log('🎉 Firestore seeding completed successfully!');
    console.log('\n📊 Summary:');
    console.log(`  • Users: ${users.length}`);
    console.log(`  • Clubs: ${clubs.length}`);
    console.log(`  • Events: ${events.length}`);
    console.log(`  • Proposals: ${proposals.length}`);
    console.log(`  • Payments: ${payments.length}`);
    console.log('\n💡 You can now fetch data from Firestore in your Flutter app!');
  } catch (error) {
    console.error('❌ Error seeding Firestore:', error);
    process.exit(1);
  } finally {
    process.exit(0);
  }
}

seedFirestore();
