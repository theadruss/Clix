class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? profileImage;
  final String? phoneNumber;
  final String? collegeId;
  final DateTime createdAt;
  final bool isEmailVerified;

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      profileImage: json['profileImage'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      collegeId: json['collegeId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
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

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? profileImage,
    String? phoneNumber,
    String? collegeId,
    DateTime? createdAt,
    bool? isEmailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      collegeId: collegeId ?? this.collegeId,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  // Utility Methods
  bool get isStudent => role == 'student';
  bool get isProfessor => role == 'professor';
  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator';

  String get displayName {
    if (name.trim().isEmpty) return email.split('@').first;
    return name;
  }

  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;

  // Empty factory constructor
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      name: '',
      role: 'student',
      createdAt: DateTime.now(),
      isEmailVerified: false,
    );
  }

  // Equality support
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, role: $role)';
  }
}

// Optional: UserRole enum for type safety
enum UserRole { student, professor, admin, moderator }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.professor:
        return 'professor';
      case UserRole.admin:
        return 'admin';
      case UserRole.moderator:
        return 'moderator';
    }
  }

  static UserRole fromString(String role) {
    switch (role) {
      case 'student':
        return UserRole.student;
      case 'professor':
        return UserRole.professor;
      case 'admin':
        return UserRole.admin;
      case 'moderator':
        return UserRole.moderator;
      default:
        return UserRole.student;
    }
  }
}