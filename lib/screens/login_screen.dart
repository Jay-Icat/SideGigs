import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_scaffold.dart';
import '../widgets/google_sign_in_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    // Simulated quick sign-in delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.96, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      showBackButton: false,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Glowing Brand Card
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, _) {
                    return GlassContainer(
                      borderRadius: 32,
                      glowColor: Color.lerp(
                        GlassTheme.cyanAccent,
                        GlassTheme.violetAccent,
                        _glowController.value,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Floating Logo
                          Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: GlassTheme.buttonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: GlassTheme.op(
                                      GlassTheme.cyanAccent, 0.45),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.work_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Brand Title
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xFFE2E8F0),
                                GlassTheme.cyanAccent,
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'SideGigs',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'The Super-Glass Service & Negotiation Network',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: GlassTheme.op(Colors.white, 0.70),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Value proposition pills
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildPill(
                                icon: Icons.shield_outlined,
                                label: 'Escrow Protected',
                                color: GlassTheme.emeraldAccent,
                              ),
                              _buildPill(
                                icon: Icons.handshake_outlined,
                                label: 'Fluid Negotiation',
                                color: GlassTheme.cyanAccent,
                              ),
                              _buildPill(
                                icon: Icons.percent_rounded,
                                label: '10% Platform Fee',
                                color: GlassTheme.violetAccent,
                              ),
                            ],
                          ),

                          const SizedBox(height: 36),

                          // Only Google Sign-In as requested
                          GoogleSignInButton(
                            isLoading: _isLoading,
                            onPressed: _handleGoogleSignIn,
                          ),

                          const SizedBox(height: 24),

                          // Privacy & security tag
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 14,
                                color: GlassTheme.op(Colors.white, 0.45),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Instant access • No password needed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: GlassTheme.op(Colors.white, 0.45),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: GlassTheme.op(color, 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: GlassTheme.op(color, 0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
