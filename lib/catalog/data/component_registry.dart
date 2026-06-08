import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uikit/components/buttons/apple_liquid_glass_button.dart';
import 'package:uikit/components/buttons/expandable_button.dart';
import 'package:uikit/components/buttons/floating_action_button_custom.dart';
import 'package:uikit/components/buttons/glass_button.dart';
import 'package:uikit/components/buttons/glow_button.dart';
import 'package:uikit/components/buttons/gradient_button.dart';
import 'package:uikit/components/buttons/ios_button.dart';
import 'package:uikit/components/buttons/liquid_button.dart';
import 'package:uikit/components/buttons/liquid_glass_button/liquid_glass_button.dart';
import 'package:uikit/components/buttons/magnetic_button.dart';
import 'package:uikit/components/buttons/neumorphic_button.dart';
import 'package:uikit/components/buttons/premium_frosted_button.dart';
import 'package:uikit/components/buttons/premium_theme_toggle.dart';
import 'package:uikit/components/buttons/push_3d_button.dart';
import 'package:uikit/components/buttons/shimmer_button.dart';
import 'package:uikit/components/buttons/swipe_button.dart';
import 'package:uikit/components/cards/animated_info_card.dart';
import 'package:uikit/components/cards/dashboard_card.dart';
import 'package:uikit/components/cards/expandable_card.dart';
import 'package:uikit/components/cards/glass_card.dart';
import 'package:uikit/components/loaders/liquid_loader.dart';
import 'package:uikit/components/loaders/morph_loader.dart';
import 'package:uikit/components/loaders/orbit_loader.dart';
import 'package:uikit/components/loaders/pulse_loader.dart';
import 'package:uikit/components/loaders/squish_liquid_glass_loader.dart';
import 'package:uikit/components/navigation/chromatic_ripple_navbar.dart';
import 'package:uikit/components/navigation/glow_indicator_navbar.dart';
import 'package:uikit/components/navigation/liquid_glass_navbar.dart';
import 'package:uikit/components/navigation/morphing_island_navbar.dart';
import 'package:uikit/components/navigation/premium_floating_navbar.dart';
import 'package:uikit/components/textfields/animated_search_bar.dart';
import 'package:uikit/components/textfields/floating_label_field.dart';
import 'package:uikit/components/textfields/glass_input.dart';
import 'package:uikit/components/textfields/ios_search_field.dart';
import 'package:uikit/components/textfields/underline_input.dart';
import 'package:uikit/components/feedback/premium_feedback_form.dart';
import 'package:uikit/core/theme/app_colors.dart';
import 'package:uikit/shared/models/component_model.dart';

/// Central registry for all component categories and items.
///
/// This is the single source of truth for the catalog.
/// Adding new components only requires registering them here.
abstract final class ComponentRegistry {
  // ──────────────────────────────────────────────
  // Categories
  // ──────────────────────────────────────────────

  static List<ComponentCategory> get categories => [
    const ComponentCategory(
      id: 'buttons',
      name: 'Buttons',
      description:
          'Premium interactive button components with rich animations and effects',
      icon: Icons.smart_button_rounded,
      accentColor: AppColors.accentPurple,
      componentCount: 16,
    ),
    const ComponentCategory(
      id: 'cards',
      name: 'Cards',
      description:
          'Versatile card layouts with glass effects, expansion, and data display',
      icon: Icons.credit_card_rounded,
      accentColor: AppColors.accentBlue,
      componentCount: 4,
    ),
    const ComponentCategory(
      id: 'loaders',
      name: 'Loaders',
      description:
          'Smooth animated loading indicators with liquid, orbital, and morphing effects',
      icon: Icons.hourglass_top_rounded,
      accentColor: AppColors.accentTeal,
      componentCount: 5,
    ),
    const ComponentCategory(
      id: 'textfields',
      name: 'TextFields',
      description:
          'Polished text input components with floating labels, glass effects, and iOS styling',
      icon: Icons.text_fields_rounded,
      accentColor: AppColors.accentOrange,
      componentCount: 5,
    ),
    const ComponentCategory(
      id: 'navbars',
      name: 'Navbars',
      description:
          'Premium navigation bars with glassmorphism and spring animations',
      icon: Icons.horizontal_split_rounded,
      accentColor: AppColors.accentPink,
      componentCount: 5,
    ),
    const ComponentCategory(
      id: 'feedback',
      name: 'Feedback',
      description:
          'Emotionally reactive feedback forms with advanced physics and fluid morphing animations',
      icon: Icons.sentiment_satisfied_alt_rounded,
      accentColor: AppColors.accentAmber,
      componentCount: 1,
    ),
  ];

  // ──────────────────────────────────────────────
  // All components
  // ──────────────────────────────────────────────

  static List<ComponentItem> get allComponents => [
    ..._buttonComponents,
    ..._cardComponents,
    ..._loaderComponents,
    ..._textFieldComponents,
    ..._navigationComponents,
    ..._feedbackComponents,
  ];

  // ──────────────────────────────────────────────
  // Buttons
  // ──────────────────────────────────────────────

  static final List<ComponentItem> _buttonComponents = [
    ComponentItem(
      id: 'glass_button',
      name: 'Glass Button',
      description:
          'A premium glass-morphism button with frosted backdrop blur. '
          'Features translucent surface with configurable blur, border glow, '
          'and smooth tap-scale animation.',
      categoryId: 'buttons',
      tags: ['glass', 'blur', 'premium', 'translucent'],
      features: [
        'Configurable backdrop blur intensity',
        'Adjustable glass opacity and border color',
        'Smooth scale animation on press',
        'Optional leading icon support',
        'Adapts to dark/light theme',
      ],
      dependencies: ['dart:ui (BackdropFilter)'],
      usageExample: '''GlassButton(
  text: 'Continue',
  onPressed: () {},
  blur: 20,
  borderRadius: 24,
  height: 56,
)''',
      implementationNotes:
          'Uses BackdropFilter for the frosted glass effect. '
          'Wrap in a Stack with a background for visible blur.',
      previewBuilder: () => const GlassButton(
        text: 'Glass Button',
        icon: Icons.auto_awesome_rounded,
      ),
    ),
    ComponentItem(
      id: 'liquid_button',
      name: 'Liquid Button',
      description:
          'A button with fluid morphing shape and gradient color transitions. '
          'Smoothly shifts border radius and gradient on press.',
      categoryId: 'buttons',
      tags: ['liquid', 'gradient', 'morph', 'animated'],
      features: [
        'Morphing border radius on press',
        'Gradient color shift animation',
        'Elevated shadow follows gradient color',
        'Spring-back animation feel',
      ],
      dependencies: [],
      usageExample: '''LiquidButton(
  text: 'Submit',
  onPressed: () {},
  colors: [Colors.purple, Colors.blue],
)''',
      previewBuilder: () => const LiquidButton(
        text: 'Liquid Button',
        icon: Icons.water_drop_rounded,
      ),
    ),
    ComponentItem(
      id: 'magnetic_button',
      name: 'Magnetic Button',
      description:
          'A button that subtly follows finger position, creating a '
          'magnetic attraction effect with spring-back on release.',
      categoryId: 'buttons',
      tags: ['magnetic', 'interactive', 'spring', 'touch-tracking'],
      features: [
        'Tracks finger/pointer position',
        'Configurable magnetic strength',
        'Spring-back animation on release',
        'Shadow follows button offset',
      ],
      dependencies: [],
      usageExample: '''MagneticButton(
  text: 'Explore',
  onPressed: () {},
  magneticStrength: 0.3,
)''',
      previewBuilder: () => const MagneticButton(
        text: 'Magnetic Button',
        icon: Icons.attractions_rounded,
      ),
    ),
    ComponentItem(
      id: 'gradient_button',
      name: 'Gradient Button',
      description:
          'A button with a continuously animated gradient sweep effect. '
          'The gradient shifts smoothly creating a shimmering surface.',
      categoryId: 'buttons',
      tags: ['gradient', 'animated', 'shimmer', 'continuous'],
      features: [
        'Continuous gradient animation',
        'Configurable gradient colors',
        'Adjustable animation speed',
        'Elevated shadow with color',
      ],
      dependencies: [],
      usageExample: '''GradientButton(
  text: 'Get Started',
  onPressed: () {},
  elevation: 6,
)''',
      previewBuilder: () => const GradientButton(
        text: 'Gradient Button',
        icon: Icons.gradient_rounded,
      ),
    ),
    ComponentItem(
      id: 'ios_button',
      name: 'iOS Button',
      description:
          'A Cupertino-inspired button with opacity-based press feedback. '
          'Supports filled, tinted, and plain visual styles.',
      categoryId: 'buttons',
      tags: ['ios', 'cupertino', 'native', 'minimal'],
      features: [
        'Three style variants: filled, tinted, plain',
        'Native iOS opacity press feedback',
        'Configurable accent color',
        'Subtle scale-down animation',
      ],
      dependencies: [],
      usageExample: '''IosButton(
  text: 'Done',
  onPressed: () {},
  style: IosButtonStyle.filled,
  color: Colors.blue,
)''',
      previewBuilder: () => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IosButton(text: 'Filled', style: IosButtonStyle.filled),
          SizedBox(width: 8),
          IosButton(text: 'Tinted', style: IosButtonStyle.tinted),
        ],
      ),
    ),
    ComponentItem(
      id: 'floating_action_button_custom',
      name: 'Expandable FAB',
      description:
          'An expandable floating action button that reveals multiple '
          'action items with staggered spring animations.',
      categoryId: 'buttons',
      tags: ['fab', 'expandable', 'radial', 'menu'],
      features: [
        'Staggered spring item animations',
        'Labeled mini-FAB items',
        'Rotating icon on expand',
        'Auto-collapse on item selection',
      ],
      dependencies: ['dart:math'],
      usageExample: '''FloatingActionButtonCustom(
  icon: Icons.add,
  items: [
    FabItem(icon: Icons.photo, label: 'Photo', onTap: () {}),
    FabItem(icon: Icons.video_call, label: 'Video', onTap: () {}),
  ],
)''',
      previewBuilder: () => FloatingActionButtonCustom(
        items: [
          FabItem(icon: Icons.photo_rounded, label: 'Photo', onTap: () {}),
          FabItem(
            icon: Icons.videocam_rounded,
            label: 'Video',
            onTap: () {},
          ),
        ],
      ),
    ),
    ComponentItem(
      id: 'expandable_button',
      name: 'Expandable Button',
      description:
          'A button that expands from icon-only to full text+icon on tap. '
          'Animates width and fades in text content.',
      categoryId: 'buttons',
      tags: ['expandable', 'icon', 'progressive', 'animated'],
      features: [
        'Smooth width animation',
        'Fade-in text reveal',
        'Toggle expand/collapse on tap',
        'Configurable expanded width',
      ],
      dependencies: [],
      usageExample: '''ExpandableButton(
  icon: Icons.add_rounded,
  expandedText: 'New Item',
  onPressed: () {},
)''',
      previewBuilder: () => const ExpandableButton(
        icon: Icons.add_rounded,
        expandedText: 'New Item',
      ),
    ),
    ComponentItem(
      id: 'shimmer_button',
      name: 'Shimmer Button',
      description:
          'A premium button with a continuous shimmering highlight effect. '
          'Features an animated gradient sweep that creates a luminous shine.',
      categoryId: 'buttons',
      tags: ['shimmer', 'shine', 'premium', 'metallic'],
      features: [
        'Continuous animated shimmer sweep',
        'Configurable shimmer and base colors',
        'Smooth scale animation on press',
        'Optional leading icon support',
      ],
      dependencies: [],
      usageExample: '''ShimmerButton(
  text: 'Upgrade to Pro',
  onPressed: () {},
  shimmerColor: Colors.white24,
)''',
      previewBuilder: () => const ShimmerButton(
        text: 'Upgrade to Pro',
        icon: Icons.workspace_premium_rounded,
      ),
    ),
    ComponentItem(
      id: 'glow_button',
      name: 'Glow Button',
      description:
          'A vibrant button that pulsates with a glowing shadow. '
          'Features an animated drop shadow that breathes, giving a neon feel.',
      categoryId: 'buttons',
      tags: ['glow', 'neon', 'pulsate', 'shadow'],
      features: [
        'Pulsating shadow animation',
        'Configurable glow color',
        'Intensified glow on press',
        'Smooth scale down interaction',
      ],
      dependencies: [],
      usageExample: '''GlowButton(
  text: 'Live Now',
  onPressed: () {},
  color: Colors.redAccent,
)''',
      previewBuilder: () => const GlowButton(
        text: 'Live Now',
        icon: Icons.sensors_rounded,
        color: Color(0xFFEC4899),
      ),
    ),
    ComponentItem(
      id: 'neumorphic_button',
      name: 'Neumorphic Button',
      description:
          'A button utilizing soft UI design, appearing extruded from the background. '
          'Shadows invert to an inset look when pressed.',
      categoryId: 'buttons',
      tags: ['neumorphic', 'soft-ui', 'extruded', 'inset'],
      features: [
        'Dual shadow soft UI design',
        'Invert shadows on press',
        'Adapts to light and dark themes',
        'Highly tactile interaction',
      ],
      dependencies: [],
      usageExample: '''NeumorphicButton(
  text: 'Settings',
  onPressed: () {},
)''',
      previewBuilder: () => const NeumorphicButton(
        text: 'Settings',
        icon: Icons.settings_rounded,
      ),
    ),
    ComponentItem(
      id: 'push_3d_button',
      name: 'Push 3D Button',
      description:
          'A highly tactile, 3D pushable button with a thick bottom lip '
          'that compresses on tap.',
      categoryId: 'buttons',
      tags: ['3d', 'push', 'tactile', 'arcade'],
      features: [
        'Physical push-down animation',
        'Calculated bottom lip color',
        'Configurable 3D depth',
        'Mechanical keyboard feel',
      ],
      dependencies: [],
      usageExample: '''Push3DButton(
  text: 'Submit',
  onPressed: () {},
  depth: 8.0,
)''',
      previewBuilder: () => const Push3DButton(
        text: 'Submit',
        icon: Icons.publish_rounded,
      ),
    ),
    ComponentItem(
      id: 'swipe_button',
      name: 'Swipe Button',
      description:
          'A highly interactive "slide to confirm" button. '
          'The user must drag a thumb to the right to trigger the action.',
      categoryId: 'buttons',
      tags: ['swipe', 'slide', 'confirm', 'interactive'],
      features: [
        'Drag-to-confirm interaction',
        'Automatic spring back on incomplete swipe',
        'Success state animation',
        'Opacity fade on text during swipe',
      ],
      dependencies: [],
      usageExample: '''SwipeButton(
  text: 'Slide to Pay',
  onSwipeComplete: () => print('Paid!'),
)''',
      previewBuilder: () => SwipeButton(
        text: 'Slide to Pay',
        width: 260,
        onSwipeComplete: () {},
      ),
    ),
    ComponentItem(
      id: 'liquid_glass_button',
      name: 'Liquid Glass Button',
      description:
          'A premium, production-ready component that perfectly simulates liquid glass '
          'UI materials with layered translucency and optical reflections.',
      categoryId: 'buttons',
      tags: ['glass', 'liquid', 'premium', 'visionos', 'optical'],
      features: [
        'Responsive optical translucency',
        'Specular highlights and edge lighting',
        'Physical depth compression on press',
        'Optimized RepaintBoundary rendering',
      ],
      dependencies: [],
      usageExample: '''LiquidGlassButton(
  text: 'Continue',
  variant: LiquidGlassButtonVariant.primary,
  onPressed: () {},
)''',
      previewBuilder: () => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFF10B981)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LiquidGlassButton(
          text: 'Continue',
          icon: Icons.auto_awesome_rounded,
          onPressed: () {},
        ),
      ),
    ),
    ComponentItem(
      id: 'apple_liquid_glass_button',
      name: 'Apple Liquid Glass Button',
      description:
          'A production-focused Liquid Glass control inspired by Apple’s '
          'native material language. It preserves background context, '
          'concentrates light at the rim, and responds with restrained fluid '
          'touch feedback.',
      categoryId: 'buttons',
      tags: ['apple', 'liquid-glass', 'adaptive', 'native', 'optical'],
      features: [
        'Regular and clear Liquid Glass material variants',
        'Background color passthrough with adaptive opacity',
        'Crisp rim light, inner lens edge, and shadow depth',
        'Subtle pointer-aware light concentration',
        'No idle animation for cheaper production rendering',
        'Respects high contrast and disabled animation settings',
      ],
      dependencies: ['dart:ui (BackdropFilter)'],
      usageExample: '''AppleLiquidGlassButton(
  text: 'Continue',
  icon: Icons.auto_awesome_rounded,
  onPressed: () {},
  material: AppleLiquidGlassMaterial.iosFrosted,
)''',
      implementationNotes:
          'Use this as a floating functional control over meaningful content. '
          'Prefer iosFrosted for general interfaces, and visionOsClear for '
          'highly visual interfaces with vivid colorful backgrounds.',
      previewBuilder: () => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E3A8A),
              Color(0xFF7C3AED),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const _LiquidGlassPreviewContent(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppleLiquidGlassButton(
                  text: 'iOS Frosted',
                  icon: Icons.apple_rounded,
                  width: 220,
                  material: AppleLiquidGlassMaterial.iosFrosted,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                AppleLiquidGlassButton(
                  text: 'visionOS Clear',
                  icon: Icons.view_in_ar_rounded,
                  width: 220,
                  material: AppleLiquidGlassMaterial.visionOsClear,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    ComponentItem(
      id: 'premium_theme_toggle',
      name: 'Premium Theme Toggle',
      description:
          'A highly polished, web-inspired animated theme toggle switch with '
          'simulated physical depth and optical thumb highlights.',
      categoryId: 'buttons',
      tags: ['toggle', 'switch', 'theme', 'premium', 'dark-mode'],
      features: [
        'Simulated recessed track',
        'Physical raised thumb with highlights',
        'Animated icon scaling',
        'Dynamic text cross-fading',
      ],
      dependencies: [],
      usageExample: '''PremiumThemeToggle(
  isDark: true,
  onChanged: (val) {},
)''',
      previewBuilder: () => StatefulBuilder(
        builder: (context, setState) {
          // Use a local state variable so the preview is interactive
          bool isDark = true;
          return StatefulBuilder(
            builder: (context, setLocalState) => PremiumThemeToggle(
              isDark: isDark,
              onChanged: (val) => setLocalState(() => isDark = val),
            ),
          );
        },
      ),
    ),
    ComponentItem(
      id: 'premium_frosted_button',
      name: 'Premium Frosted Button',
      description:
          'A modern web-inspired glassmorphism button featuring a refractive '
          'white frosted body and an optional dark action circle.',
      categoryId: 'buttons',
      tags: ['frosted', 'glass', 'premium', 'action'],
      features: [
        'True optical BackdropFilter refraction',
        'Dynamic edge lighting and bevel',
        'Optional embedded dark action thumb',
        'Smooth scaling and hover states',
      ],
      dependencies: [],
      usageExample: '''PremiumFrostedButton(
  text: 'Get started',
  actionIcon: Icons.chevron_right_rounded,
  onPressed: () {},
)''',
      previewBuilder: () => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1), Color(0xFF94A3B8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PremiumFrostedButton(
              text: 'Get started',
              actionIcon: Icons.chevron_right_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            PremiumFrostedButton(
              text: 'Get Started',
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
  ];

  // ──────────────────────────────────────────────
  // Navigation
  // ──────────────────────────────────────────────

  static final List<ComponentItem> _navigationComponents = [
    ComponentItem(
      id: 'liquid_glass_navbar',
      name: 'Liquid Glass NavBar',
      description:
          'A highly polished floating dock with visionOS-style optical refraction '
          'and a bouncy, sliding glass indicator bubble.',
      categoryId: 'navbars',
      tags: ['navigation', 'dock', 'glass', 'spring', 'ios'],
      features: [
        'True BackdropFilter refraction',
        'Elastic spring-physics indicator',
        'Animated label expansion on active tab',
        'Dynamic icon scaling',
      ],
      dependencies: [],
      usageExample: '''LiquidGlassNavBar(
  selectedIndex: 0,
  onItemSelected: (i) {},
  items: const [
    LiquidNavBarItem(icon: Icons.home, label: 'Home'),
    LiquidNavBarItem(icon: Icons.analytics, label: 'Analytics'),
    LiquidNavBarItem(icon: Icons.person, label: 'Account'),
  ],
)''',
      previewBuilder: () => StatefulBuilder(
        builder: (context, setLocalState) {
          int currentIndex = 0;
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF60A5FA),
                  Color(0xFF93C5FD),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiquidGlassNavBar(
                  selectedIndex: currentIndex,
                  onItemSelected: (index) =>
                      setLocalState(() => currentIndex = index),
                  items: const [
                    LiquidNavBarItem(icon: Icons.home_rounded, label: 'Home'),
                    LiquidNavBarItem(
                      icon: Icons.analytics_rounded,
                      label: 'Analytics',
                    ),
                    LiquidNavBarItem(
                      icon: Icons.person_rounded,
                      label: 'Account',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) {
                          int fullIndex = 0;
                          return StatefulBuilder(
                            builder: (context, setFullState) {
                              return Scaffold(
                                body: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF3B82F6),
                                        Color(0xFF60A5FA),
                                        Color(0xFF93C5FD),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: SafeArea(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: FilledButton.icon(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: const Icon(
                                              Icons.close_rounded,
                                            ),
                                            label: const Text('Close Test'),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Colors.white24,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 24.0,
                                              left: 24.0,
                                              right: 24.0,
                                            ),
                                            child: LiquidGlassNavBar(
                                              selectedIndex: fullIndex,
                                              onItemSelected: (idx) =>
                                                  setFullState(
                                                    () => fullIndex = idx,
                                                  ),
                                              items: const [
                                                LiquidNavBarItem(
                                                  icon: Icons.home_rounded,
                                                  label: 'Home',
                                                ),
                                                LiquidNavBarItem(
                                                  icon: Icons.analytics_rounded,
                                                  label: 'Analytics',
                                                ),
                                                LiquidNavBarItem(
                                                  icon: Icons.person_rounded,
                                                  label: 'Account',
                                                ),
                                                LiquidNavBarItem(
                                                  icon: Icons.settings_rounded,
                                                  label: 'Settings',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Test Fullscreen',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black26,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    ComponentItem(
      id: 'premium_floating_navbar',
      name: 'Premium Floating NavBar',
      description:
          'A sleek, floating pill-shaped navbar with a sliding background highlight and frosted glass effect.',
      categoryId: 'navbars',
      tags: ['navigation', 'floating', 'glass', 'premium'],
      features: [
        'Frosted glass container',
        'Sliding background highlight',
        'Smooth icon and text scaling',
      ],
      dependencies: ['dart:ui (BackdropFilter)'],
      usageExample: '''PremiumFloatingNavBar(
  selectedIndex: 0,
  onItemSelected: (i) {},
  items: const [
    PremiumFloatingNavBarItem(icon: Icons.home_rounded, label: 'Home'),
    PremiumFloatingNavBarItem(icon: Icons.search_rounded, label: 'Search'),
    PremiumFloatingNavBarItem(icon: Icons.person_rounded, label: 'Profile'),
  ],
)''',
      previewBuilder: () => StatefulBuilder(
        builder: (context, setLocalState) {
          int currentIndex = 0;
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PremiumFloatingNavBar(
                  selectedIndex: currentIndex,
                  onItemSelected: (index) =>
                      setLocalState(() => currentIndex = index),
                  items: const [
                    PremiumFloatingNavBarItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                    ),
                    PremiumFloatingNavBarItem(
                      icon: Icons.search_rounded,
                      label: 'Search',
                    ),
                    PremiumFloatingNavBarItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) {
                          int fullIndex = 0;
                          return StatefulBuilder(
                            builder: (context, setFullState) {
                              return Scaffold(
                                body: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(0xFF111111)
                                        : const Color(0xFFF3F4F6),
                                  ),
                                  child: SafeArea(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: FilledButton.icon(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: const Icon(
                                              Icons.close_rounded,
                                            ),
                                            label: const Text('Close Test'),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 24.0,
                                              left: 24.0,
                                              right: 24.0,
                                            ),
                                            child: PremiumFloatingNavBar(
                                              selectedIndex: fullIndex,
                                              onItemSelected: (idx) =>
                                                  setFullState(
                                                    () => fullIndex = idx,
                                                  ),
                                              items: const [
                                                PremiumFloatingNavBarItem(
                                                  icon: Icons.home_rounded,
                                                  label: 'Home',
                                                ),
                                                PremiumFloatingNavBarItem(
                                                  icon: Icons.search_rounded,
                                                  label: 'Search',
                                                ),
                                                PremiumFloatingNavBarItem(
                                                  icon: Icons.person_rounded,
                                                  label: 'Profile',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Test Fullscreen',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black26,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    ComponentItem(
      id: 'glow_indicator_navbar',
      name: 'Glow Indicator NavBar',
      description:
          'A dark-themed optimized navbar featuring a vibrant neon glowing line and gradient light beam.',
      categoryId: 'navbars',
      tags: ['navigation', 'glow', 'neon', 'dark-mode'],
      features: [
        'Neon glowing indicator line',
        'Subtle light beam gradient',
        'Glowing drop shadows on active icons',
      ],
      dependencies: [],
      usageExample: '''GlowIndicatorNavBar(
  selectedIndex: 0,
  onItemSelected: (i) {},
  items: const [
    GlowIndicatorNavBarItem(icon: Icons.home_rounded, label: 'Home'),
    GlowIndicatorNavBarItem(icon: Icons.search_rounded, label: 'Search'),
    GlowIndicatorNavBarItem(icon: Icons.person_rounded, label: 'Profile'),
  ],
)''',
      previewBuilder: () => StatefulBuilder(
        builder: (context, setLocalState) {
          int currentIndex = 0;
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: Color(0xFF111111),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlowIndicatorNavBar(
                  selectedIndex: currentIndex,
                  onItemSelected: (index) =>
                      setLocalState(() => currentIndex = index),
                  items: const [
                    GlowIndicatorNavBarItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                    ),
                    GlowIndicatorNavBarItem(
                      icon: Icons.search_rounded,
                      label: 'Search',
                    ),
                    GlowIndicatorNavBarItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) {
                          int fullIndex = 0;
                          return StatefulBuilder(
                            builder: (context, setFullState) {
                              return Scaffold(
                                backgroundColor: const Color(0xFF111111),
                                body: SafeArea(
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: FilledButton.icon(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          icon: const Icon(Icons.close_rounded),
                                          label: const Text('Close Test'),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: GlowIndicatorNavBar(
                                          selectedIndex: fullIndex,
                                          onItemSelected: (idx) => setFullState(
                                            () => fullIndex = idx,
                                          ),
                                          items: const [
                                            GlowIndicatorNavBarItem(
                                              icon: Icons.home_rounded,
                                              label: 'Home',
                                            ),
                                            GlowIndicatorNavBarItem(
                                              icon: Icons.search_rounded,
                                              label: 'Search',
                                            ),
                                            GlowIndicatorNavBarItem(
                                              icon: Icons.person_rounded,
                                              label: 'Profile',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Test Fullscreen',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white24,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    ComponentItem(
      id: 'morphing_island_navbar',
      name: 'Morphing Island NavBar',
      description:
          'An animated floating navbar where the active indicator physically stretches and compresses between items.',
      categoryId: 'navbars',
      tags: ['navigation', 'island', 'morphing', 'physics'],
      features: [
        'Inertia stretching animation',
        'Dynamic width calculation',
        'Elastic physics bouncing',
      ],
      dependencies: [],
      usageExample: '''MorphingIslandNavBar(
  selectedIndex: 0,
  onItemSelected: (i) {},
  items: const [
    MorphingIslandNavBarItem(icon: Icons.home_rounded, label: 'Home'),
    MorphingIslandNavBarItem(icon: Icons.search_rounded, label: 'Search'),
    MorphingIslandNavBarItem(icon: Icons.person_rounded, label: 'Profile'),
  ],
)''',
      previewBuilder: () => StatefulBuilder(
        builder: (context, setLocalState) {
          int currentIndex = 0;
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MorphingIslandNavBar(
                  selectedIndex: currentIndex,
                  onItemSelected: (index) =>
                      setLocalState(() => currentIndex = index),
                  items: const [
                    MorphingIslandNavBarItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                    ),
                    MorphingIslandNavBarItem(
                      icon: Icons.search_rounded,
                      label: 'Search',
                    ),
                    MorphingIslandNavBarItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) {
                          int fullIndex = 0;
                          return StatefulBuilder(
                            builder: (context, setFullState) {
                              return Scaffold(
                                body: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color(0xFF111111)
                                        : const Color(0xFFE5E7EB),
                                  ),
                                  child: SafeArea(
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: FilledButton.icon(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            icon: const Icon(
                                              Icons.close_rounded,
                                            ),
                                            label: const Text('Close Test'),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 24.0,
                                            ),
                                            child: MorphingIslandNavBar(
                                              selectedIndex: fullIndex,
                                              onItemSelected: (idx) =>
                                                  setFullState(
                                                    () => fullIndex = idx,
                                                  ),
                                              items: const [
                                                MorphingIslandNavBarItem(
                                                  icon: Icons.home_rounded,
                                                  label: 'Home',
                                                ),
                                                MorphingIslandNavBarItem(
                                                  icon: Icons.search_rounded,
                                                  label: 'Search',
                                                ),
                                                MorphingIslandNavBarItem(
                                                  icon: Icons.person_rounded,
                                                  label: 'Profile',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Test Fullscreen',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black26,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    ComponentItem(
      id: 'chromatic_ripple_navbar',
      name: 'Chromatic Ripple NavBar',
      description:
          'A floating glass navbar featuring chromatic edge fringe, a stretchy liquid '
          'blob indicator with elastic overshoot, and a touch-point ripple effect '
          'over a continuously shimmering translucent surface.',
      categoryId: 'navbars',
      tags: ['navigation', 'glass', 'ripple', 'chromatic', 'liquid', 'shimmer'],
      features: [
        'CustomPaint glass container with chromatic rainbow fringe',
        'Liquid blob indicator with stretch, overshoot & elastic settle',
        'Touch-point ripple ring emanating from tap location',
        'Continuous specular shimmer sweep across bar and pill',
        'Per-item press-scale micro-interaction',
      ],
      dependencies: ['dart:ui (BackdropFilter, ImageFilter)'],
      usageExample: '''ChromaticRippleNavBar(
  selectedIndex: 0,
  onItemSelected: (i) {},
  items: const [
    ChromaticRippleNavBarItem(icon: Icons.home_rounded, label: 'Home'),
    ChromaticRippleNavBarItem(icon: Icons.explore_rounded, label: 'Explore'),
    ChromaticRippleNavBarItem(icon: Icons.person_rounded, label: 'Profile'),
  ],
)''',
      previewBuilder: () => const _DynamicChromaticPreview(),
    ),
  ];

  // ──────────────────────────────────────────────
  // Cards
  // ──────────────────────────────────────────────

  static final List<ComponentItem> _cardComponents = [
    ComponentItem(
      id: 'glass_card',
      name: 'Glass Card',
      description:
          'A frosted glass card with configurable backdrop blur. '
          'Creates a premium translucent surface effect.',
      categoryId: 'cards',
      tags: ['glass', 'blur', 'frosted', 'translucent'],
      features: [
        'Configurable backdrop blur',
        'Adjustable opacity and border',
        'Works over images/gradients',
        'Flexible content area',
      ],
      dependencies: ['dart:ui (BackdropFilter)'],
      usageExample: '''GlassCard(
  blur: 20,
  borderRadius: 20,
  child: Text('Content here'),
)''',
      previewBuilder: () => const SizedBox(
        width: 200,
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.layers_rounded, size: 28, color: Colors.white70),
              SizedBox(height: 8),
              Text(
                'Glass Card',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    ComponentItem(
      id: 'expandable_card',
      name: 'Expandable Card',
      description:
          'A tappable card that expands to reveal additional content. '
          'Uses smooth height animation with AnimatedCrossFade.',
      categoryId: 'cards',
      tags: ['expandable', 'accordion', 'disclosure', 'animated'],
      features: [
        'Smooth expand/collapse animation',
        'Rotating chevron indicator',
        'Optional collapsed content',
        'Configurable initial state',
      ],
      dependencies: [],
      usageExample: '''ExpandableCard(
  title: 'Details',
  subtitle: 'Tap to expand',
  expandedContent: Text('More content...'),
)''',
      previewBuilder: () => const SizedBox(
        width: 240,
        child: ExpandableCard(
          title: 'Details',
          subtitle: 'Tap to expand',
          icon: Icons.info_outline_rounded,
          expandedContent: Text(
            'This is the expanded content area.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 13),
          ),
        ),
      ),
    ),
    ComponentItem(
      id: 'animated_info_card',
      name: 'Animated Info Card',
      description:
          'An information card with animated entry and accent color. '
          'Features slide + fade entry animation.',
      categoryId: 'cards',
      tags: ['info', 'animated', 'entry', 'accent'],
      features: [
        'Slide + fade entry animation',
        'Gradient accent icon area',
        'Tap interaction support',
        'Configurable accent color',
      ],
      dependencies: [],
      usageExample: '''AnimatedInfoCard(
  icon: Icons.flash_on_rounded,
  title: 'Fast Performance',
  subtitle: 'Optimized for 60fps',
  accentColor: Colors.amber,
)''',
      previewBuilder: () => const SizedBox(
        width: 260,
        child: AnimatedInfoCard(
          icon: Icons.flash_on_rounded,
          title: 'Fast Performance',
          subtitle: 'Optimized for 60fps animations',
          accentColor: Color(0xFFF59E0B),
        ),
      ),
    ),
    ComponentItem(
      id: 'dashboard_card',
      name: 'Dashboard Card',
      description:
          'A metric display card with animated number counter and '
          'trend indicator, suitable for dashboards.',
      categoryId: 'cards',
      tags: ['dashboard', 'metric', 'counter', 'trend'],
      features: [
        'Animated counting number',
        'Trend direction indicator',
        'Optional icon accent',
        'Formatted large numbers (K)',
      ],
      dependencies: [],
      usageExample: '''DashboardCard(
  label: 'Revenue',
  value: 12450,
  prefix: '\\\$',
  trend: DashboardTrend.up,
  trendValue: '+12.5%',
)''',
      previewBuilder: () => const SizedBox(
        width: 200,
        child: DashboardCard(
          label: 'Revenue',
          value: 12450,
          prefix: r'$',
          trend: DashboardTrend.up,
          trendValue: '+12.5%',
          icon: Icons.attach_money_rounded,
        ),
      ),
    ),
  ];

  // ──────────────────────────────────────────────
  // Loaders
  // ──────────────────────────────────────────────

  static final List<ComponentItem> _loaderComponents = [
    ComponentItem(
      id: 'squish_liquid_glass_loader',
      name: 'Squish Liquid Glass Loader',
      description:
          'A mesmerizing loader that simulates a squishy, organic drop of liquid glass. '
          'Features true optical refraction, dynamic highlights, and organic shape morphing.',
      categoryId: 'loaders',
      tags: ['glass', 'liquid', 'squish', 'organic', 'visionos'],
      features: [
        'True optical BackdropFilter refraction',
        'Organic squishing and rotation physics',
        'Dynamic specular highlights',
        'Configurable base tint and speed',
      ],
      dependencies: ['dart:ui (BackdropFilter)', 'dart:math'],
      usageExample: '''SquishLiquidGlassLoader(
  size: 80,
  baseColor: Colors.blue,
)''',
      previewBuilder: () => const SquishLiquidGlassLoader(
        size: 72,
        baseColor: Colors.blueAccent,
      ),
    ),
    ComponentItem(
      id: 'liquid_loader',
      name: 'Liquid Loader',
      description:
          'A liquid-like animated loader with morphing blob effect. '
          'Uses CustomPainter with animated radius offsets.',
      categoryId: 'loaders',
      tags: ['liquid', 'blob', 'morph', 'organic'],
      features: [
        'Organic morphing blob shape',
        'Smooth continuous animation',
        'Configurable speed and color',
        'Fill + stroke rendering',
      ],
      dependencies: ['dart:math'],
      usageExample: '''LiquidLoader(
  size: 60,
  color: Colors.indigo,
  speed: 1.2,
)''',
      previewBuilder: () => const LiquidLoader(size: 56),
    ),
    ComponentItem(
      id: 'pulse_loader',
      name: 'Pulse Loader',
      description:
          'Pulsing dots with staggered timing. Dots scale and '
          'fade in sequence for a rhythmic loading indicator.',
      categoryId: 'loaders',
      tags: ['pulse', 'dots', 'staggered', 'rhythmic'],
      features: [
        'Staggered dot animations',
        'Configurable dot count',
        'Scale and opacity modulation',
        'Adjustable speed',
      ],
      dependencies: [],
      usageExample: '''PulseLoader(
  dotCount: 3,
  color: Colors.indigo,
  size: 48,
)''',
      previewBuilder: () => const PulseLoader(),
    ),
    ComponentItem(
      id: 'orbit_loader',
      name: 'Orbit Loader',
      description:
          'Orbiting dots rotating around a center point with '
          'trailing opacity and size effect.',
      categoryId: 'loaders',
      tags: ['orbit', 'rotating', 'trailing', 'circular'],
      features: [
        'Trailing dot opacity',
        'Decreasing dot sizes',
        'Configurable orbit radius',
        'CustomPainter rendering',
      ],
      dependencies: ['dart:math'],
      usageExample: '''OrbitLoader(
  orbitRadius: 20,
  dotCount: 5,
  color: Colors.cyan,
)''',
      previewBuilder: () => const OrbitLoader(size: 56),
    ),
    ComponentItem(
      id: 'morph_loader',
      name: 'Morph Loader',
      description:
          'Shape-morphing loader that transitions between circle, '
          'rounded square, and diamond with rotation.',
      categoryId: 'loaders',
      tags: ['morph', 'shape', 'transform', 'geometric'],
      features: [
        'Three-phase shape morphing',
        'Smooth rotation animation',
        'Configurable speed and color',
        'Fill and stroke rendering',
      ],
      dependencies: ['dart:math'],
      usageExample: '''MorphLoader(
  size: 48,
  color: Colors.purple,
  speed: 0.8,
)''',
      previewBuilder: () => const MorphLoader(size: 56),
    ),
  ];

  // ──────────────────────────────────────────────
  // TextFields
  // ──────────────────────────────────────────────

  static final List<ComponentItem> _textFieldComponents = [
    ComponentItem(
      id: 'floating_label_field',
      name: 'Floating Label Field',
      description:
          'A premium floating label text field with smooth label '
          'animation and animated border color on focus.',
      categoryId: 'textfields',
      tags: ['floating-label', 'material', 'form', 'animated'],
      features: [
        'Smooth label float animation',
        'Animated border color on focus',
        'Icon tinting on focus',
        'Configurable border radius',
      ],
      dependencies: [],
      usageExample: '''FloatingLabelField(
  label: 'Email',
  hintText: 'you@example.com',
  prefixIcon: Icons.email_outlined,
)''',
      previewBuilder: () => const SizedBox(
        width: 240,
        child: FloatingLabelField(
          label: 'Email',
          hintText: 'you@example.com',
          prefixIcon: Icons.email_outlined,
        ),
      ),
    ),
    ComponentItem(
      id: 'glass_input',
      name: 'Glass Input',
      description:
          'A glass-morphism text input with frosted blur background '
          'and animated focus border glow.',
      categoryId: 'textfields',
      tags: ['glass', 'blur', 'glow', 'premium'],
      features: [
        'Backdrop blur effect',
        'Animated focus glow border',
        'Icon tinting on focus',
        'Configurable blur intensity',
      ],
      dependencies: ['dart:ui (BackdropFilter)'],
      usageExample: '''GlassInput(
  hintText: 'Search...',
  blur: 20,
  prefixIcon: Icons.search_rounded,
)''',
      previewBuilder: () => const SizedBox(
        width: 240,
        child: GlassInput(
          hintText: 'Search...',
          prefixIcon: Icons.search_rounded,
        ),
      ),
    ),
    ComponentItem(
      id: 'animated_search_bar',
      name: 'Animated Search Bar',
      description:
          'An expandable search bar that slides open on tap. '
          'Starts as a compact icon button.',
      categoryId: 'textfields',
      tags: ['search', 'expandable', 'animated', 'compact'],
      features: [
        'Smooth width expansion',
        'Icon swap animation (search → close)',
        'Auto-focus on expand',
        'Clear on collapse',
      ],
      dependencies: [],
      usageExample: '''AnimatedSearchBar(
  hintText: 'Search components...',
  onChanged: (query) => print(query),
)''',
      previewBuilder: () => const SizedBox(
        width: 280,
        child: AnimatedSearchBar(
          hintText: 'Search components...',
        ),
      ),
    ),
    ComponentItem(
      id: 'ios_search_field',
      name: 'iOS Search Field',
      description:
          'A Cupertino-style search field with animated cancel button '
          'that slides in on focus.',
      categoryId: 'textfields',
      tags: ['ios', 'cupertino', 'search', 'native'],
      features: [
        'Animated cancel button slide-in',
        'Clear button on text input',
        'Cupertino icons',
        'Native iOS feel',
      ],
      dependencies: ['cupertino_icons'],
      usageExample: '''IosSearchField(
  placeholder: 'Search...',
  onChanged: (query) => print(query),
)''',
      previewBuilder: () => const SizedBox(
        width: 280,
        child: IosSearchField(
          placeholder: 'Search...',
        ),
      ),
    ),
    ComponentItem(
      id: 'underline_input',
      name: 'Underline Input',
      description:
          'A minimal underline-only text input with animated focus '
          'indicator that changes color and width.',
      categoryId: 'textfields',
      tags: ['underline', 'minimal', 'clean', 'animated'],
      features: [
        'Animated underline color',
        'Width transition on focus',
        'Label color animation',
        'Zero visual clutter',
      ],
      dependencies: [],
      usageExample: '''UnderlineInput(
  label: 'Full Name',
  hintText: 'Enter your name',
  activeColor: Colors.indigo,
)''',
      previewBuilder: () => const SizedBox(
        width: 240,
        child: UnderlineInput(
          label: 'Full Name',
          hintText: 'Enter your name',
        ),
      ),
    ),
  ];

  // ──────────────────────────────────────────────
  // Lookup helpers
  // ──────────────────────────────────────────────

  /// Returns a category by its ID, or null if not found.
  static ComponentCategory? getCategoryById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns all components in a given category.
  static List<ComponentItem> getComponentsByCategory(String categoryId) {
    return allComponents.where((c) => c.categoryId == categoryId).toList();
  }

  /// Returns a single component by its ID, or null if not found.
  static ComponentItem? getComponentById(String id) {
    try {
      return allComponents.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ──────────────────────────────────────────────
  // Feedback
  // ──────────────────────────────────────────────

  static final List<ComponentItem> _feedbackComponents = [
    ComponentItem(
      id: 'premium_feedback_form',
      name: 'Premium Feedback',
      description:
          'A full-screen emotionally reactive feedback experience. '
          'Features a fluid morphing face, animated neon gradients, dynamic '
          'typography, and spring physics slider inspired by premium motion design.',
      categoryId: 'feedback',
      tags: ['feedback', 'rating', 'emotion', 'morph', 'animated', 'slider'],
      features: [
        'Fluid CustomPainter face morphing',
        'Dynamic radial gradient background',
        'Spring physics slider interaction',
        'Reactive typography and shadows',
        'Haptic feedback and micro-interactions',
      ],
      dependencies: ['flutter_animate', 'dart:ui'],
      usageExample: '''PremiumFeedbackForm()''',
      previewBuilder: () => Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.sentiment_very_satisfied_rounded,
                size: 48,
                color: AppColors.accentAmber,
              ),
              const SizedBox(height: 16),
              const Text(
                'Immersive Full-Screen UI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const PremiumFeedbackForm(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                icon: const Icon(Icons.fullscreen_rounded),
                label: const Text('Launch Fullscreen Test'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];
}

class _LiquidGlassPreviewContent extends StatelessWidget {
  const _LiquidGlassPreviewContent();

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _PreviewContentBlock(width: 46, height: 42, opacity: 0.2),
                SizedBox(width: 8),
                Expanded(
                  child: _PreviewContentBlock(height: 42, opacity: 0.12),
                ),
              ],
            ),
            Spacer(),
            _PreviewContentLine(widthFactor: 0.72),
            SizedBox(height: 8),
            _PreviewContentLine(widthFactor: 0.48),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _PreviewContentBlock(height: 24, opacity: 0.11),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _PreviewContentBlock(height: 24, opacity: 0.17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewContentBlock extends StatelessWidget {
  const _PreviewContentBlock({
    required this.height,
    required this.opacity,
    this.width,
  });

  final double? width;
  final double height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: opacity),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

class _PreviewContentLine extends StatelessWidget {
  const _PreviewContentLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: Colors.white.withValues(alpha: 0.16),
        ),
      ),
    );
  }
}

class _DynamicChromaticPreview extends StatefulWidget {
  const _DynamicChromaticPreview();
  @override
  State<_DynamicChromaticPreview> createState() =>
      _DynamicChromaticPreviewState();
}

class _DynamicChromaticPreviewState extends State<_DynamicChromaticPreview> {
  int _currentIndex = 0;
  int _colorIndex = 0;
  Timer? _timer;

  static const List<List<Color>> _backgrounds = [
    [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
    [Color(0xFF1a2a6c), Color(0xFFb21f1f), Color(0xFFfdbb2d)],
    [Color(0xFF11998e), Color(0xFF38ef7d), Color(0xFF11998e)],
    [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFF8E2DE2)],
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _colorIndex = (_colorIndex + 1) % _backgrounds.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: _backgrounds[_colorIndex],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChromaticRippleNavBar(
            selectedIndex: _currentIndex,
            onItemSelected: (index) => setState(() => _currentIndex = index),
            items: const [
              ChromaticRippleNavBarItem(
                icon: Icons.home_rounded,
                label: 'Home',
              ),
              ChromaticRippleNavBarItem(
                icon: Icons.explore_rounded,
                label: 'Explore',
              ),
              ChromaticRippleNavBarItem(
                icon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const _DynamicFullscreenTest(),
                ),
              );
            },
            icon: const Icon(Icons.fullscreen_rounded, color: Colors.white),
            label: const Text(
              'Test Fullscreen',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.black26,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DynamicFullscreenTest extends StatefulWidget {
  const _DynamicFullscreenTest();
  @override
  State<_DynamicFullscreenTest> createState() => _DynamicFullscreenTestState();
}

class _DynamicFullscreenTestState extends State<_DynamicFullscreenTest> {
  int _currentIndex = 0;
  int _colorIndex = 0;
  Timer? _timer;

  static const List<List<Color>> _backgrounds = [
    [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
    [Color(0xFF1a2a6c), Color(0xFFb21f1f), Color(0xFFfdbb2d)],
    [Color(0xFF11998e), Color(0xFF38ef7d), Color(0xFF11998e)],
    [Color(0xFF8E2DE2), Color(0xFF4A00E0), Color(0xFF8E2DE2)],
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _colorIndex = (_colorIndex + 1) % _backgrounds.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _backgrounds[_colorIndex],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Close Test'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 24.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: ChromaticRippleNavBar(
                    selectedIndex: _currentIndex,
                    onItemSelected: (idx) =>
                        setState(() => _currentIndex = idx),
                    items: const [
                      ChromaticRippleNavBarItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                      ),
                      ChromaticRippleNavBarItem(
                        icon: Icons.explore_rounded,
                        label: 'Explore',
                      ),
                      ChromaticRippleNavBarItem(
                        icon: Icons.map_rounded,
                        label: 'Map',
                      ),
                      ChromaticRippleNavBarItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
