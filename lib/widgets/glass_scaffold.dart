import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class GlassScaffold extends StatefulWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const GlassScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBack,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  State<GlassScaffold> createState() => _GlassScaffoldState();
}

class _GlassScaffoldState extends State<GlassScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    return Scaffold(
      backgroundColor: GlassTheme.background,
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Stack(
        children: [
          // Dynamic Ambient Mesh Gradient & Floating Blurred Orbs
          AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              final val = _animController.value;
              final sinVal = math.sin(val * 2 * math.pi);
              final cosVal = math.cos(val * 2 * math.pi);

              return Stack(
                children: [
                  // Base deep dark gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF070A13),
                          Color(0xFF0F172A),
                          Color(0xFF060911),
                        ],
                      ),
                    ),
                  ),

                  // Orb 1: Cyan / Teal (Top-Left floating)
                  Positioned(
                    top: -80 + (sinVal * 40),
                    left: -60 + (cosVal * 30),
                    child: Container(
                      width: 380,
                      height: 380,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlassTheme.cyanAccent.withOpacity(0.20),
                      ),
                    ),
                  ),

                  // Orb 2: Electric Violet / Purple (Bottom-Right floating)
                  Positioned(
                    bottom: -100 + (cosVal * 50),
                    right: -80 + (sinVal * 40),
                    child: Container(
                      width: 440,
                      height: 440,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlassTheme.violetAccent.withOpacity(0.24),
                      ),
                    ),
                  ),

                  // Orb 3: Coral / Pink (Center-Right floating)
                  Positioned(
                    top: 240 + (cosVal * 60),
                    right: 40 + (sinVal * 30),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlassTheme.pinkAccent.withOpacity(0.14),
                      ),
                    ),
                  ),

                  // Orb 4: Emerald / Green (Bottom-Left floating)
                  Positioned(
                    bottom: 120 + (sinVal * 30),
                    left: 20 + (cosVal * 40),
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: GlassTheme.emeraldAccent.withOpacity(0.15),
                      ),
                    ),
                  ),

                  // Heavy BackdropFilter to blend all orbs into smooth ambient luminescence
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                      child: Container(
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Main Content & Top Bar
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.title != null || widget.showBackButton && canPop || widget.actions != null)
                  _buildGlassAppBar(context, canPop),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassAppBar(BuildContext context, bool canPop) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            children: [
              if (widget.showBackButton && (canPop || widget.onBack != null)) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                  onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
                  tooltip: 'Back',
                  splashRadius: 22,
                ),
                const SizedBox(width: 8),
              ],
              if (widget.title != null)
                Expanded(
                  child: Text(
                    widget.title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              if (widget.actions != null) ...widget.actions!,
            ],
          ),
        ),
      ),
    );
  }
}
