import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uikit/core/constants/app_radius.dart';
import 'package:uikit/core/constants/app_spacing.dart';
import 'package:uikit/core/extensions/context_extensions.dart';

/// A styled code display widget with copy functionality.
///
/// Shows Dart code in a monospace font with a copy button.
/// Used in component preview screens to display usage examples.
class CodeBlock extends StatefulWidget {
  const CodeBlock({
    required this.code,
    super.key,
    this.language = 'dart',
  });

  /// The code string to display.
  final String code;

  /// Programming language label.
  final String language;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.04)
            : const Color(0xFFF8F9FC),
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: context.colors.outline.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.colors.outline.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.language,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _copyToClipboard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _copied
                        ? Row(
                            key: const ValueKey('copied'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: context.colors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Copied',
                                style:
                                    context.textTheme.labelSmall?.copyWith(
                                  color: context.colors.primary,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey('copy'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.copy_rounded,
                                size: 14,
                                color: context.colors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Copy',
                                style:
                                    context.textTheme.labelSmall?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SelectableText(
              widget.code,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
