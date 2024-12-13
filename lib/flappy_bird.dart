import 'package:flutter/material.dart';

class FlappyBird extends StatelessWidget {
  final double birdY;
  final double birdWidth;
  final double birdHeight;

  const FlappyBird({super.key, 
    required this.birdY, 
    required this.birdWidth, 
    required this.birdHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY) / (2 - birdHeight)),
      child: Image.asset(
        'lib/images/bird.webp',
        width: MediaQuery.of(context).size.width * birdWidth,
        height: MediaQuery.of(context).size.height * birdHeight,

      ),
    );
  }
}
