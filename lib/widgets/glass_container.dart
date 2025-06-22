import 'package:flutter/material.dart';
import 'package:my_kurir_app/util/performace_util.dart';
import 'dart:ui';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final double blur;
  final double alpha;
  final BorderRadius? borderRadius;
  final bool? forceSimple; // Override auto-detection

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.blur = 10,
    this.alpha = 20,
    this.borderRadius,
    this.forceSimple,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderRad = borderRadius ?? BorderRadius.circular(20);

    // Auto-detect atau gunakan force setting
    final useSimple = forceSimple ?? PerformanceUtils.shouldUseSimpleGlass();

    if (useSimple) {
      return _buildSimpleContainer(isDarkMode, borderRad);
    } else {
      return _buildGlassContainer(isDarkMode, borderRad);
    }
  }

  Widget _buildSimpleContainer(bool isDarkMode, BorderRadius borderRad) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1D1E33).withAlpha(220)
            : Colors.white.withAlpha(240),
        borderRadius: borderRad,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withAlpha(40)
              : Colors.black.withAlpha(30),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.black : Colors.grey.shade300).withAlpha(
              30,
            ),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGlassContainer(bool isDarkMode, BorderRadius borderRad) {
    return ClipRRect(
      borderRadius: borderRad,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur * 0.6, // Kurangi intensitas
          sigmaY: blur * 0.6,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withAlpha((alpha * 0.5).toInt())
                : Colors.black.withAlpha((alpha * 0.3).toInt()),
            borderRadius: borderRad,
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withAlpha((alpha * 1.2).toInt())
                  : Colors.white.withAlpha((alpha * 1.5).toInt()),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
