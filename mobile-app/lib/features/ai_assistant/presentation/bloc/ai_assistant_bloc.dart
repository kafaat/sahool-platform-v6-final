import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/offline/offline_helper.dart';
import '../../../../domain/entities/ai_message_entity.dart';

abstract class AiAssistantEvent extends Equatable {
  const AiAssistantEvent();
  @override
  List<Object?> get props => [];
}

class AiAssistantHistoryRequested extends AiAssistantEvent {
  const AiAssistantHistoryRequested();
}

class AiAssistantMessageSent extends AiAssistantEvent {
  final String content;
  const AiAssistantMessageSent(this.content);

  @override
  List<Object?> get props => [content];
}

class AiAssistantSuggestionTapped extends AiAssistantEvent {
  final String content;
  const AiAssistantSuggestionTapped(this.content);

  @override
  List<Object?> get props => [content];
}

class AiAssistantContextAttached extends AiAssistantEvent {
  const AiAssistantContextAttached(this.contextPayload);

  final Map<String, dynamic> contextPayload;

  @override
  List<Object?> get props => [contextPayload];
}

class AiAssistantState extends Equatable {
  final List<AiMessageEntity> messages;
  final bool isSending;
  final String? error;

  const AiAssistantState({
    required this.messages,
    this.isSending = false,
    this.error,
  });

  AiAssistantState copyWith({
    List<AiMessageEntity>? messages,
    bool? isSending,
    String? error,
  }) {
    return AiAssistantState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isSending, error ?? ''];
}

class AiAssistantBloc extends Bloc<AiAssistantEvent, AiAssistantState> {
  AiAssistantBloc() : super(const AiAssistantState(messages: [])) {
    on<AiAssistantHistoryRequested>(_onHistoryRequested);
    on<AiAssistantMessageSent>(_onMessageSent);
    on<AiAssistantSuggestionTapped>(_onSuggestionTapped);
    on<AiAssistantContextAttached>(_onContextAttached);
  }

  Future<void> _onHistoryRequested(
    AiAssistantHistoryRequested event,
    Emitter<AiAssistantState> emit,
  ) async {
    final raw = OfflineHelper.loadAiMessages();
    final history = raw
        .map((e) => AiMessageEntity.fromJson(e))
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    emit(state.copyWith(messages: history));
  }

  Future<void> _onMessageSent(
    AiAssistantMessageSent event,
    Emitter<AiAssistantState> emit,
  ) async {
    final text = event.content.trim();
    if (text.isEmpty) return;

    final userMessage = AiMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isUser: true,
      createdAt: DateTime.now(),
    );

    final updated = List<AiMessageEntity>.from(state.messages)..add(userMessage);
    emit(state.copyWith(messages: updated, isSending: true, error: null));
    await _persist(updated);

    await Future.delayed(const Duration(milliseconds: 900));

    final reply = AiMessageEntity(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: _generateSmartReply(text),
      isUser: false,
      createdAt: DateTime.now(),
    );

    final finalMessages = List<AiMessageEntity>.from(updated)..add(reply);
    await _persist(finalMessages);
    emit(state.copyWith(messages: finalMessages, isSending: false));
  }

  Future<void> _onSuggestionTapped(
    AiAssistantSuggestionTapped event,
    Emitter<AiAssistantState> emit,
  ) async {
    add(AiAssistantMessageSent(event.content));
  }

  Future<void> _persist(List<AiMessageEntity> messages) async {
    final jsonList = messages.map((m) => m.toJson()).toList();
    await OfflineHelper.saveAiMessages(jsonList);
  }

  String _generateSmartReply(String prompt) {
    final lower = prompt.toLowerCase();

    if (lower.contains('ndvi') || lower.contains('ن د ف آي')) {
      return 'تحليل NDVI يشير إلى تباين في حيوية الغطاء النباتي داخل الحقل. '
          'ركز على المناطق منخفضة المؤشر وراجع الري أو التسميد فيها.';
    }
    if (lower.contains('irrigation') || lower.contains('ري')) {
      return 'يفضّل ربط جداول الري برطوبة التربة والتنبؤات المناخية. '
          'استخدم بيانات الطقس والتربة في سهول لضبط أوقات وكميات الري.';
    }
    if (lower.contains('fertilizer') || lower.contains('سماد')) {
      return 'برنامج التسميد الأمثل يعتمد على نوع المحصول وعمره وتحليل التربة. '
          'أضف هذه البيانات في بطاقة الحقل للحصول على توصية أدق من النظام.';
    }
    if (lower.contains('astral') || lower.contains('فلك') || lower.contains('طالع')) {
      return 'التقويم الزراعي الفلكي في سهول يربط منازل القمر والطوالع بمواسم الزراعة. '
          'يمكنك فتح شاشة التقويم الزراعي لمعرفة أنسب فترات الزراعة والري والتسميد.';
    }
    return 'تم استلام سؤالك ✅. يمكنك الربط بين NDVI والطقس والتربة والمهام اليومية '
        'للحصول على صورة شاملة عن حالة الحقل، وسأساعدك في تفسير النتائج واقتراح الخطوات التالية.';
  }
}
