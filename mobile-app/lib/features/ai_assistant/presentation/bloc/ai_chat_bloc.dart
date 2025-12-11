import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/ai_message.dart';

// Events
abstract class AiChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AiChatStarted extends AiChatEvent {}

class AiChatMessageSent extends AiChatEvent {
  final String message;
  AiChatMessageSent(this.message);
  @override
  List<Object?> get props => [message];
}

class AiChatSuggestionTapped extends AiChatEvent {
  final AiSuggestion suggestion;
  AiChatSuggestionTapped(this.suggestion);
  @override
  List<Object?> get props => [suggestion];
}

class AiChatCleared extends AiChatEvent {}

// State
class AiChatState extends Equatable {
  final List<AiMessage> messages;
  final bool isTyping;
  final List<AiSuggestion> suggestions;
  final String? error;

  const AiChatState({
    this.messages = const [],
    this.isTyping = false,
    this.suggestions = const [],
    this.error,
  });

  AiChatState copyWith({
    List<AiMessage>? messages,
    bool? isTyping,
    List<AiSuggestion>? suggestions,
    String? error,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      suggestions: suggestions ?? this.suggestions,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isTyping, suggestions, error];
}

// BLoC
class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final _uuid = const Uuid();

  AiChatBloc() : super(const AiChatState()) {
    on<AiChatStarted>(_onStarted);
    on<AiChatMessageSent>(_onMessageSent);
    on<AiChatSuggestionTapped>(_onSuggestionTapped);
    on<AiChatCleared>(_onCleared);
  }

  void _onStarted(AiChatStarted event, Emitter<AiChatState> emit) {
    final welcomeMessage = AiMessage(
      id: _uuid.v4(),
      content: 'مرحباً! أنا مساعدك الزراعي الذكي من سهول. كيف يمكنني مساعدتك اليوم؟',
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      suggestions: const [
        AiSuggestion(id: '1', text: 'ما حالة حقولي؟', icon: 'landscape'),
        AiSuggestion(id: '2', text: 'توقعات الطقس', icon: 'cloud'),
        AiSuggestion(id: '3', text: 'المهام العاجلة', icon: 'assignment'),
        AiSuggestion(id: '4', text: 'تحليل NDVI', icon: 'satellite'),
      ],
    );

    emit(state.copyWith(
      messages: [welcomeMessage],
      suggestions: welcomeMessage.suggestions ?? [],
    ));
  }

  Future<void> _onMessageSent(AiChatMessageSent event, Emitter<AiChatState> emit) async {
    // Add user message
    final userMessage = AiMessage(
      id: _uuid.v4(),
      content: event.message,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
      suggestions: [],
    ));

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 1));

    final response = _generateResponse(event.message);
    
    emit(state.copyWith(
      messages: [...state.messages, response],
      isTyping: false,
      suggestions: response.suggestions ?? [],
    ));
  }

  void _onSuggestionTapped(AiChatSuggestionTapped event, Emitter<AiChatState> emit) {
    add(AiChatMessageSent(event.suggestion.text));
  }

  void _onCleared(AiChatCleared event, Emitter<AiChatState> emit) {
    emit(const AiChatState());
    add(AiChatStarted());
  }

  AiMessage _generateResponse(String query) {
    final lowerQuery = query.toLowerCase();
    String content;
    List<AiSuggestion>? suggestions;

    if (lowerQuery.contains('حقل') || lowerQuery.contains('حقول')) {
      content = '''📊 حالة حقولك:

• حقل القمح الشمالي: NDVI 0.78 - حالة ممتازة ✅
• حقل البرسيم: NDVI 0.65 - يحتاج ري ⚠️
• حقل الشعير: NDVI 0.82 - جاهز للحصاد 🌾
• حقل الذرة: NDVI 0.71 - نمو جيد ✅

💡 توصية: حقل البرسيم يحتاج ري خلال 24 ساعة.''';
      suggestions = const [
        AiSuggestion(id: '1', text: 'تفاصيل حقل القمح', icon: 'info'),
        AiSuggestion(id: '2', text: 'جدولة الري', icon: 'schedule'),
      ];
    } else if (lowerQuery.contains('طقس')) {
      content = '''🌤️ توقعات الطقس للأيام القادمة:

• اليوم: مشمس جزئياً، 28°C
• غداً: غائم، 26°C
• بعد غد: مشمس، 30°C

💧 رطوبة: 45%
💨 رياح: 12 كم/س

✅ ظروف مثالية للزراعة والري في الصباح الباكر.''';
      suggestions = const [
        AiSuggestion(id: '1', text: 'توقعات الأسبوع', icon: 'calendar'),
        AiSuggestion(id: '2', text: 'تنبيهات الطقس', icon: 'warning'),
      ];
    } else if (lowerQuery.contains('مهام') || lowerQuery.contains('مهمة')) {
      content = '''📋 المهام العاجلة:

🔴 عاجل:
• ري حقل البرسيم - اليوم 6:00 ص

🟡 عالي:
• فحص حقل القمح - غداً
• تسميد حقل الذرة - بعد غد

🟢 متوسط:
• صيانة نظام الري - الأسبوع القادم

📊 الإحصائيات: 3 عاجلة، 5 قيد التنفيذ، 12 مكتملة هذا الشهر.''';
      suggestions = const [
        AiSuggestion(id: '1', text: 'إضافة مهمة', icon: 'add'),
        AiSuggestion(id: '2', text: 'عرض الكل', icon: 'list'),
      ];
    } else if (lowerQuery.contains('ndvi') || lowerQuery.contains('تحليل')) {
      content = '''🛰️ تحليل NDVI الأخير:

متوسط NDVI لجميع الحقول: 0.72 (جيد)

📈 التحسن خلال الأسبوع: +5%

• حقل الشعير: 0.82 (ممتاز) ↑
• حقل القمح: 0.78 (جيد جداً) ↑
• حقل الذرة: 0.71 (جيد) →
• حقل البرسيم: 0.65 (متوسط) ↓

⚠️ تنبيه: حقل البرسيم يحتاج اهتمام - انخفاض في NDVI.''';
      suggestions = const [
        AiSuggestion(id: '1', text: 'عرض الخريطة', icon: 'map'),
        AiSuggestion(id: '2', text: 'تاريخ NDVI', icon: 'history'),
      ];
    } else {
      content = '''شكراً لسؤالك! 

أنا هنا لمساعدتك في:
• 🌾 إدارة الحقول ومراقبة المحاصيل
• 📋 تنظيم المهام الزراعية
• 🌤️ متابعة أحوال الطقس
• 🛰️ تحليل صور الأقمار الصناعية
• 💡 تقديم توصيات ذكية

كيف يمكنني مساعدتك؟''';
      suggestions = const [
        AiSuggestion(id: '1', text: 'حالة الحقول', icon: 'landscape'),
        AiSuggestion(id: '2', text: 'توقعات الطقس', icon: 'cloud'),
        AiSuggestion(id: '3', text: 'المهام العاجلة', icon: 'assignment'),
      ];
    }

    return AiMessage(
      id: _uuid.v4(),
      content: content,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
      suggestions: suggestions,
    );
  }
}
