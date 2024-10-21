import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ExplosiveConfettiWidget extends StatelessWidget {
  const ExplosiveConfettiWidget(
      {super.key, required this.child, required this.confettiController});

  final Widget child;
  final ConfettiController confettiController;

  @override
  Widget build(BuildContext context,) {
    return ConfettiWidget(
        numberOfParticles: 100,
        maxBlastForce: 50,
        minBlastForce: 1,
        gravity: 0,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        confettiController: confettiController,
        child: child,
        );
  }
}
