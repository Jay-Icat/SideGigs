import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_scaffold.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Optional auto-forward after 3 seconds, or click manually
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _navigateToLogin();
      }
    });
  }

  void _navigateToLogin() {
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      showBackButton: false,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Glowing Animated Logo Glass Card
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return GlassContainer(
                    width: 140,
                    height: 140,
                    borderRadius: 36,
                    glowColor: GlassTheme.cyanAccent,
                    borderColor: Color.lerp(
                      GlassTheme.cyanAccent.withOpacity(0.5),
                      GlassTheme.violetAccent.withOpacity(0.8),
                      _pulseController.value,
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: GlassTheme.buttonGradient,
                          boxShadow: [
                            BoxShadow(
                              color: GlassTheme.cyanAccent.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.work_outline_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 36),

              // Brand Title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFE0E7FF), GlassTheme.cyanAccent],
                ).createShader(bounds),
                child: const Text(
                  'SideGigs',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Tagline
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'Create services, discover gigs, and negotiate amounts with effortless liquid glass UX.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Launch CTA Glass Button
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: GlassButton(
                  text: 'Enter Marketplace',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _navigateToLogin,
                ),
              ),

              const SizedBox(height: 24),

              // Status Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        GlassTheme.cyanAccent.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loading Super Glass Engine...',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
