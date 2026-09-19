import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';
import '../utils/responsive.dart';

class AdaptiveGlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AdaptiveGlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isMobile(context)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: GlassTheme.op(Colors.black, 0.45),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: GlassTheme.op(Colors.white, 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Feed',
                  isSelected: currentIndex == 0,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.explore_outlined,
                  label: 'Get Gigs',
                  isSelected: currentIndex == 1,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.add_circle_rounded,
                  label: 'Post',
                  isSelected: currentIndex == 2,
                  isCenterAction: true,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  isSelected: currentIndex == 3,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.tune_rounded,
                  label: 'Settings',
                  isSelected: currentIndex == 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    bool isCenterAction = false,
  }) {
    if (isCenterAction) {
      return InkWell(
        onTap: () => onTabSelected(index),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: GlassTheme.buttonGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: GlassTheme.op(GlassTheme.cyanAccent, 0.4),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? GlassTheme.op(GlassTheme.cyanAccent, 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? GlassTheme.op(GlassTheme.cyanAccent, 0.4)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? GlassTheme.cyanAccent
                  : GlassTheme.op(Colors.white, 0.6),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : GlassTheme.op(Colors.white, 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
