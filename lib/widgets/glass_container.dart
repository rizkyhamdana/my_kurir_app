import 'package:flutter/material.dart';
import 'dart:ui';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final double blur;
  final double alpha;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.blur = 10,
    this.alpha = 20,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withAlpha(alpha.toInt())
                : Colors.black.withAlpha((alpha * 0.5).toInt()),
            borderRadius: borderRadius ?? BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withAlpha((alpha * 2).toInt())
                  : Colors.white.withAlpha((alpha * 3).toInt()),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
