import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator.pop()
import 'flappy_bird.dart'; // Assuming the FlappyBird widget is in flappy_bird.dart
import 'barrier.dart'; // Assuming the Barrier widget is in barrier.dart

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = 5; // Default gravity (can be adjusted for speed)
  double velocity = 0.9; // Initial velocity (can be adjusted for speed)
  double birdWidth = 0.15; // Bird size
  double birdHeight = 0.1;

  bool gameHasStarted = false;
  int score = 0;
  int bestScore = 0;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(_gameLoop);
  }

  void _gameLoop() {
    if (gameHasStarted) {
      // Increment time for gravity calculation
      time += 0.016; // Smooth time progression for each frame (60 FPS)

      // Calculate height using the physics formula
      height = velocity * time + 0.5 * gravity * time * time;

      setState(() {
        birdY = initialPos + height;

        // Ensure the bird stops exactly at the bottom and doesn't go below
        if (birdY + birdHeight / 2 >= 1.055) {
          birdY = 1.055 - birdHeight / 2; // Stop at the exact ground level
          time = 0; // Reset time to stop further downward motion
        }
      });

      // Check if the bird collided with barriers or ground
      if (birdIsDead()) {
        _animationController.stop();
        gameHasStarted = false;

        // Update best score if the current score is higher
        bestScore = score > bestScore ? score : bestScore;

        // Show the game-over dialog
        _showDialog();
      }

      // Move the map or obstacles
      moveMap();
    }
  }

  void jump() {
    setState(() {
      time = 0; // Reset the time to zero when the bird jumps
      initialPos = birdY; // Keep the initial position of the bird at jump
      velocity = -1.8; // Apply a stronger upward velocity for the jump
    });
  }

  void startGame() {
    gameHasStarted = true;
    _animationController.repeat(); // Start the game loop
  }

  bool birdIsDead() {
    // Check if the bird hits the ground
    if (birdY + birdHeight / 2 >= 1.055) {
      birdY =
          1.055 - birdHeight / 2; // Ensure the bird stops exactly at the bottom
      return true;
    }

    const double tolerance =
        0.02; // Define a small tolerance value for collision check

    // Check for barrier collisions with tolerance
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] < birdWidth / 0.8 &&
          barrierX[i] + barrierWidth > -birdWidth / 1) {
        bool hitsTopBarrier =
            birdY - birdHeight / 2 <= -0.859 + barrierHeight[i][0] + tolerance;
        bool hitsBottomBarrier =
            birdY + birdHeight / 2 >= 0.859- barrierHeight[i][1] - tolerance;

        if (hitsTopBarrier || hitsBottomBarrier) {
          return true;
        }
      }
    }
    return false;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 2 + 1.5];
      score = 0;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -=
            0.02; // Adjust the speed of the barriers (faster/slower movement)
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3; // Reset barrier position
        score++; // Increase score when the barrier goes off screen
      }
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade800,
          title: const Center(
            child: Text(
              "GAME OVER",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          content: Text(
            "Score: $score\nBest Score: $bestScore",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: Colors.white,
                  child: const Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                SystemNavigator.pop(); // This will exit the app
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  color: Colors.white,
                  child: const Text(
                    'EXIT',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      FlappyBird(
                        birdY: birdY,
                        birdWidth: birdWidth,
                        birdHeight: birdHeight,
                      ),
                      for (int i = 0; i < barrierX.length; i++) ...[
                        Barrier(
                          barrierX: barrierX[i],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[i][0],
                          isThisBottomBarrier: false,
                        ),
                        Barrier(
                          barrierX: barrierX[i],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[i][1],
                          isThisBottomBarrier: true,
                        ),
                      ],
                      if (!gameHasStarted)
                        Container(
                          alignment: const Alignment(0, -0.3),
                          child: const Text(
                            "TAP TO PLAY",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: const Alignment(0, -0.5),
                color: Colors.brown,
                child: Text(
                  gameHasStarted ? 'Score: $score' : '',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
