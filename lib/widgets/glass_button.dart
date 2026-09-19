import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final Gradient? gradient;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? textColor;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.gradient,
    this.width,
    this.height = 52,
    this.borderRadius = 16,
    this.textColor,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = widget.gradient ??
        (widget.isPrimary
            ? GlassTheme.buttonGradient
            : LinearGradient(
                colors: [
                  Colors.white.withOpacity(_isHovered ? 0.20 : 0.10),
                  Colors.white.withOpacity(_isHovered ? 0.10 : 0.04),
                ],
              ));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            if (widget.isPrimary)
              BoxShadow(
                color: GlassTheme.cyanAccent
                    .withOpacity(_isHovered ? 0.45 : 0.25),
                blurRadius: _isHovered ? 24 : 16,
                spreadRadius: _isHovered ? 1 : -2,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: effectiveGradient,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: widget.isPrimary
                          ? Colors.white.withOpacity(0.35)
                          : Colors.white.withOpacity(0.20),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: widget.width != null
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.textColor ?? Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          widget.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.textColor ?? Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
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
