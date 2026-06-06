import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// An information card with animated entry and accent color.
///
/// Features slide + fade entry animation, icon area,
/// and structured title/subtitle layout. Fully standalone.
///
/// Example:
/// ```dart
/// AnimatedInfoCard(
///   icon: Icons.flash_on_rounded,
///   title: 'Fast Performance',
///   subtitle: 'Optimized for 60fps animations',
///   accentColor: Colors.amber,
/// )
/// ```
class AnimatedInfoCard extends StatefulWidget {
  const AnimatedInfoCard({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon,
    this.accentColor,
    this.borderRadius = 16,
    this.padding,
    this.backgroundColor,
    this.width,
    this.height,
    this.onTap,
  });

  /// Card title.
  final String title;

  /// Card subtitle/description.
  final String subtitle;

  /// Optional icon displayed in the accent area.
  final IconData? icon;

  /// Accent color for the icon area and highlights.
  final Color? accentColor;

  /// Corner radius.
  final double borderRadius;

  /// Content padding.
  final EdgeInsets? padding;

  /// Background color override.
  final Color? backgroundColor;

  /// Card width.
  final double? width;

  /// Card height.
  final double? height;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  State<AnimatedInfoCard> createState() => _AnimatedInfoCardState();
}

class _AnimatedInfoCardState extends State<AnimatedInfoCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.medium,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = widget.accentColor ?? const Color(0xFF6366F1);
    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF141419) : Colors.white);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: widget.onTap != null
              ? (_) => setState(() => _isPressed = true)
              : null,
          onTapUp: widget.onTap != null
              ? (_) => setState(() => _isPressed = false)
              : null,
          onTapCancel: widget.onTap != null
              ? () => setState(() => _isPressed = false)
              : null,
          child: AnimatedScale(
            scale: _isPressed ? 0.98 : 1.0,
            duration: AppDurations.fast,
            curve: Curves.easeOutCubic,
            child: Container(
              width: widget.width,
              height: widget.height,
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
                    color: accent.withValues(alpha: isDark ? 0.08 : 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color:
                        Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon area
                  if (widget.icon != null) ...[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accent.withValues(alpha: 0.15),
                            accent.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Icon(widget.icon, color: accent, size: 24),
                    ),
                    const SizedBox(width: 16),
                  ],
                  // Text area
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color:
                                isDark ? Colors.white54 : Colors.black45,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
