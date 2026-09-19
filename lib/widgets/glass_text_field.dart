import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/glass_theme.dart';

class GlassTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const GlassTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: GlassTheme.cyanAccent.withOpacity(0.25),
                  blurRadius: 18,
                  spreadRadius: -2,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(_isFocused ? 0.12 : 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFocused
                    ? GlassTheme.cyanAccent.withOpacity(0.7)
                    : Colors.white.withOpacity(0.18),
                width: _isFocused ? 1.5 : 1.0,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              onChanged: widget.onChanged,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              cursorColor: GlassTheme.cyanAccent,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? GlassTheme.cyanAccent
                            : Colors.white.withOpacity(0.5),
                        size: 20,
                      )
                    : null,
                suffixIcon: widget.suffixIcon,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
