import 'package:flutter/material.dart';

import '../../core/storage/session_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _checkSession();
  }

  Future<void> _checkSession() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Get saved token
    final token = await SessionStorage.getToken();

    if (!mounted) return;

    // No token -> Sign In
    if (token == null || token.trim().isEmpty) {
      Navigator.pushReplacementNamed(context, '/signin');
      return;
    }

    // Get saved user
    final user = await SessionStorage.getUser();

    if (!mounted) return;

    // User data not found -> clear session and Sign In
    if (user == null) {
      await SessionStorage.clear();

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/signin');
      return;
    }

    // Get role from user type
    final role = user.userType?.code.toUpperCase() ?? '';

    debugPrint('SPLASH USER ROLE: $role');

    // Navigate according to role
    switch (role) {
      case 'TEACHER':
        Navigator.pushReplacementNamed(
          context,
          '/teacher-dashboard',
          arguments: {'token': token, 'user_model': user},
        );
        break;

      case 'ADMIN':
      case 'SUPER_ADMIN':
      case 'USER':
        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
          arguments: {'token': token, 'user_model': user},
        );
        break;

      default:
        // Unknown role
        await SessionStorage.clear();

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/signin');
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 112, 122, 126),
              Color.fromARGB(255, 161, 172, 177),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 140,
                    child: Image.asset(
                      'assets/logo/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    "MIHISARA HIGHER EDUCATION INSTITUTE",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Towards a bright future",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 1.2,
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
