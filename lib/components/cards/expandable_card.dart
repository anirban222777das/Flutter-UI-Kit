import 'package:flutter/material.dart';
import 'package:uikit/core/constants/app_durations.dart';

/// A tappable card that expands to reveal additional content.
///
/// Uses smooth height animation with AnimatedCrossFade for
/// progressive content disclosure. Fully standalone.
///
/// Example:
/// ```dart
/// ExpandableCard(
///   title: 'More Info',
///   subtitle: 'Tap to expand',
///   collapsedContent: Text('Summary text'),
///   expandedContent: Text('Full detailed content here...'),
/// )
/// ```
class ExpandableCard extends StatefulWidget {
  const ExpandableCard({
    required this.title,
    super.key,
    this.subtitle,
    this.collapsedContent,
    this.expandedContent,
    this.borderRadius = 16,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.icon,
    this.initiallyExpanded = false,
    this.duration,
  });

  /// Card title displayed in the header.
  final String title;

  /// Optional subtitle below the title.
  final String? subtitle;

  /// Content shown when collapsed.
  final Widget? collapsedContent;

  /// Content shown when expanded.
  final Widget? expandedContent;

  /// Corner radius.
  final double borderRadius;

  /// Content padding.
  final EdgeInsets? padding;

  /// Background color override.
  final Color? backgroundColor;

  /// Border color override.
  final Color? borderColor;

  /// Optional leading icon.
  final IconData? icon;

  /// Whether the card starts expanded.
  final bool initiallyExpanded;

  /// Animation duration.
  final Duration? duration;

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF141419) : Colors.white);
    final border = widget.borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.06));

    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: widget.duration ?? AppDurations.normal,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: isDark ? Colors.white70 : Colors.black54,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: isDark
                                  ? Colors.white54
                                  : Colors.black45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: AppDurations.normal,
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isDark ? Colors.white38 : Colors.black26,
                    ),
                  ),
                ],
              ),

              // Collapsed content
              if (widget.collapsedContent != null && !_isExpanded) ...[
                const SizedBox(height: 12),
                widget.collapsedContent!,
              ],

              // Expanded content
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: widget.expandedContent ?? const SizedBox.shrink(),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.duration ?? AppDurations.normal,
                sizeCurve: Curves.easeOutCubic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
