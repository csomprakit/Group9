import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:recipe_book_app/bottom_nav.dart';
import 'package:recipe_book_app/router.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';


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

void main() {
  var mockDao = MockRecipeDao();
  testWidgets('BottomNav "Settings" button test', (WidgetTester tester) async {
    final router = await AppRouter(dao: mockDao).getRouter();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomNav(),
        ),
      ),
    );
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(router.configuration.navigatorKey, '/settings');
  });

  testWidgets('BottomNav "Search" button test', (WidgetTester tester) async {
    final router = await AppRouter(dao: mockDao).getRouter();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomNav(),
        ),
      ),
    );

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(router.configuration.navigatorKey, '/search');
  });

  testWidgets('BottomNav "Home" button test', (WidgetTester tester) async {
    final router = await AppRouter(dao: mockDao).getRouter();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomNav(),
        ),
      ),
    );
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(router.configuration.navigatorKey, '/home');
  });
}
