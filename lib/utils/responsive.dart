import 'package:flutter/material.dart';

class Responsive {
  static const double mobileBreakpoint = 650.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileBreakpoint &&
      MediaQuery.sizeOf(context).width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  // Adaptive content padding based on screen width
  static EdgeInsets pagePadding(BuildContext context) {
    final w = screenWidth(context);
    if (w < 400) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    } else if (w < mobileBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 16);
    } else if (w < tabletBreakpoint) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
  }

  // Maximum content width constraint to prevent overstretching on ultrawide screens
  static const double maxContentWidth = 1180.0;
}

/// Helper that switches between Row and Column depending on screen width
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final double spacing;
  final bool forceColumn;

  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.spacing = 12.0,
    this.forceColumn = false,
  });

  @override
  Widget build(BuildContext context) {
    final isCol = forceColumn || Responsive.isMobile(context);

    if (isCol) {
      return Column(
        mainAxisAlignment: columnMainAxisAlignment,
        crossAxisAlignment: columnCrossAxisAlignment,
        children: _buildSpacedChildren(children, spacing, isColumn: true),
      );
    }

    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: rowCrossAxisAlignment,
      children: _buildSpacedChildren(children, spacing, isColumn: false),
    );
  }

  List<Widget> _buildSpacedChildren(
      List<Widget> items, double space, {required bool isColumn}) {
    if (items.isEmpty) return [];
    final List<Widget> spaced = [];
    for (int i = 0; i < items.length; i++) {
      spaced.add(items[i]);
      if (i < items.length - 1) {
        spaced.add(isColumn ? SizedBox(height: space) : SizedBox(width: space));
      }
    }
    return spaced;
  }
}
