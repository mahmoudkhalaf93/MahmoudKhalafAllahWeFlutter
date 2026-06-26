import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sushi/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Provide null for firebaseInit in tests
    await tester.pumpWidget(const MyApp(firebaseInit: null));

    // Verify the app structure
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
