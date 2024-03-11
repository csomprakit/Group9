import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:recipe_book_app/router.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';

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

void main() {

  testWidgets('BottomNav "Settings" button test', (WidgetTester tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
  });

  testWidgets('BottomNav "Home" button test', (WidgetTester tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
  });

}
