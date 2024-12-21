import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isThisBottomBarrier;

  const Barrier({
    super.key,
    required this.barrierWidth,
    required this.barrierHeight,
    required this.barrierX,
    required this.isThisBottomBarrier,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        (2 * barrierX + barrierWidth) / (2 - barrierWidth),
        isThisBottomBarrier ? 1 : -1,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * barrierHeight / 2,
        decoration: BoxDecoration(
          color: Colors.blue, // Barrier color
          border: Border.all(
            width: 3,
            color: Colors.black, // Border color
          ),
          borderRadius: BorderRadius.circular(5), // Slightly rounded corners
        ),
      ),
    );
  }
}
