# Flutter UI Kit ✨

> A premium, highly animated, and modern UI component library for Flutter. Built with a focus on fluid animations, glassmorphism, liquid transitions, and Apple-like aesthetics.

[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue?style=flat&logo=flutter)](https://flutter.dev)
[![Dart 97.1%](https://img.shields.io/badge/Dart-97.1%25-00D4FF?style=flat&logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat)](LICENSE)

## 🌟 Overview

Flutter UI Kit is a production-ready component library that brings **visionOS-inspired design** and **fluid animations** to Flutter applications. Unlike basic UI libraries, this kit focuses on:

- **Glassmorphism & Liquid Glass Effects**: Realistic light refraction, specular highlights, and depth perception
- **Fluid Animations**: Spring-based physics, morphing transitions, and micro-interactions
- **Apple-like Aesthetics**: Inspired by modern Apple design language with modern gradients and subtle details
- **Copy-Paste Architecture**: Full customization control—no black boxes, just beautiful code
- **Production-Ready**: Optimized for 60fps performance with careful rendering strategies

## 🎨 Design Philosophy

We believe that **great design lives in the details**. Every component in this library is crafted with:

- Micro-interactions that respond naturally to user input
- Subtle gradients and dynamic shadows that create depth
- Physics-based animations that feel responsive and intentional
- Accessibility-first approach without compromising on beauty
- Consistent design language across all components

## 🚀 Key Features

✅ **17+ Production-Ready Components**  
✅ **Highly Customizable** – Copy-paste components you own completely  
✅ **Performance Optimized** – 60fps animations with smart rendering  
✅ **Dark & Light Theme Support** – Automatic theme adaptation  
✅ **Zero External Dependencies** – Pure Flutter implementations  
✅ **Well-Documented** – Detailed usage examples for each component  
✅ **Modern Design Language** – Glassmorphism, gradients, and depth  

## 📦 Component Library

### Navigation Components

| Component | Features | Use Case |
|-----------|----------|----------|
| **Morphing Island** | Smooth shape transitions between tabs | Modern bottom navigation |
| **Liquid Glass Navbar** | Glassmorphic container with backdrop blur | Premium navigation bars |
| **Chromatic Ripple Navbar** | Color-shifting ripple effects on interaction | Eye-catching navigation |
| **Glow Indicator Navbar** | Animated glow around active tab | Futuristic navigation |
| **Premium Floating Navbar** | Floating action button with smooth animations | Floating navigation patterns |

### Button Components

| Component | Features | Use Case |
|-----------|----------|----------|
| **Liquid Glass Button** | Liquid glass effect with specular highlights | Premium CTAs |
| **Apple Liquid Glass Button** | Apple visionOS-inspired button design | iOS-style interactions |
| **Magnetic Button** | Button that attracts cursor/touch point | Interactive feedback |
| **Push 3D Button** | 3D depth with press animation | Modern flat design |
| **Expandable Button** | Expands to show additional options | Space-saving actions |
| **Premium Theme Toggle** | Smooth day/night mode switcher | Theme switching |

### Card Components

| Component | Features | Use Case |
|-----------|----------|----------|
| **Glass Card** | Glassmorphic card with blur effect | Content containers |
| **Animated Info Card** | Auto-scrolling info with smooth transitions | Data display |
| **Expandable Card** | Expand/collapse with smooth animations | Detailed information |
| **Dashboard Card** | Grid-friendly card with metrics | Dashboard layouts |

### Input Components

| Component | Features | Use Case |
|-----------|----------|----------|
| **Animated Search Bar** | Glassmorphic search with smooth expand | Search functionality |
| **Glass Input Field** | Premium text input with blur background | Modern forms |
| **Floating Label Field** | Label animates above input on focus | Clean form design |
| **iOS Search Field** | iOS-native search experience | iOS-style interfaces |

### Loading Components

| Component | Features | Use Case |
|-----------|----------|----------|
| **Liquid Loader** | Morphing liquid animation | Premium loading states |
| **Pulse Loader** | Expanding pulse rings | Modern loading indicator |
| **Morph Loader** | Shape-morphing animation | Smooth transitions |
| **Orbit Loader** | Orbiting particles animation | Tech-forward loaders |

### Feedback Forms

| Component | Features | Use Case |
|-----------|----------|----------|
| **Feedback Form** | Smooth, glassmorphic feedback collection form | User feedback & surveys |

## 🏗️ Project Structure

```
Flutter-UI-Kit/
├── lib/
│   ├── main.dart                 # Catalog app entry point
│   ├── core/
│   │   ├── theme/                # Global theme configuration
│   │   ├── constants/            # Colors, durations, spacing, radius
│   │   ├── extensions/           # Useful Dart extensions
│   │   └── utils/                # Helper functions and utilities
│   │
│   ├── components/
│   │   ├── buttons/              # Button component variants
│   │   ├── navigation/           # Navigation components
│   │   ├── cards/                # Card component variants
│   │   ├── inputs/               # Input field components
│   │   ├── loaders/              # Loading indicator components
│   │   └── feedback_forms/       # Feedback form components
│   │
│   └── pages/
│       ├── component_showcase/   # Individual component demo pages
│       └── home/                 # Main catalog home screen
│
├── pubspec.yaml                  # Dependencies (Riverpod, GoRouter, etc.)
└── README.md                     # This file
```

## 🎯 Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+

### Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/anirban222777das/Flutter-UI-Kit.git
   cd Flutter-UI-Kit
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the Catalog App**
   ```bash
   flutter run
   ```

4. **Explore Components**
   - Navigate through the catalog using the bottom navigation
   - Tap on components to see interactive demos
   - Check component README files for implementation details

## 💻 Using Components in Your Project

This is a **copy-paste component library**, not a traditional package. Why? Because UI components often need fine-tuning to match your specific design system.

### Step-by-Step Integration

1. **Browse & Understand**
   - Run the catalog app to preview all components
   - Read the component-specific README in `lib/components/`

2. **Copy Core Dependencies** (if not already in your project)
   ```
   lib/core/
   ├── constants/
   │   ├── app_colors.dart
   │   ├── app_durations.dart
   │   ├── app_spacing.dart
   │   └── app_radius.dart
   ├── extensions/
   │   └── context_extensions.dart
   └── theme/
       └── app_theme.dart
   ```

3. **Copy the Component**
   ```
   lib/components/buttons/liquid_glass_button/
   ├── liquid_glass_button.dart
   ├── liquid_glass_button_style.dart
   └── README.md
   ```

4. **Import & Use**
   ```dart
   import 'package:your_app/components/buttons/liquid_glass_button/liquid_glass_button.dart';

   LiquidGlassButton(
     text: 'Get Started',
     onPressed: () => print('Tapped!'),
     size: LiquidGlassButtonSize.large,
   )
   ```

5. **Customize**
   - Modify colors in `AppColors` or directly in component code
   - Adjust animation durations via `AppDurations`
   - Tweak spacing with `AppSpacing` constants
   - Update border radius via `AppRadius`

### Example: Custom Theme Integration

```dart
import 'package:flutter/material.dart';
import 'package:your_app/core/constants/app_colors.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    extensions: [
      // Add custom theme extensions here
    ],
  );
}
```

## 🎨 Theming & Customization

Each component supports theme customization. Common customization points:

### Global Constants
- **`AppColors`** – Primary, secondary, background colors
- **`AppDurations`** – Animation timings
- **`AppSpacing`** – Padding, margins, gaps
- **`AppRadius`** – Border radii values

### Component-Specific Theming
Most components accept style parameters:

```dart
LiquidGlassButton(
  text: 'Premium Button',
  onPressed: () {},
  variant: LiquidGlassButtonVariant.primary,
  size: LiquidGlassButtonSize.large,
  backgroundColor: Colors.blueAccent,
  cornerRadius: 12,
)
```

### Dark Mode Support
All components automatically adapt to light and dark themes using:
```dart
context.isDarkMode
Theme.of(context).brightness
```

## ⚡ Performance Optimization

Flutter UI Kit is built with performance in mind:

- **RepaintBoundary**: Isolates expensive operations like `BackdropFilter`
- **CustomPaint**: Efficient rendering for complex shapes and effects
- **Smart Rebuilds**: Minimal widget rebuilds using `const` constructors
- **GPU Acceleration**: Leverages Flutter's rendering pipeline for smooth 60fps animations

### Performance Targets
- ✅ 60 FPS on most devices (tested on iPhone 12+, Pixel 5+)
- ✅ Minimal memory footprint
- ✅ Smooth animations even with 10+ components on screen

## 📚 Documentation

Each component folder includes a dedicated `README.md` with:
- Feature overview
- Visual examples
- Complete usage examples
- Theming options
- Performance notes
- Common customization patterns

## 🔧 Technical Stack

| Aspect | Technology |
|--------|-----------|
| **Language** | Dart 3.0+ |
| **Framework** | Flutter 3.0+ |
| **State Management** | Riverpod |
| **Navigation** | GoRouter |
| **Build System** | Flutter pub |
| **Supported Platforms** | iOS, Android, Web |

## 🎯 Browser & Device Support

| Platform | Status | Min Version |
|----------|--------|------------|
| iOS | ✅ Full Support | iOS 12.0+ |
| Android | ✅ Full Support | Android 5.0+ |

## 🤝 Contributing

I love contributions! If you've built an amazing component that fits our design language, please contribute:

### How to Contribute

1. **Fork** the repository
2. **Create a feature branch** – `git checkout -b feature/my-component`
3. **Build your component** following the existing patterns
4. **Add comprehensive documentation** with usage examples
5. **Test on multiple devices** to ensure smooth 60fps performance
6. **Submit a Pull Request** with a detailed description

### Component Guidelines

- Follow the existing folder structure and naming conventions
- Include a detailed `README.md` with examples
- Ensure components are customizable (avoid hardcoded values)
- Support both light and dark themes
- Use `const` constructors where possible
- Add component-specific demo to the catalog app
- Optimize for performance (use `RepaintBoundary`, `CustomPaint` wisely)

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

## 🙋 Support & Questions

- **Issues**: Report bugs on [GitHub Issues](https://github.com/anirban222777das/Flutter-UI-Kit/issues)
- **Discussions**: Ask questions in [GitHub Discussions](https://github.com/anirban222777das/Flutter-UI-Kit/discussions)
- **Documentation**: Check component-specific READMEs in `lib/components/`

## 🌟 Showcase

See the components in action:
- Run the **Catalog App** to explore all components
- Check the **Component Gallery** for side-by-side comparisons
- Visit individual component demo pages for interactive examples

## 🎉 Credits

Built with ❤️ by [Anirban Das](https://github.com/anirban222777das)

Inspired by:
- Apple visionOS design language
- Modern glassmorphism trends
- Fluid animation principles
- Flutter community best practices

## 📈 Roadmap

- [ ] Add more animation variants
- [ ] Web platform optimizations
- [ ] Component optimizations
- [ ] Make the components more production ready

---

**Made with ❤️ for the Flutter community** ✨
