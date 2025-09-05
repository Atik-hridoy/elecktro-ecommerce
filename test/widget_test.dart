// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:elecktro_ecommerce/main.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is shown
    expect(find.text('Elecktro'), findsOneWidget);
    
    // Note: Since this is a smoke test, we're just verifying the app starts.
    // You can add more specific widget tests here based on your app's actual content.
  });
}
