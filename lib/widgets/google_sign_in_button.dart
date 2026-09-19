import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isLoading
          ? SystemMouseCursors.wait
          : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: GlassTheme.op(
                Colors.white,
                _isHovered ? 0.18 : 0.08,
              ),
              blurRadius: _isHovered ? 24 : 14,
              offset: const Offset(0, 6),
            ),
            if (_isHovered)
              BoxShadow(
                color: GlassTheme.op(GlassTheme.cyanAccent, 0.22),
                blurRadius: 28,
                spreadRadius: 1,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: GlassTheme.blurSigma,
              sigmaY: GlassTheme.blurSigma,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : widget.onPressed,
                borderRadius: BorderRadius.circular(18),
                hoverColor: GlassTheme.op(Colors.white, 0.06),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: GlassTheme.op(
                      Colors.white,
                      _isHovered ? 0.16 : 0.10,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: GlassTheme.op(
                        Colors.white,
                        _isHovered ? 0.40 : 0.22,
                      ),
                      width: 1.4,
                    ),
                  ),
                  child: widget.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Authentic Google G Logo
                            Container(
                              width: 28,
                              height: 28,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: GlassTheme.op(Colors.black, 0.15),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: CustomPaint(
                                painter: _GoogleLogoPainter(),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Draw Google 4 colors (Blue, Red, Yellow, Green)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;

    // Red arc (top)
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -2.4, 1.8, true, redPaint);

    // Yellow arc (left)
    canvas.drawArc(rect, -0.6 - 3.14, 1.3, true, yellowPaint);

    // Green arc (bottom)
    canvas.drawArc(rect, 0.5, 1.7, true, greenPaint);

    // Blue arc + bar (right & cross)
    canvas.drawArc(rect, -0.8, 1.4, true, bluePaint);

    // Inner cutout
    final whiteInner = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.58, whiteInner);

    // Horizontal blue bar
    final barRect = Rect.fromLTWH(center.dx - 1, center.dy - radius * 0.22,
        radius * 1.05, radius * 0.44);
    canvas.drawRRect(
        RRect.fromRectAndRadius(barRect, const Radius.circular(2)), bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
