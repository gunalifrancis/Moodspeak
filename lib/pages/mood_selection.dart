import 'dart:math';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class UserMood {
  static String? selected;
}

class MoodSelectionPage extends StatefulWidget {
  const MoodSelectionPage({super.key});

  @override
  State<MoodSelectionPage> createState() => _MoodSelectionPageState();
}

class _MoodSelectionPageState extends State<MoodSelectionPage>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> moods = [
    {"image": "assets/happy.png", "label": "Happy", "color": Colors.yellow},
    {
      "image": "assets/relax.jpeg",
      "label": "Relaxed",
      "color": Colors.blueAccent
    },
    {"image": "assets/sad.jpeg", "label": "Sad", "color": Colors.indigo},
    {"image": "assets/angry.jpeg", "label": "Angry", "color": Colors.redAccent},
  ];

  late AnimationController _scaleController;
  late AnimationController _particleController;
  late AnimationController _bgController;

  String tappedMood = "";
  Color tappedColor = Colors.white;
  bool showAnimation = false;

  final Random random = Random();
  List<Offset> particleOffsets = [];
  List<Color> particleColors = [];

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

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() => setState(() {}));

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgController.addListener(() {
      final next = (currentIndex + 1) % gradientColors.length;
      setState(() {
        currentGradient = [
          Color.lerp(gradientColors[currentIndex][0], gradientColors[next][0],
              _bgController.value)!,
          Color.lerp(gradientColors[currentIndex][1], gradientColors[next][1],
              _bgController.value)!,
        ];
      });

      if (_bgController.status == AnimationStatus.completed) {
        currentIndex = next;
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particleController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void onMoodTap(String label, Color color, double spread) async {
    tappedMood = label;
    tappedColor = color;

    particleOffsets = List.generate(24, (_) {
      final dx = random.nextDouble() * 2 - 1;
      final dy = random.nextDouble() * 2 - 1;
      return Offset(dx, dy);
    });

    particleColors = List.generate(
      24,
      (_) => color.withOpacity(0.5 + random.nextDouble() * 0.5),
    );

    setState(() => showAnimation = true);

    _scaleController.forward(from: 0);
    _particleController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 800));

    UserMood.selected = label;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Widget moodCircleTile({
    required Map<String, dynamic> mood,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.45),
                width: 2.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                mood["image"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 22,
            child: Text(
              mood["label"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black,
                    offset: Offset(1, 2),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double particleSpread = size.width * 0.25;

    // tile size responsive
    final double circleSize = size.width * 0.34;

    return WillPopScope(
      onWillPop: () async {
        // Device back button navigates to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
        ),
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: currentGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // ================= Mood Layout =================
                if (!showAnimation)
                  Column(
                    children: [
                      const SizedBox(height: 18),
                      const Text(
                        "Select Your Mood",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black45,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Tap one mood to continue",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Top Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    moodCircleTile(
                                      mood: moods[0],
                                      size: circleSize,
                                      onTap: () => onMoodTap(
                                        moods[0]["label"],
                                        moods[0]["color"],
                                        particleSpread,
                                      ),
                                    ),
                                    moodCircleTile(
                                      mood: moods[1],
                                      size: circleSize,
                                      onTap: () => onMoodTap(
                                        moods[1]["label"],
                                        moods[1]["color"],
                                        particleSpread,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 38),
                                // Bottom Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    moodCircleTile(
                                      mood: moods[2],
                                      size: circleSize,
                                      onTap: () => onMoodTap(
                                        moods[2]["label"],
                                        moods[2]["color"],
                                        particleSpread,
                                      ),
                                    ),
                                    moodCircleTile(
                                      mood: moods[3],
                                      size: circleSize,
                                      onTap: () => onMoodTap(
                                        moods[3]["label"],
                                        moods[3]["color"],
                                        particleSpread,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                // ================= Animation =================
                if (showAnimation)
                  Center(
                    child: Stack(
                      children: [
                        ...List.generate(particleOffsets.length, (i) {
                          final offset = particleOffsets[i] *
                              (_particleController.value * particleSpread);

                          return Positioned(
                            left: size.width / 2 + offset.dx,
                            top: size.height / 2 + offset.dy,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: particleColors[i],
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),
                        Center(
                          child: ScaleTransition(
                            scale: Tween(begin: 0.6, end: 1.6).animate(
                              CurvedAnimation(
                                parent: _scaleController,
                                curve: Curves.easeOutBack,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    moods.firstWhere((m) =>
                                        m["label"] == tappedMood)["image"],
                                    width: size.width * 0.35,
                                    height: size.width * 0.35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Feeling $tappedMood",
                                  style: TextStyle(
                                    fontSize: size.width * 0.06,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
    );
  }
}
