import 'dart:async';
import 'package:flutter/material.dart';

class FlappyBird extends StatefulWidget {
  final double birdY;
  final double birdWidth;
  final double birdHeight;

  const FlappyBird({
    super.key,
    required this.birdY,
    required this.birdWidth,
    required this.birdHeight,
  });

  @override
  State<FlappyBird> createState() => _FlappyBirdState();
}

class _FlappyBirdState extends State<FlappyBird> {
  late Timer _flapTimer;
  bool isFlappingUp = true;

  @override
  void initState() {
    super.initState();
    // Start a timer to alternate the bird's flap state
    _flapTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        isFlappingUp = !isFlappingUp;
      });
    });
  }

  @override
  void dispose() {
    _flapTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * widget.birdY) / (2 - widget.birdHeight)),
      child: Image.asset(
        isFlappingUp
            ? 'lib/images/Bird-Flapping-up.png' // Image when flapping up
            : 'lib/images/Bird-Flapping-down.png', // Image when flapping down
        width: MediaQuery.of(context).size.width * widget.birdWidth,
        height: MediaQuery.of(context).size.height * widget.birdHeight,
      ),
    );
  }
}
