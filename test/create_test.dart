import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/CreatePage.dart';
import 'package:recipe_book_app/database/recipe_database.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

class MockRecipeDao implements RecipeDao {
  List<RecipeEntity> _recipes = [];
  @override
  Future<void> addRecipe(RecipeEntity event) async {}

  @override
  Stream<RecipeEntity?> findRecipeById(int id) {
    // TODO: implement findRecipeById
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeEntity>> listAllEvents() {
    return Future.value(_recipes);
  }

  @override
  Future<List<String>> listCategories() {
    // TODO: implement listCategories
    throw UnimplementedError();
  }

  @override
  Future<void> deleteRecipe(RecipeEntity event) {
    // TODO: implement deleteRecipe
    throw UnimplementedError();
  }

  @override
  Future<void> updateRecipe(RecipeEntity event) {
    // TODO: implement updateRecipe
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
    var mockDatabase = MockRecipeDatabase();
    var mockDao = mockDatabase.recipeDao;
    await tester.pumpWidget(MaterialApp(
      home: AddRecipe(dao: mockDao),
    ));
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
    expect(find.byKey(Key("Alert")), findsOneWidget);
  });
}