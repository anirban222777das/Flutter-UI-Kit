import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uikit/core/extensions/context_extensions.dart';

enum SubmitState { none, loading, success }

/// A premium, Apple-inspired feedback screen with solid pastel colors,
/// heavy contrasting typography, and fluid face morphing.
class PremiumFeedbackForm extends StatefulWidget {
  const PremiumFeedbackForm({super.key});

  @override
  State<PremiumFeedbackForm> createState() => _PremiumFeedbackFormState();
}

class _PremiumFeedbackFormState extends State<PremiumFeedbackForm>
    with TickerProviderStateMixin {
  /// The main state value: 0.0 (BAD) -> 0.5 (NOT BAD) -> 1.0 (GOOD)
  double _value = 1.0; // Start at GOOD based on typical default
  double _dragValue = 1.0;
  bool _isDragging = false;
  String _previousMood = 'GOOD';
  bool _slideRight = true;

  // New states for Note and Submit flow
  bool _isAddingNote = false;
  SubmitState _submitState = SubmitState.none;
  late TextEditingController _noteController;
  late FocusNode _noteFocusNode;

  late AnimationController _springController;
  late Animation<double> _springAnimation;

  // Background colors
  static const Color _bgBad = Color(0xFFFF8A75);
  static const Color _bgNeutral = Color(0xFFFFD464);
  static const Color _bgGood = Color(0xFFD6F67D);

  // Dynamic Dark Element colors
  static const Color _darkBad = Color(0xFF8B1D15);
  static const Color _darkNeutral = Color(0xFF6B4C12);
  static const Color _darkGood = Color(0xFF285C20);

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(vsync: this);
    _noteController = TextEditingController();
    _noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _springController.dispose();
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _springController.stop();
    _isDragging = true;
    HapticFeedback.lightImpact();
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details, double trackWidth) {
    setState(() {
      _dragValue += details.delta.dx / trackWidth;
      _dragValue = _dragValue.clamp(0.0, 1.0);
      _updateValue(_dragValue);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _isDragging = false;
    double target;
    if (_value < 0.33) {
      target = 0.0;
    } else if (_value > 0.66) {
      target = 1.0;
    } else {
      target = 0.5;
    }

    HapticFeedback.mediumImpact();
    _animateToTarget(target);
  }

  void _onTrackTap(double percent) {
    _isDragging = true;
    _dragValue = percent.clamp(0.0, 1.0);
    
    double target;
    if (_dragValue < 0.33) {
      target = 0.0;
    } else if (_dragValue > 0.66) {
      target = 1.0;
    } else {
      target = 0.5;
    }
    
    HapticFeedback.selectionClick();
    _isDragging = false;
    _animateToTarget(target);
  }

  void _updateValue(double newValue) {
    _value = newValue;
    final currentMood = _moodText;
    if (currentMood != _previousMood) {
      // Determine direction for text slide animation
      _slideRight = _value > (_previousMood == 'BAD' ? 0.0 : _previousMood == 'NOT BAD' ? 0.5 : 1.0);
      _previousMood = currentMood;
      HapticFeedback.selectionClick();
    }
  }

  void _animateToTarget(double target) {
    _springAnimation = _springController.drive(Tween<double>(begin: _value, end: target));
    _springAnimation.addListener(() {
      setState(() {
        _updateValue(_springAnimation.value);
      });
    });

    // Premium Apple-like spring simulation
    final simulation = SpringSimulation(
      const SpringDescription(mass: 1, stiffness: 300, damping: 25),
      0.0,
      1.0,
      0.0,
    );
    _springController.animateWith(simulation);
    _dragValue = target;
  }

  void _toggleNote() {
    setState(() {
      _isAddingNote = !_isAddingNote;
      if (_isAddingNote) {
        _noteFocusNode.requestFocus();
      } else {
        _noteFocusNode.unfocus();
        _noteController.clear();
      }
    });
  }

  void _submitFeedback() {
    if (_submitState != SubmitState.none) return;

    _noteFocusNode.unfocus();
    HapticFeedback.heavyImpact();
    
    setState(() {
      _submitState = SubmitState.loading;
    });

    // Simulate network/loading delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      setState(() {
        _submitState = SubmitState.success;
      });

      // Auto close after 2 seconds of showing success
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    });
  }

  Color get _bgColor {
    if (_value < 0.5) {
      return Color.lerp(_bgBad, _bgNeutral, Curves.easeInOut.transform(_value * 2))!;
    } else {
      return Color.lerp(_bgNeutral, _bgGood, Curves.easeInOut.transform((_value - 0.5) * 2))!;
    }
  }

  Color get _darkColor {
    if (_value < 0.5) {
      return Color.lerp(_darkBad, _darkNeutral, Curves.easeInOut.transform(_value * 2))!;
    } else {
      return Color.lerp(_darkNeutral, _darkGood, Curves.easeInOut.transform((_value - 0.5) * 2))!;
    }
  }

  String get _moodText {
    if (_value < 0.25) return 'BAD';
    if (_value > 0.75) return 'GOOD';
    return 'NOT BAD';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allow keyboard to push UI up naturally
      backgroundColor: _bgColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeInCubic,
        child: _submitState != SubmitState.none ? _buildSubmitScreen() : _buildFormScreen(),
      ),
    );
  }

  Widget _buildFormScreen() {
    return SafeArea(
      child: Column(
        children: [
          // Smoothly hide top bar and title when writing a note
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: _isAddingNote ? const SizedBox(width: double.infinity) : _buildTopBar(),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: _isAddingNote ? const SizedBox(width: double.infinity) : _buildTitle(),
          ),
          
          const Spacer(flex: 2),
          
          // Dramatically shrink the face to make room for keyboard
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            height: _isAddingNote ? 100 : 180,
            alignment: Alignment.center,
            child: AnimatedScale(
              scale: _isAddingNote ? 0.55 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: _buildFaceArea(),
            ),
          ),
          
          const Spacer(flex: 1),
          
          // Hide mood text when writing note to save vertical space
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: _isAddingNote ? const SizedBox(width: double.infinity) : _buildMoodText(),
          ),
          
          const Spacer(flex: 2),
          _buildSlider(),
          
          // The note text area smoothly expands into view
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            child: _isAddingNote ? _buildNoteInput() : const SizedBox(width: double.infinity),
          ),
          
          const Spacer(flex: 1),
          _buildBottomActions(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSubmitScreen() {
    return Center(
      key: const ValueKey('submit'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: _darkColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeInQuint,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: RotationTransition(
                    turns: Tween<double>(begin: -0.2, end: 0).animate(animation),
                    child: FadeTransition(
                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn), 
                      child: child
                    ),
                  ),
                );
              },
              child: _submitState == SubmitState.loading
                  ? SizedBox(
                      key: const ValueKey('loader'),
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        color: _darkColor,
                        strokeWidth: 5,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : Icon(
                      Icons.check_rounded,
                      key: const ValueKey('check'),
                      size: 80,
                      color: _darkColor,
                    ),
            ),
          ).animate(target: _submitState == SubmitState.success ? 1 : 0)
           .scaleXY(end: 1.1, duration: 200.ms, curve: Curves.easeOut)
           .then()
           .scaleXY(end: 1.0, duration: 500.ms, curve: Curves.elasticOut),
          
          const SizedBox(height: 48),
          
          AnimatedSize(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            child: _submitState == SubmitState.success
                ? Column(
                    children: [
                      Text(
                        'Thank you for your feedback!',
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: _darkColor,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ).animate()
                       .blurXY(begin: 10, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
                       .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutBack)
                       .fadeIn(duration: 600.ms),
                       
                      if (_noteController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                          child: Text(
                            'We appreciate your detailed note.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: _darkColor.withValues(alpha: 0.6),
                            ),
                          ).animate(delay: 150.ms)
                           .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOutCubic)
                           .fadeIn(duration: 500.ms),
                        ),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          )
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDarkIconButton(Icons.close_rounded, () => Navigator.of(context).pop()),
          _buildDarkIconButton(Icons.info_outline_rounded, () {}),
        ],
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0, curve: Curves.easeOut),
    );
  }

  Widget _buildDarkIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _darkColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: _darkColor, size: 20),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Text(
        'How was your shopping\nexperience?',
        textAlign: TextAlign.center,
        style: context.textTheme.titleMedium?.copyWith(
          color: _darkColor,
          fontWeight: FontWeight.w600,
          height: 1.2,
          letterSpacing: -0.2,
        ),
      ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: -0.1, end: 0, curve: Curves.easeOut),
    );
  }

  Widget _buildFaceArea() {
    final yOffset = (_value - 0.5) * -10.0;
    
    return RepaintBoundary(
      child: Transform.translate(
        offset: Offset(0, yOffset),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: _isDragging ? 1.04 : 1.0),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: SizedBox(
                width: 240,
                height: 180,
                child: CustomPaint(
                  painter: _FeedbackFacePainter(
                    emotion: _value,
                    color: _darkColor,
                  ),
                ),
              ),
            );
          },
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms).scale(curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
    );
  }

  Widget _buildMoodText() {
    return SizedBox(
      height: 100,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final offsetTween = Tween<Offset>(
              begin: Offset(_slideRight ? 0.3 : -0.3, 0),
              end: Offset.zero,
            );
            return SlideTransition(
              position: offsetTween.animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Text(
            _moodText,
            key: ValueKey<String>(_moodText),
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: _darkColor.withValues(alpha: 0.3),
              letterSpacing: -2,
              height: 1.0,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
      ),
    );
  }

  Widget _buildSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth;
              final thumbSize = _isDragging ? 44.0 : 36.0;
              final maxDx = trackWidth - thumbSize;
              final dx = (_value * maxDx).clamp(0.0, maxDx);

              return GestureDetector(
                onTapDown: (details) => _onTrackTap(details.localPosition.dx / trackWidth),
                onPanStart: _onPanStart,
                onPanUpdate: (d) => _onPanUpdate(d, maxDx),
                onPanEnd: _onPanEnd,
                onPanCancel: () => _onPanEnd(DragEndDetails()),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: _darkColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      _buildTrackDot(0.0, trackWidth, thumbSize),
                      _buildTrackDot(0.5, trackWidth, thumbSize),
                      _buildTrackDot(1.0, trackWidth, thumbSize),
                      Container(
                        height: 4,
                        width: dx + thumbSize / 2,
                        decoration: BoxDecoration(
                          color: _darkColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Positioned(
                        left: dx,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 36.0, end: thumbSize),
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOutBack,
                          builder: (context, size, child) {
                            return Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                color: _darkColor,
                                shape: BoxShape.circle,
                              ),
                              child: CustomPaint(
                                painter: _ThumbFacePainter(
                                  emotion: _value,
                                  color: _bgColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSliderLabel('Bad', 0.0),
              _buildSliderLabel('Not bad', 0.5),
              _buildSliderLabel('Good', 1.0),
            ],
          ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildTrackDot(double percent, double trackWidth, double thumbSize) {
    final maxDx = trackWidth - thumbSize;
    final left = (percent * maxDx) + thumbSize / 2 - 3;
    return Positioned(
      left: left,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: _darkColor.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildSliderLabel(String text, double targetValue) {
    final isActive = (_value - targetValue).abs() < 0.2;
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        color: _darkColor.withValues(alpha: isActive ? 0.8 : 0.4),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 24),
      child: TextField(
        controller: _noteController,
        focusNode: _noteFocusNode,
        maxLines: 3,
        style: TextStyle(
          color: _darkColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: _darkColor,
        decoration: InputDecoration(
          hintText: 'Tell us what could be better...',
          hintStyle: TextStyle(
            color: _darkColor.withValues(alpha: 0.4),
            fontSize: 16,
          ),
          filled: true,
          fillColor: _darkColor.withValues(alpha: 0.08),
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: _darkColor.withValues(alpha: 0.3), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Add Note / Cancel Pill
          GestureDetector(
            onTap: _toggleNote,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: _isAddingNote 
                  ? Colors.transparent 
                  : _darkColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _isAddingNote ? _darkColor.withValues(alpha: 0.3) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _isAddingNote ? 'Cancel' : 'Add note',
                  key: ValueKey(_isAddingNote),
                  style: TextStyle(
                    color: _darkColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          // Submit Button
          GestureDetector(
            onTap: _submitFeedback,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: _darkColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Submit',
                    style: TextStyle(
                      color: _bgColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: _bgColor, size: 18),
                ],
              ),
            ),
          ),
        ],
      ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.2, end: 0),
    );
  }
}

class _FeedbackFacePainter extends CustomPainter {
  final double emotion;
  final Color color;

  _FeedbackFacePainter({
    required this.emotion,
    required this.color,
  });

  double _smoothLerp(double a, double b, double c, double t) {
    double smoothedT = Curves.easeInOutCubic.transform(t);
    if (smoothedT < 0.5) {
      return lerpDouble(a, b, smoothedT * 2)!;
    } else {
      return lerpDouble(b, c, (smoothedT - 0.5) * 2)!;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final eyeCenterY = size.height * 0.35;
    final leftEyeX = size.width * 0.28;
    final rightEyeX = size.width * 0.72;

    final eyeW = _smoothLerp(50, 90, 100, emotion);
    final eyeH = _smoothLerp(50, 25, 100, emotion);
    final eyeR = _smoothLerp(25, 12.5, 50, emotion);

    final leftEyeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(leftEyeX, eyeCenterY), width: eyeW, height: eyeH),
      Radius.circular(eyeR),
    );
    final rightEyeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(rightEyeX, eyeCenterY), width: eyeW, height: eyeH),
      Radius.circular(eyeR),
    );

    canvas.drawRRect(leftEyeRect, paint);
    canvas.drawRRect(rightEyeRect, paint);

    final mouthYBase = size.height * 0.75;
    
    final mouthW_0 = size.width * 0.45;
    final mouthW_5 = size.width * 0.45;
    final mouthW_1 = size.width * 0.30;
    final mouthWidth = _smoothLerp(mouthW_0, mouthW_5, mouthW_1, emotion);
    
    final startX = size.width / 2 - mouthWidth / 2;
    final midX = size.width / 2;
    final endX = size.width / 2 + mouthWidth / 2;

    final p0y_0 = mouthYBase + 10;
    final p1y_0 = mouthYBase - 20;
    final p2y_0 = mouthYBase - 20;
    final p3y_0 = mouthYBase - 20;
    final p4y_0 = mouthYBase + 10;

    final p0y_5 = mouthYBase + 5;
    final p1y_5 = mouthYBase - 5;
    final p2y_5 = mouthYBase - 5;
    final p3y_5 = mouthYBase - 5;
    final p4y_5 = mouthYBase + 5;

    final p0y_1 = mouthYBase - 10;
    final p1y_1 = mouthYBase + 25;
    final p2y_1 = mouthYBase + 25;
    final p3y_1 = mouthYBase + 25;
    final p4y_1 = mouthYBase - 10;

    final p0y = _smoothLerp(p0y_0, p0y_5, p0y_1, emotion);
    final p1y = _smoothLerp(p1y_0, p1y_5, p1y_1, emotion);
    final p2y = _smoothLerp(p2y_0, p2y_5, p2y_1, emotion);
    final p3y = _smoothLerp(p3y_0, p3y_5, p3y_1, emotion);
    final p4y = _smoothLerp(p4y_0, p4y_5, p4y_1, emotion);

    final p1x = startX + (midX - startX) * 0.4;
    final p3x = midX + (endX - midX) * 0.6;

    final path = Path();
    path.moveTo(startX, p0y);
    path.quadraticBezierTo(p1x, p1y, midX, p2y);
    path.quadraticBezierTo(p3x, p3y, endX, p4y);

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_FeedbackFacePainter oldDelegate) {
    return oldDelegate.emotion != emotion || oldDelegate.color != color;
  }
}

class _ThumbFacePainter extends CustomPainter {
  final double emotion;
  final Color color;

  _ThumbFacePainter({required this.emotion, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    
    final startX = w * 0.3;
    final endX = w * 0.7;
    final midX = w * 0.5;
    final yBase = h * 0.55;

    double sy, cy, ey;
    if (emotion > 0.66) {
      sy = yBase - 2;
      cy = yBase + 6;
      ey = yBase - 2;
    } else {
      sy = yBase + 2;
      cy = yBase - 4;
      ey = yBase + 2;
    }

    final path = Path();
    path.moveTo(startX, sy);
    path.quadraticBezierTo(midX, cy, endX, ey);

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(_ThumbFacePainter oldDelegate) {
    return oldDelegate.emotion != emotion || oldDelegate.color != color;
  }
}
