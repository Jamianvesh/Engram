import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientTitle extends StatefulWidget {
  const GradientTitle({super.key});

  @override
  _GradientTitleState createState() => _GradientTitleState();
}

class _GradientTitleState extends State<GradientTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.deepOrangeAccent,
                Colors.limeAccent,
                Colors.purpleAccent,
              ],
              stops: [0.0, _controller.value, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            "Engram",
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        );
      },
    );
  }
}
