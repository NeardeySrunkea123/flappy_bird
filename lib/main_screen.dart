import 'package:flutter/material.dart';

import 'gamescreen.dart'; // Import GameScreen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFlappingUp = true;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Duration for one flap cycle
    )..repeat(reverse: true);

    // Define a tween for the vertical movement
    _animation = Tween<double>(begin: -10, end: 10).animate(_controller)
      ..addListener(() {
        setState(() {
          isFlappingUp = _controller.status == AnimationStatus.forward;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/bg.png'),
            fit: BoxFit.cover, // Ensures the image covers the entire screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "FLAPPY BIRD",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Change to white or another color for visibility
                ),
              ),
              const SizedBox(height: 20),

              // Animated Bird Image
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animation.value), // Move the bird up and down
                    child: Image.asset(
                      isFlappingUp
                          ? 'lib/images/Bird-Flapping-up.png' // Image when flapping up
                          : 'lib/images/Bird-Flapping-down.png', // Image when flapping down
                      height: 50,
                      width: 50,
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "PLAY",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
