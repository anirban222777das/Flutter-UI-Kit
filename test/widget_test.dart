import 'package:flutter_test/flutter_test.dart';
import 'package:uikit/main.dart';

void main() {
  testWidgets('App launches without errors', (tester) async {
    await tester.pumpWidget(const UIKitApp());
    expect(find.text('Component\nCatalog'), findsOneWidget);
  });
}
