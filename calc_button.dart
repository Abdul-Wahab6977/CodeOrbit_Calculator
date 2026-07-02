import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// A single calculator key.
///
/// Styling adapts to [CalcButtonType] and the current brightness, giving
/// a soft neumorphic look in light mode and a subtle glass/elevated look
/// in dark mode — without any hardcoded pixel sizes, so it scales inside
/// whatever grid cell it's placed in.
class CalcButton extends StatelessWidget {
  const CalcButton({
    super.key,
    required this.label,
    required this.type,
    required this.onTap,
  });

  final String label;
  final CalcButtonType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final Color background = switch (type) {
      CalcButtonType.equals => colorScheme.primary,
      CalcButtonType.operatorKey =>
        isDark ? AppColors.darkButtonFunction : AppColors.lightButtonFunction,
      CalcButtonType.function =>
        isDark ? AppColors.darkButtonFunction : AppColors.lightButtonFunction,
      CalcButtonType.number =>
        isDark ? AppColors.darkButtonNumber : AppColors.lightButtonNumber,
    };

    final Color foreground = switch (type) {
      CalcButtonType.equals => colorScheme.onPrimary,
      CalcButtonType.operatorKey => isDark ? AppColors.accentOrange : AppColors.accentBlue,
      CalcButtonType.function => isDark ? Colors.white70 : Colors.black54,
      CalcButtonType.number => isDark ? Colors.white : Colors.black87,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        // Font scales with the cell size so it never overflows on small
        // screens and looks proportional on tablets.
        final fontSize = constraints.maxHeight * 0.34;

        return Material(
          color: background,
          borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
          elevation: isDark ? 0 : 2,
          shadowColor: Colors.black26,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
            splashColor: foreground.withOpacity(0.15),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: fontSize.clamp(16, 32),
                  fontWeight: type == CalcButtonType.number ? FontWeight.w500 : FontWeight.w600,
                  color: foreground,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
