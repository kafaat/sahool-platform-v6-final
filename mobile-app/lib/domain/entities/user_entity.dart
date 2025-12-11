import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String role;
  final bool isVerified;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.role = 'user',
    this.isVerified = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, email];

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String get roleArabic {
    switch (role) {
      case 'admin': return 'مدير';
      case 'manager': return 'مشرف';
      case 'farmer': return 'مزارع';
      case 'technician': return 'فني';
      default: return 'مستخدم';
    }
  }
}
