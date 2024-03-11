import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/CreatePage.dart';
import 'package:recipe_book_app/database/recipe_database.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:recipe_book_app/router.dart';

class MockRecipeDao implements RecipeDao {
  List<RecipeEntity> _recipes = [];
  @override
  Future<void> addRecipe(RecipeEntity recipe) async {
    _recipes.add(recipe);
  }

  @override
  Future<void> updateRecipe(RecipeEntity updatedRecipe) async {
    final index = _recipes.indexWhere((recipe) => recipe.id == updatedRecipe.id);
    if (index != -1) {
      _recipes[index] = updatedRecipe;
    }
  }

  @override
  Future<void> deleteRecipe(RecipeEntity recipe) async {
    _recipes.removeWhere((existingRecipe) => existingRecipe.id == recipe.id);
  }

  @override
  Future<List<RecipeEntity>> listAllRecipes() {
    return Future<List<RecipeEntity>>.value(_recipes);
  }

  @override
  Future<int?> getRecipeRating(int id) {
    // TODO: implement getRecipeRating
    throw UnimplementedError();
  }

  @override
  Future<void> updateRecipeRating(int id, int rating) {
    // TODO: implement updateRecipeRating
    throw UnimplementedError();
  }
}

class MockRecipeDatabase implements RecipeDatabase {
  @override
  RecipeDao get recipeDao => MockRecipeDao();
  @override
  Future<int> fetchData() async {
    return Future.delayed(Duration(seconds: 1), () => 42);
  }

  @override
  late StreamController<String> changeListener;

  @override
  late sqflite.DatabaseExecutor database;

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }
}

main() {
  testWidgets('', (tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();

    await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ));

    await tester.tap(find.text('View Recipes'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    expect(find.text("Add Recipe"), findsOneWidget);
    expect(find.text("Recipe Name"), findsOneWidget);
    expect(find.text("Description"), findsOneWidget);
    expect(find.text("Cuisine"), findsOneWidget);

    await tester.enterText(find.byKey(Key("recipeName")), "Test Name");
    await tester.enterText(find.byKey(Key("description")), "Test Description");

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    expect(find.text("Ingredient"), findsOneWidget);

    await tester.enterText(find.byKey(Key("ingredientField")), "Test Ingredient");

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();
    expect(find.text("Ingredient"), findsNothing);

    await tester.tap(find.byKey(Key("recordButton")));
    await tester.pumpAndSettle();
  });
}


