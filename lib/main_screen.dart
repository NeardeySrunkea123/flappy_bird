import 'dart:async';

import 'package:bird_game/barrier.dart';
import 'package:bird_game/flappy_bird.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static double birdY = 0;
  double initailPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = 9.8;
  double velocity = 1.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  bool gameHasStated = false;

  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
    [0.3, 0.7],
    [0.7, 0.3],
    [0.2, 0.8],
    [0.8, 0.2],
   
  ];

  void jump() {
    setState(() {
      time = 0;
      initailPos = birdY;
      velocity = -2;
    });
  }

  void startedGame() {
  gameHasStated = true;

  Timer.periodic(const Duration(milliseconds: 16), (timer) {
    setState(() {
      velocity += gravity * 0.016;
      birdY += velocity * 0.016; 

     if (birdY - birdHeight / 2 < -1 || birdY + birdHeight / 2 > 1) {
  birdY = birdY < -1 ? -1 + birdHeight / 2 : 1 - birdHeight / 2;
}

    });

    if (birdIsDead()) {
      timer.cancel();
      gameHasStated = false;
      _showDialog();
    }

    moveMap();
  });
}


  bool birdIsDead() {
 if (birdY - birdHeight < -1 || birdY + birdHeight > 1) {
    return true;
  }    for (int i = 0; i < barrierX.length; i++) {
    if (barrierX[i] < 0.05 && 
    barrierX[i] + barrierWidth > -0.05 && 
    (birdY - birdHeight / 2 <= -1 + barrierHeight[i][0] || 
     birdY + birdHeight / 2 >= 1 - barrierHeight[i][1])) {
  return true;
}


    }
    return false;
  }

  void resetGame() {
  Navigator.pop(context); 
  setState(() {
    birdY = 0;              
    initailPos = 0;          
    time = 0;                 
    velocity = 1.5;          
    gameHasStated = false;   
    barrierX = [2, 2 + 1.5];  
  });
}


  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
  setState(() {
    barrierX[i] -= 0.005; 
    if (barrierX[i] < -1.5) {
      barrierX[i] += 3;
    }
  });
}

  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Center(
              child: Text(
                "GAME OVER",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text('PLAY AGAIN',
                        style: TextStyle(color: Colors.brown)),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStated ? jump : startedGame,
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
                        birdWidth: barrierWidth,
                        birdHeight: birdHeight,
                      ),
                      Barrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier : false,
                      ),
                      Barrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier : true,
                      ),
                      Barrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier : false,
                      ),
                      Barrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier : true,
                      ),
                      Container(
                          alignment: const Alignment(0, -0.5),
                          child: Text(
                            gameHasStated ? '' : 'TAP TO PLAY',
                            style: const TextStyle(color: Colors.white, fontSize: 30),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
              ),
            )
          ],
        ),
      ),
    );
  }
}
