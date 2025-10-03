class UserEntity {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? profileImage;
  final String? phoneNumber;
  final String? collegeId;
  final DateTime createdAt;
  final bool isEmailVerified;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    this.phoneNumber,
    this.collegeId,
    required this.createdAt,
    this.isEmailVerified = false,
  });

  factory UserEntity.fromModel(Map<String, dynamic> model) {
    return UserEntity(
      id: model['id'],
      email: model['email'],
      name: model['name'],
      role: model['role'],
      profileImage: model['profileImage'],
      phoneNumber: model['phoneNumber'],
      collegeId: model['collegeId'],
      createdAt: DateTime.parse(model['createdAt']),
      isEmailVerified: model['isEmailVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'profileImage': profileImage,
      'phoneNumber': phoneNumber,
      'collegeId': collegeId,
      'createdAt': createdAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
    };
  }
}