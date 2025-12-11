import 'package:equatable/equatable.dart';

enum MessageType { text, image, voice, suggestion, action }
enum MessageSender { user, assistant, system }

class AiMessage extends Equatable {
  final String id;
  final String content;
  final MessageType type;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isLoading;
  final Map<String, dynamic>? metadata;
  final List<AiSuggestion>? suggestions;

  const AiMessage({
    required this.id,
    required this.content,
    this.type = MessageType.text,
    required this.sender,
    required this.timestamp,
    this.isLoading = false,
    this.metadata,
    this.suggestions,
  });

  AiMessage copyWith({String? content, bool? isLoading, List<AiSuggestion>? suggestions}) {
    return AiMessage(
      id: id, content: content ?? this.content, type: type, sender: sender,
      timestamp: timestamp, isLoading: isLoading ?? this.isLoading,
      metadata: metadata, suggestions: suggestions ?? this.suggestions,
    );
  }

  bool get isUser => sender == MessageSender.user;
  bool get isAssistant => sender == MessageSender.assistant;

  @override
  List<Object?> get props => [id, content, sender, timestamp];
}

class AiSuggestion extends Equatable {
  final String id;
  final String text;
  final String? icon;
  final Map<String, dynamic>? data;

  const AiSuggestion({required this.id, required this.text, this.icon, this.data});

  @override
  List<Object?> get props => [id, text];
}
