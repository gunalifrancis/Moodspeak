import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/learning_level.dart';

class SelectionLevelPage extends StatefulWidget {
  final Function(LearningLevel)? onLevelSelected;

  const SelectionLevelPage({super.key, this.onLevelSelected});

  @override
  State<SelectionLevelPage> createState() => _SelectionLevelPageState();
}

class _SelectionLevelPageState extends State<SelectionLevelPage>
    with SingleTickerProviderStateMixin {
  final List<List<Color>> gradientColors = [
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    [Color(0xFF00B09B), Color(0xFF96C93D)],
    [Color(0xFF5F0A87), Color(0xFF20BF55)],
  ];

  int gradientIndex = 0;
  late AnimationController _gradientController;
  late Animation<Color?> _color1Anim;
  late Animation<Color?> _color2Anim;

  String selectedLevel = "Beginner";

  final List<Map<String, dynamic>> levels = [
    {
      "title": "Beginner",
      "subtitle": "Basic English Skills",
      "color": Colors.green,
      "icon": Icons.menu_book_rounded,
    },
    {
      "title": "Intermediate",
      "subtitle": "Conversational Skills",
      "color": Colors.orange,
      "icon": Icons.headset_mic_rounded,
    },
    {
      "title": "Advanced",
      "subtitle": "Fluent & Complex Skills",
      "color": Colors.blue,
      "icon": Icons.workspace_premium_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _gradientController =
        AnimationController(vsync: this, duration: const Duration(seconds: 6));
    _setNextGradient();
  }

  void _setNextGradient() {
    final nextIndex = (gradientIndex + 1) % gradientColors.length;

    _color1Anim = ColorTween(
      begin: gradientColors[gradientIndex][0],
      end: gradientColors[nextIndex][0],
    ).animate(_gradientController);

    _color2Anim = ColorTween(
      begin: gradientColors[gradientIndex][1],
      end: gradientColors[nextIndex][1],
    ).animate(_gradientController);

    _gradientController.forward(from: 0).whenComplete(() {
      gradientIndex = nextIndex;
      _setNextGradient();
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _gradientController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _color1Anim.value ?? gradientColors[0][0],
                  _color2Anim.value ?? gradientColors[0][1],
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    // Top bar
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Select Your Level",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose your current skill level",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: "RobotoMono",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Flexible List of levels
                    Flexible(
                      child: ClipRect(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: levels.length,
                          itemBuilder: (context, index) {
                            final level = levels[index];
                            final bool isSelected =
                                selectedLevel == level["title"];

                            // Dynamic height based on screen
                            double cardHeight = screenHeight * 0.18;
                            if (cardHeight > 180) cardHeight = 180; // max
                            if (cardHeight < 140) cardHeight = 140; // min

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedLevel = level["title"];
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  height: cardHeight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.25),
                                      width: isSelected ? 2.2 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.18),
                                        blurRadius: 16,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(26),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 18, sigmaY: 18),
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              (level["color"] as Color)
                                                  .withOpacity(0.45),
                                              Colors.white.withOpacity(0.08),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                              child: Icon(
                                                level["icon"],
                                                color: Colors.white,
                                                size: 44,
                                              ),
                                            ),
                                            const SizedBox(width: 18),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    level["title"],
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    level["subtitle"],
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14,
                                                      fontFamily: "RobotoMono",
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.white
                                                                .withOpacity(
                                                                    0.15),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            isSelected
                                                                ? Icons
                                                                    .check_circle_rounded
                                                                : Icons
                                                                    .touch_app_rounded,
                                                            size: 18,
                                                            color: isSelected
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            isSelected
                                                                ? "Selected"
                                                                : "Choose",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: isSelected
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Fixed Continue button
                    SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.onLevelSelected != null) {
                              final level = LearningLevel.values.firstWhere(
                                  (lvl) => lvl.label == selectedLevel);
                              widget.onLevelSelected!(level);
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 8,
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
