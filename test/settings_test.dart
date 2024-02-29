import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/SettingsPage.dart';

void main() {
  testWidgets('Test if "Settings" is in app bar', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SettingsPage(),
    ));

    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Test to for "Import Contacts" and onTap in ListTile', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SettingsPage(),
    ));

    expect(find.text('Import Contacts'), findsOneWidget);
    await tester.tap(find.text('Import Contacts'));
    await tester.pumpAndSettle();
  });
}
