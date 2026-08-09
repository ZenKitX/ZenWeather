// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zen_weather/app/data/local/storage_service.dart';
import 'package:zen_weather/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize storage with in-memory mock values (as done in main()).
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ZenWeatherApp());

    // Advance time past the splash screen's 2s delay.
    await tester.pump(const Duration(seconds: 3));

    // Verify that the app starts.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
