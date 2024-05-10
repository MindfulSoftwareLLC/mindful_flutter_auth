import 'dart:math' as math;

import 'package:flutter/material.dart';

class SessionCheckSpinner extends StatefulWidget {
  final IconData iconData;
  final Color color;

  const SessionCheckSpinner({
    super.key,
    this.iconData = Icons.vpn_key, // Default icon for session checks
    this.color = Colors.black,
  });

  @override
  SessionCheckSpinnerState createState() => SessionCheckSpinnerState();
}

class SessionCheckSpinnerState extends State<SessionCheckSpinner>
    with TickerProviderStateMixin {
  late AnimationController _innerSpinController;
  late Animation<double> _innerSpinAnimation;
  late AnimationController _outerLoopController;
  late Animation<double> _outerLoopAnimation;

  @override
  void initState() {
    super.initState();

    _innerSpinController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _innerSpinAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _innerSpinController,
        curve: Curves.easeInOut,
      ),
    );

    _outerLoopController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    _outerLoopAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _outerLoopController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _innerSpinController.dispose();
    _outerLoopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_innerSpinController, _outerLoopController]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _outerLoopAnimation.value,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(_innerSpinAnimation.value)
              ..rotateY(_innerSpinAnimation.value),
            child: Icon(widget.iconData, color: widget.color, size: 50),
          ),
        );
      },
    );
  }
}
