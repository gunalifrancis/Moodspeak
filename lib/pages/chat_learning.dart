import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/learning_level.dart';

class ChatLearningPage extends StatefulWidget {
  final LearningLevel level;

  const ChatLearningPage({
    super.key,
    required this.level,
  });

  @override
  State<ChatLearningPage> createState() => _ChatLearningPageState();
}

class _ChatLearningPageState extends State<ChatLearningPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> messages = [];
  bool isTyping = false;

  // Gradient animation
  final List<List<Color>> gradientColors = [
    [Color(0xFF5F0A87), Color(0xFF20BF55)],
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    [Color(0xFF00B09B), Color(0xFF96C93D)],
    [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
  ];

  int currentIndex = 0;
  List<Color> currentGradient = [Color(0xFF5F0A87), Color(0xFF20BF55)];

  @override
  void initState() {
    super.initState();
    _animateGradient();

    // First AI greeting based on level
    Future.delayed(const Duration(milliseconds: 300), () {
      _addAIMessage(_levelGreeting(widget.level));
    });
  }

  void _animateGradient() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        currentIndex = (currentIndex + 1) % gradientColors.length;
        currentGradient = gradientColors[currentIndex];
      });
      _animateGradient();
    });
  }

  String _levelGreeting(LearningLevel level) {
    switch (level) {
      case LearningLevel.beginner:
        return "Hi 👋 I’m your English buddy! Let’s start easy. Tell me: What is your name?";
      case LearningLevel.intermediate:
        return "Hey 😄 Let’s practice Intermediate English. Tell me about your day in 2-3 sentences.";
      case LearningLevel.advanced:
        return "Welcome 🧠 Advanced mode! Let’s discuss: Do you think social media improves communication? Give your opinion.";
    }
  }

  String _aiReplyForLevel(LearningLevel level, String userText) {
    switch (level) {
      case LearningLevel.beginner:
        return "Nice! ✅ Try this sentence:\n\"I am learning English every day.\" \nNow you type: \"I am ...\"";
      case LearningLevel.intermediate:
        return "Good one 🔥 Now improve it with more detail.\nTry adding:\n- time\n- reason\nExample: \"Today I felt happy because...\"";
      case LearningLevel.advanced:
        return "Great thought 👌 Now refine it with advanced structure:\nUse:\n- However,\n- In my opinion,\n- On the other hand\nRewrite your answer with these connectors.";
    }
  }

  void _addAIMessage(String text) {
    setState(() {
      messages.add({"sender": "AI", "text": text});
    });
    _scrollToBottom();
  }

  void sendMessage() {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      messages.add({"sender": "You", "text": userText});
      _controller.clear();
      isTyping = true;
    });

    _scrollToBottom();

    // Fake AI response but level based
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        messages.add({
          "sender": "AI",
          "text": _aiReplyForLevel(widget.level, userText),
        });
        isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 4),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // HEADER
              Text(
                "Chat Learning 💬",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "Level: ${widget.level.label}",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 16),

              // CHAT LIST
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length + (isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isTyping && index == messages.length) {
                      return _typingBubble();
                    }

                    final msg = messages[index];
                    final isYou = msg["sender"] == "You";

                    return _animatedBubble(text: msg["text"]!, isYou: isYou);
                  },
                ),
              ),

              // INPUT BAR
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Type your message...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                            ),
                            onPressed: sendMessage,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 Animated message bubble
  Widget _animatedBubble({required String text, required bool isYou}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(isYou ? 40 * (1 - value) : -40 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(14),
              constraints:
                  BoxConstraints(maxWidth: constraints.maxWidth * 0.75),
              decoration: BoxDecoration(
                color:
                    isYou ? Colors.deepPurple : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isYou ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🤖 AI typing indicator
  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          "AI is typing...",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
