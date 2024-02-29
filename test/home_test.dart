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

class MockRecipeDao extends RecipeDao {
  @override
  Future<void> addRecipe(RecipeEntity event) async {}

  @override
  Stream<RecipeEntity?> findRecipeById(int id) {
    // TODO: implement findRecipeById
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeEntity>> listAllEvents() {
    // TODO: implement listAllEvents
    throw UnimplementedError();
  }

  @override
  Future<List<String>> listCategories() {
    // TODO: implement listCategories
    throw UnimplementedError();
  }

  @override
  Future<void> updateRecipe(RecipeEntity event) async {}

  @override
  Future<void> deleteRecipe(RecipeEntity event) async {}
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
