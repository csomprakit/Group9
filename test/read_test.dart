import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book_app/ReadPage.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:recipe_book_app/router.dart';


abstract class Database {
  Future<int> fetchData();
}

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
  Future<List<RecipeEntity>> listAllEvents() async {
    return Future<List<RecipeEntity>>.value(_recipes);
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

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

main() {
  testWidgets('Test add recipe button', (tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();

    await tester.pumpWidget(
      MaterialApp(home: ReadPage(dao: mockDao))
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(router.configuration.navigatorKey, '/addRecipe');
  });

  testWidgets('Test display of recipe', (tester) async{
  });
}