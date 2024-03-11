import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/contacts.dart';


void main() {
  testWidgets('importContacts Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: importContacts(),
      ),
    );
  });
}
