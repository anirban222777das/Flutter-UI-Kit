# LiquidGlassButton

A premium, production-ready Flutter component that perfectly simulates liquid glass UI materials (inspired by visionOS and modern acrylic hardware controls).

## Overview

Unlike standard flat glassmorphism, `LiquidGlassButton` accurately simulates optical properties using:
- **Layered Translucency**: Responsive tint opacities that adapt to theme and interaction.
- **Specular Highlights**: A custom painter draws edge lighting and diagonal gloss.
- **Ambient Depth**: Responsive shadows that physically compress when pressed.
- **Optimized Rendering**: Leverages `BackdropFilter` inside a `RepaintBoundary` while outsourcing reflections to highly efficient `CustomPaint` draw calls.

## Features

- Fully responsive to Light & Dark themes.
- Multiple sizes (`small`, `medium`, `large`).
- Multiple variants (`primary`, `secondary`, `destructive`, `subtle`).
- Smooth 60fps spring-based animations.
- Built-in loading and disabled states.
- Support for customizable `LiquidGlassButtonTheme`.

## Usage

```dart
import 'package:uikit/components/buttons/liquid_glass_button/liquid_glass_button.dart';
import 'package:uikit/components/buttons/liquid_glass_button/liquid_glass_button_style.dart';

// Basic Usage
LiquidGlassButton(
  text: 'Continue',
  onPressed: () => print('Pressed'),
  variant: LiquidGlassButtonVariant.primary,
)

// Icon Only
LiquidGlassButton(
  icon: Icons.add_rounded,
  onPressed: () => print('Pressed'),
  size: LiquidGlassButtonSize.large,
)

// Loading State
LiquidGlassButton(
  text: 'Authenticating...',
  isLoading: true,
  onPressed: () {},
)
```

## Theming

To configure global colors, supply `LiquidGlassButtonTheme` to your `ThemeData` extensions:

```dart
ThemeData(
  extensions: [
    LiquidGlassButtonTheme(
      primaryColor: Colors.blueAccent,
      destructiveColor: Colors.redAccent,
      reflectionColor: Colors.white,
    ),
  ],
)
```

## Performance Notes

To ensure a stable 60fps framerate, this button uses `RepaintBoundary` to freeze the expensive `BackdropFilter` operation. Standard scale animations on press do NOT trigger a re-blur, only the outer matrix is transformed. The custom reflections are extremely cheap vector draw calls.
