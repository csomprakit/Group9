import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
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
    return Future.value(_recipes);
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
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

main() {
  testWidgets('Test add recipe button', (tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
    await tester.tap(find.text('View Recipes'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  });

  testWidgets('Test display of recipe', (tester) async{
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();
    var recipe = RecipeEntity(
        1,
        'Mock Recipe',
        'Mock Description',
        'image.jpg',
        'Mock Category',
        'Mock Ingredients',
        5
    );
    mockDao.addRecipe(recipe);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
    ));

    await tester.tap(find.text('View Recipes'));
    await tester.pumpAndSettle();

    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Mock Recipe'), findsOneWidget);

    await tester.tap(find.text('Mock Recipe'));
    await tester.pumpAndSettle();

    expect(find.text('Mock Recipe'), findsOneWidget);
    expect(find.text('Mock Description'), findsOneWidget);
    expect(find.text('Rating: 5'), findsOneWidget);
  });

  testWidgets('Test the sort recipe buttons', (tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();
    List<RecipeEntity> mockRecipes = [
      RecipeEntity(1, 'Recipe C', 'Description C', 'imageC.jpg', 'Italian', 'Ingredients C', 3),
      RecipeEntity(2, 'Recipe A', 'Description A', 'imageA.jpg', 'Chinese', 'Ingredients A', 5),
      RecipeEntity(3, 'Recipe B', 'Description B', 'imageB.jpg', 'Indian', 'Ingredients B', 4),
    ];
    mockDao.addRecipe(mockRecipes[0]);
    mockDao.addRecipe(mockRecipes[1]);
    mockDao.addRecipe(mockRecipes[2]);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );
    await tester.tap(find.text('View Recipes'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.sort), findsOneWidget);

    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rating'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.sort));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alphabetical'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Italian'));
    await tester.pumpAndSettle();

    expect(find.text('Recipe C'), findsOneWidget);
  });
}