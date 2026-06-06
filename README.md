# Flutter UI Kit ✨

A premium, highly animated, and modern UI component library for Flutter. Built with a focus on fluid animations, glassmorphism, liquid transitions, and Apple-like aesthetics.

## 🌟 Vision

The vision behind this UI Kit is to provide **production-ready, visually stunning, and highly interactive** components that elevate the user experience of any Flutter application. Instead of basic static widgets, these components are designed to feel alive, responsive, and deeply polished.

I believe that great design is in the details—micro-interactions, subtle gradients, dynamic shadows, and physics-based animations. This library aims to be the go-to resource for developers looking to add that "wow" factor to their apps without spending hours tweaking `AnimationController`s and custom painters.

## 🚀 How to Use

This is a **copy-paste component library**, not a traditional Flutter package. 

Why? Because UI components often need to be tweaked to fit your app's specific design system. By copying the code directly into your project, you retain full control over the styling, animations, and behavior.

### Steps to Use a Component:

1. **Browse the Catalog**: Run the app to explore the catalog of available components (Buttons, Navigation Bars, Text Fields, Cards, and Loaders).
2. **Find the Component**: Navigate to `lib/components/` and locate the source code for the component you want to use.
3. **Copy Dependencies**: Some components rely on shared utilities or constants. Make sure to copy the relevant files from the `lib/core/` directory if you don't already have them in your project. These usually include:
   - `AppColors` or `AppTheme` (for consistent styling)
   - `AppDurations`, `AppSpacing`, and `AppRadius` (for consistent animations and layouts)
   - `ContextExtensions` (for quick access to theme data)
4. **Copy the Component**: Copy the `.dart` file(s) of the component into your project's widget folder.
5. **Customize**: Modify the component directly to fit your app's needs. Change colors, tweak animation curves, or adjust padding!

## 🧩 Components Available

- **Navigation**: Morphing Island, Liquid Glass Navbar, Chromatic Ripple Navbar, Glow Indicator Navbar, Premium Floating Navbar.
- **Buttons**: Liquid Glass Button, Apple Liquid Glass Button, Magnetic Button, Push 3D Button, Expandable Button, Premium Theme Toggle.
- **Cards**: Glass Card, Animated Info Card, Expandable Card, Dashboard Card.
- **Text Fields**: Animated Search Bar, Glass Input, Floating Label Field, iOS Search Field.
- **Loaders**: Liquid Loader, Pulse Loader, Morph Loader, Orbit Loader.

## 🛠️ Running the Catalog App

To see all the components in action:

```bash
flutter pub get
flutter run
```

*Note: The app uses Riverpod for state management and GoRouter for navigation.*

## 🤝 Contributing

Contributions are welcome! If you have built a beautiful, animated component and want to share it, feel free to open a pull request. Please ensure that your component follows the design language of the kit (smooth animations, modern aesthetics).
