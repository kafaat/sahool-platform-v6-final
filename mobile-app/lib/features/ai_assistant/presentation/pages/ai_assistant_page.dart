import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../presentation/theme/app_colors.dart';
import '../bloc/ai_assistant_bloc.dart';
import '../widgets/message_bubble.dart';
import '../widgets/quick_suggestions.dart';

class AiAssistantPage extends StatelessWidget {
  const AiAssistantPage({super.key, this.fieldContext});

  /// سياق الحقل القادم من FieldHub (اختياري)
  final Map<String, dynamic>? fieldContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = AiAssistantBloc()..add(const AiAssistantHistoryRequested());
        if (fieldContext != null && fieldContext!.isNotEmpty) {
          bloc.add(AiAssistantContextAttached(fieldContext!));
        }
        return bloc;
      },
      child: const _AiAssistantView(),
    );
  }
}

class _AiAssistantView extends StatefulWidget {
  const _AiAssistantView();

  @override
  State<_AiAssistantView> createState() => _AiAssistantViewState();
}

class _AiAssistantViewState extends State<_AiAssistantView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<AiAssistantBloc>().add(AiAssistantMessageSent(text));
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('مساعد سهول الذكي'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            QuickSuggestions(
              onTap: (text) {
                context
                    .read<AiAssistantBloc>()
                    .add(AiAssistantSuggestionTapped(text));
                _scrollToBottom();
              },
            ),
            Expanded(
              child: BlocConsumer<AiAssistantBloc, AiAssistantState>(
                listener: (context, state) {
                  _scrollToBottom();
                },
                builder: (context, state) {
                  if (state.messages.isEmpty && !state.isSending) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'ابدأ المحادثة مع مساعد سهول لطرح أسئلة حول الحقول، NDVI، الطقس، والري.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  final count = state.messages.length +
                      (state.isSending ? 1 : 0);
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: count,
                    itemBuilder: (context, index) {
                      if (index >= state.messages.length) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'يحلل البيانات...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final msg = state.messages[index];
                      return MessageBubble(message: msg);
                    },
                  );
                },
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'اكتب سؤالك أو ما تريد تحليله...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _send(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: AppColors.primary,
                      onPressed: () => _send(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
