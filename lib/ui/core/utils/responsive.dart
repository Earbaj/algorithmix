import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static const double mobileBreakPoint = 600.0;
  static const double tabletBreakPoint = 1024.0;
  static const double maxContentWidth = 1000.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakPoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobileBreakPoint &&
      MediaQuery.sizeOf(context).width < tabletBreakPoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakPoint;

  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  // Dynamic Font Scaling based on screen width
  static double sp(BuildContext context, double fontSize) {
    final width = screenWidth(context);
    if (width < 360) {
      return fontSize * 0.88;
    } else if (width < 600) {
      return fontSize;
    } else if (width < 900) {
      return fontSize * 1.1;
    } else {
      return fontSize * 1.2;
    }
  }

  // Dynamic Horizontal Padding based on screen width
  static double horizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < 360) return 12.0;
    if (width < 600) return 20.0;
    if (width < 900) return 32.0;
    return 48.0;
  }

  // Dynamic Vertical Padding based on screen height
  static double verticalPadding(BuildContext context) {
    final height = screenHeight(context);
    if (height < 650) return 12.0;
    if (height < 800) return 20.0;
    return 28.0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= tabletBreakPoint) {
          return desktop;
        }
        if (constraints.maxWidth >= mobileBreakPoint) {
          return tablet ?? desktop;
        }
        return mobile;
      },
    );
  }
}

/// A wrapper widget that keeps content centered with a maximum width on large screens
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxContentWidth,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
