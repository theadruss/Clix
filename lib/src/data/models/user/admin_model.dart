// lib/src/data/models/user/admin_model.dart
import 'user_model.dart';

class AdminModel extends UserModel {
  final List<String> permissions;
  final String adminLevel; // 'super_admin', 'college_admin', 'department_admin'
  final List<String> managedDepartments;
  final DateTime lastLogin;

  AdminModel({
    required String id,
    required String email,
    required String name,
    required String role,
    String? profileImage,
    String? phoneNumber,
    String? collegeId,
    required DateTime createdAt,
    bool isEmailVerified = false,
    required this.permissions,
    required this.adminLevel,
    this.managedDepartments = const [],
    required this.lastLogin,
  }) : super(
          id: id,
          email: email,
          name: name,
          role: role,
          profileImage: profileImage,
          phoneNumber: phoneNumber,
          collegeId: collegeId,
          createdAt: createdAt,
          isEmailVerified: isEmailVerified,
        );

  factory AdminModel.fromUserModel(UserModel user, Map<String, dynamic> adminData) {
    return AdminModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      profileImage: user.profileImage,
      phoneNumber: user.phoneNumber,
      collegeId: user.collegeId,
      createdAt: user.createdAt,
      isEmailVerified: user.isEmailVerified,
      permissions: List<String>.from(adminData['permissions']),
      adminLevel: adminData['adminLevel'],
      managedDepartments: List<String>.from(adminData['managedDepartments'] ?? []),
      lastLogin: DateTime.parse(adminData['lastLogin']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'permissions': permissions,
      'adminLevel': adminLevel,
      'managedDepartments': managedDepartments,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  bool hasPermission(String permission) {
    return permissions.contains(permission) || permissions.contains('all');
  }

  bool canManageDepartment(String department) {
    return managedDepartments.isEmpty || managedDepartments.contains(department);
  }
}