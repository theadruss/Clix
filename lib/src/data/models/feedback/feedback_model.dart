// Feedback and ratings model for events
class FeedbackModel {
  final String id;
  final String eventId;
  final String userId;
  final String userName;
  final int rating; // 1-5 stars
  final String review;
  final List<String> tags; // 'organization', 'venue', 'content', 'speakers', etc.
  final int helpfulCount;
  final bool wouldAttendAgain;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FeedbackModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.review,
    this.tags = const [],
    this.helpfulCount = 0,
    this.wouldAttendAgain = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      eventId: json['eventId'],
      userId: json['userId'],
      userName: json['userName'],
      rating: json['rating'],
      review: json['review'],
      tags: List<String>.from(json['tags'] ?? []),
      helpfulCount: json['helpfulCount'] ?? 0,
      wouldAttendAgain: json['wouldAttendAgain'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'review': review,
      'tags': tags,
      'helpfulCount': helpfulCount,
      'wouldAttendAgain': wouldAttendAgain,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  double getAverageRating() => rating.toDouble();

  bool hasReview() => review.isNotEmpty;
}
