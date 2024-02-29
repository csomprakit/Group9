import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/UpdatePage.dart';
import 'package:recipe_book_app/HomePage.dart';

void main() {
  late RecipeDao dao;
  late RecipeEntity recipe;

  setUp(() {
    dao = MockRecipeDao();
    recipe = RecipeEntity(
      1,
      'Test Recipe',
      'Test Description',
      'Ingredient 1, Ingredient 2',
      'Test Cuisine',
      'Test Image Path',
    );
  });

  testWidgets('UpdateRecipeForm UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UpdateRecipeForm(dao: dao, recipe: recipe),
        ),
      ),
    );

    // Verify that all required form fields are present
    expect(find.text('Recipe Name'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Cuisine'), findsOneWidget);
    expect(find.text('Update Recipe'), findsOneWidget);
  });

  testWidgets('UpdateRecipeForm Submit Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UpdateRecipeForm(dao: dao, recipe: recipe),
        ),
      ),
    );

    // Enter new values for recipe name and description
    await tester.enterText(find.byKey(ValueKey('recipeName')), 'Updated Recipe Name');
    await tester.enterText(find.byKey(ValueKey('description')), 'Updated Description');

    // Tap the update button
    await tester.tap(find.text('Update Recipe'));
    await tester.pump();

    // Verify that the recipe has been updated
    verify(dao.updateRecipe(RecipeEntity(
      1,
      'Updated Recipe Name',
      'Updated Description',
      'Ingredient 1, Ingredient 2',
      'Test Cuisine',
      'Test Image Path',
    ))).called(1);

    // Verify that the confirmation dialog appears
    expect(find.text('Your recipe has been updated'), findsOneWidget);
    expect(find.text('Ok'), findsOneWidget);

    // Tap the Ok button on the dialog
    await tester.tap(find.text('Ok'));
    await tester.pump();

    // Verify that the user is navigated back to the home page
    expect(find.byType(HomePage), findsOneWidget);
  });
}

class MockRecipeDao extends Mock implements RecipeDao {}
