import 'package:equatable/equatable.dart';

class AiMessageEntity extends Equatable {
  final String id;
  final String content;
  final bool isUser;
  final DateTime createdAt;

  const AiMessageEntity({
    required this.id,
    required this.content,
    required this.isUser,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, content, isUser, createdAt];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AiMessageEntity.fromJson(Map<String, dynamic> json) {
    return AiMessageEntity(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
