import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/SettingsPage.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book_app/router.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';


class MockGoRouter extends Mock implements GoRouter {}

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

  @override
  Future<int?> getRecipeRating(int id) {
    // TODO: implement getRecipeRating
    throw UnimplementedError();
  }

  @override
  Future<List<RecipeEntity>> listAllRecipes() async {
    return Future.value(_recipes);
  }

  @override
  Future<void> updateRecipeRating(int id, int rating) {
    // TODO: implement updateRecipeRating
    throw UnimplementedError();
  }
}

void main() {
  testWidgets('Test if "Settings" is in app bar', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SettingsPage(),
    ));
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('Test to for "Import Contacts" and onTap', (tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    router.go('/settings');
    await tester.pumpAndSettle();
    expect(find.text('Import Contacts'), findsOneWidget);
    await tester.tap(find.text('Import Contacts'));
    await tester.pump();
  });

}
