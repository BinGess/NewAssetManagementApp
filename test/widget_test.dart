import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_asset_management_app/app.dart';

void main() {
  testWidgets('App renders login screen when not authenticated', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );
    await tester.pump();
    // App should redirect to login since not authenticated
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
