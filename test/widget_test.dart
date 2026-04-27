import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/app.dart';

void main() {
  testWidgets('App renders without crashing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );
    await tester.pump();
    // App should render the MaterialApp router
    expect(find.byType(MaterialApp), findsOneWidget);
  }, skip: true); // Requires real SQLite — run on device/emulator instead
}
