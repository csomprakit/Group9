import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/GalleryAccess.dart';
import 'dart:async';


void main() {
    testWidgets('Test gallery and camera access', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GalleryAccess(
            updateImagePath: (path) {},
          ),
        ),
      );

      //Expect to find button
      expect(find.text('Select Image from Gallery and Camera'), findsOneWidget);

      // Tap button
      await tester.tap(find.text('Select Image from Gallery and Camera'));
      await tester.pumpAndSettle();

      // Verify that the bottom sheet pop up
      expect(find.byType(BottomSheet), findsOneWidget);

      // Tap photo library
      await tester.tap(find.text('Photo Library'));
      await tester.pumpAndSettle();
      // Tap camera
      await tester.tap(find.text('Camera'));
      await tester.pumpAndSettle();
    });
}