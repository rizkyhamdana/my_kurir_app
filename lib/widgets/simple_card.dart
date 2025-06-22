import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const SimpleCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderRad = borderRadius ?? BorderRadius.circular(20);

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDarkMode
                ? const Color(0xFF1D1E33).withAlpha(200)
                : Colors.white.withAlpha(200)),
        borderRadius: borderRad,
        border:
            border ??
            Border.all(
              color: isDarkMode
                  ? Colors.white.withAlpha(30)
                  : Colors.black.withAlpha(20),
              width: 1,
            ),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: (isDarkMode ? Colors.black : Colors.grey).withAlpha(20),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: child,
    );
  }
}
