import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String type;
  final String priority;
  final String status;
  final String? fieldId;
  final String? fieldName;
  final String? assignedToId;
  final String? assignedToName;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final List<String>? tags;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.priority = 'medium',
    this.status = 'pending',
    this.fieldId,
    this.fieldName,
    this.assignedToId,
    this.assignedToName,
    this.dueDate,
    this.completedAt,
    this.createdAt,
    this.tags,
  });

  @override
  List<Object?> get props => [id];

  bool get isOverdue => dueDate != null && 
    DateTime.now().isAfter(dueDate!) && 
    status != 'completed';

  bool get isCompleted => status == 'completed';

  String get typeArabic {
    switch (type.toLowerCase()) {
      case 'irrigation': return 'ري';
      case 'fertilization': return 'تسميد';
      case 'pest_control': return 'مكافحة آفات';
      case 'harvesting': return 'حصاد';
      case 'planting': return 'زراعة';
      case 'maintenance': return 'صيانة';
      case 'inspection': return 'فحص';
      default: return type;
    }
  }

  String get priorityArabic {
    switch (priority.toLowerCase()) {
      case 'urgent': return 'عاجل';
      case 'high': return 'عالية';
      case 'medium': return 'متوسطة';
      case 'low': return 'منخفضة';
      default: return priority;
    }
  }

  String get statusArabic {
    switch (status.toLowerCase()) {
      case 'pending': return 'قيد الانتظار';
      case 'in_progress': return 'قيد التنفيذ';
      case 'completed': return 'مكتملة';
      case 'cancelled': return 'ملغية';
      default: return status;
    }
  }
}
