import 'package:flutter/material.dart';

/// A metric display card with an animated number counter
/// and trend indicator, suitable for dashboards.
///
/// Features a counting animation on first build and
/// a trend arrow with color coding. Fully standalone.
///
/// Example:
/// ```dart
/// DashboardCard(
///   label: 'Revenue',
///   value: 12450,
///   prefix: '\$',
///   trend: DashboardTrend.up,
///   trendValue: '+12.5%',
/// )
/// ```
enum DashboardTrend {
  /// Positive trend — green arrow up.
  up,

  /// Negative trend — red arrow down.
  down,

  /// Neutral — grey dash.
  neutral,
}

class DashboardCard extends StatefulWidget {
  const DashboardCard({
    required this.label,
    required this.value,
    super.key,
    this.prefix = '',
    this.suffix = '',
    this.trend = DashboardTrend.neutral,
    this.trendValue = '',
    this.borderRadius = 16,
    this.padding,
    this.backgroundColor,
    this.width,
    this.icon,
    this.accentColor,
    this.animateValue = true,
    this.animationDuration,
  });

  /// Metric label (e.g., "Revenue", "Users").
  final String label;

  /// Numeric value to display.
  final double value;

  /// Value prefix (e.g., "$", "€").
  final String prefix;

  /// Value suffix (e.g., "K", "%").
  final String suffix;

  /// Trend direction.
  final DashboardTrend trend;

  /// Trend label (e.g., "+12.5%").
  final String trendValue;

  /// Corner radius.
  final double borderRadius;

  /// Content padding.
  final EdgeInsets? padding;

  /// Background color override.
  final Color? backgroundColor;

  /// Card width.
  final double? width;

  /// Optional icon.
  final IconData? icon;

  /// Optional accent color.
  final Color? accentColor;

  /// Whether to animate the number counting.
  final bool animateValue;

  /// Duration for the counting animation.
  final Duration? animationDuration;

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          widget.animationDuration ?? const Duration(milliseconds: 1200),
    );
    _valueAnimation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    if (widget.animateValue) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _trendColor => switch (widget.trend) {
        DashboardTrend.up => const Color(0xFF22C55E),
        DashboardTrend.down => const Color(0xFFEF4444),
        DashboardTrend.neutral => const Color(0xFF94A3B8),
      };

  IconData get _trendIcon => switch (widget.trend) {
        DashboardTrend.up => Icons.trending_up_rounded,
        DashboardTrend.down => Icons.trending_down_rounded,
        DashboardTrend.neutral => Icons.remove_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF141419) : Colors.white);
    final accent = widget.accentColor ?? const Color(0xFF6366F1);

    return Container(
      width: widget.width,
      padding: widget.padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            children: [
              if (widget.icon != null) ...[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: accent, size: 18),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : Colors.black45,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Animated value
          AnimatedBuilder(
            animation: _valueAnimation,
            builder: (context, _) {
              final displayValue = _valueAnimation.value;
              final formatted = displayValue >= 1000
                  ? '${(displayValue / 1000).toStringAsFixed(1)}K'
                  : displayValue.toStringAsFixed(
                      displayValue == displayValue.roundToDouble() ? 0 : 1,
                    );
              return Text(
                '${widget.prefix}$formatted${widget.suffix}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -1,
                ),
              );
            },
          ),

          // Trend indicator
          if (widget.trendValue.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(_trendIcon, color: _trendColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  widget.trendValue,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _trendColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
