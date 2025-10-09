// lib/src/data/models/event/event_model.dart
class EventModel {
  final String id;
  final String title;
  final String description;
  final String clubId;
  final String clubName;
  final DateTime date;
  final String time;
  final String venue;
  final int capacity;
  final int registeredCount;
  final String status; // 'pending', 'approved', 'rejected'
  final String? imageUrl;
  final double? fee;
  final DateTime createdAt;
  final List<String> volunteerRoles;
  final bool needsVolunteers;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.clubId,
    required this.clubName,
    required this.date,
    required this.time,
    required this.venue,
    required this.capacity,
    required this.registeredCount,
    required this.status,
    this.imageUrl,
    this.fee,
    required this.createdAt,
    this.volunteerRoles = const [],
    this.needsVolunteers = false,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      clubId: json['clubId'],
      clubName: json['clubName'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      venue: json['venue'],
      capacity: json['capacity'],
      registeredCount: json['registeredCount'],
      status: json['status'],
      imageUrl: json['imageUrl'],
      fee: json['fee']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      volunteerRoles: List<String>.from(json['volunteerRoles'] ?? []),
      needsVolunteers: json['needsVolunteers'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'clubId': clubId,
      'clubName': clubName,
      'date': date.toIso8601String(),
      'time': time,
      'venue': venue,
      'capacity': capacity,
      'registeredCount': registeredCount,
      'status': status,
      'imageUrl': imageUrl,
      'fee': fee,
      'createdAt': createdAt.toIso8601String(),
      'volunteerRoles': volunteerRoles,
      'needsVolunteers': needsVolunteers,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? clubId,
    String? clubName,
    DateTime? date,
    String? time,
    String? venue,
    int? capacity,
    int? registeredCount,
    String? status,
    String? imageUrl,
    double? fee,
    DateTime? createdAt,
    List<String>? volunteerRoles,
    bool? needsVolunteers,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      clubId: clubId ?? this.clubId,
      clubName: clubName ?? this.clubName,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      capacity: capacity ?? this.capacity,
      registeredCount: registeredCount ?? this.registeredCount,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      fee: fee ?? this.fee,
      createdAt: createdAt ?? this.createdAt,
      volunteerRoles: volunteerRoles ?? this.volunteerRoles,
      needsVolunteers: needsVolunteers ?? this.needsVolunteers,
    );
  }
}