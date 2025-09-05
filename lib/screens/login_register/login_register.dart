import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class login_register_Screen extends StatefulWidget {
  const login_register_Screen({super.key});

  @override
  State<login_register_Screen> createState() => _login_register_ScreenState();
}

class _login_register_ScreenState extends State<login_register_Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn1;
  late Animation<double> _fadeIn2;
  late Animation<double> _fadeIn3;
  late Animation<double> _fadeIn4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeIn1 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.3, curve: Curves.easeIn),
    );
    _fadeIn2 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
    );
    _fadeIn3 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.7, curve: Curves.easeIn),
    );
    _fadeIn4 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 0.9, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget fadeIn({required Animation<double> animation, required Widget child}) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Engram',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.all(6.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.jpg'),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  fadeIn(
                    animation: _fadeIn1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Glad to see you here !",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.handshake_outlined, color: Colors.white),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  fadeIn(
                    animation: _fadeIn2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      icon: const Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      label: const Icon(
                        Icons.app_registration_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  fadeIn(
                    animation: _fadeIn3,
                    child: const Text(
                      "Already have an account ??? ",
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  fadeIn(
                    animation: _fadeIn3,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      icon: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      label: const Icon(
                        Icons.login,
                        color: Colors.blue,
                        size: 26,
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  fadeIn(
                    animation: _fadeIn4,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Start your English journey today! with Engram - Where English comes alive ..",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Text(
                    "© Engram 2025",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
