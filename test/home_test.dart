import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/HomePage.dart';
import 'package:recipe_book_app/ReadPage.dart';
import 'package:recipe_book_app/database/recipe_database.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

abstract class Database {
  Future<int> fetchData();
}

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
class MockRecipeDatabase extends RecipeDatabase {
  late MockRecipeDao _mockRecipeDao;

  MockRecipeDatabase(MockRecipeDao mockRecipeDao) {
    _mockRecipeDao = mockRecipeDao;
  }

  @override
  RecipeDao get recipeDao => _mockRecipeDao;

  @override
  Future<int> fetchData() async {
    return Future.delayed(Duration(seconds: 1), () => 42);
  }

  @override
  Future<void> close() async {}
}

void main() {
  testWidgets('Test Recipe List View', (tester) async {
    final mockRecipeDao = MockRecipeDao();
    final mockDatabase = MockRecipeDatabase(mockRecipeDao);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(dao: mockRecipeDao),
      ),
    );

    expect(find.text("My Recipe Book"), findsOneWidget);
    expect(find.text("View Recipes"), findsOneWidget);

    //await tester.tap(find.text('View Recipes'));
    //await tester.pumpAndSettle();

    //expect(find.byType(ListTile), findsWidgets);
  });
}
