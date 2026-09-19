import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final double borderWidth;
  final Color? glowColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = GlassTheme.defaultRadius,
    this.blur = GlassTheme.blurSigma,
    this.borderColor,
    this.borderWidth = 1.2,
    this.glowColor,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ?? GlassTheme.glassGradient(),
        border: Border.all(
          color: borderColor ?? GlassTheme.glassBorder,
          width: borderWidth,
        ),
      ),
      child: child,
    );

    Widget frosted = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );

    Widget decorated = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: GlassTheme.glassShadow(glowColor: glowColor),
      ),
      child: frosted,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          hoverColor: Colors.white.withOpacity(0.05),
          splashColor: GlassTheme.cyanAccent.withOpacity(0.12),
          child: decorated,
        ),
      );
    }

    return decorated;
  }
}
