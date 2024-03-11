import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/DeletePage.dart';
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

void main() {
  testWidgets('DeleteRecipePage UI Test', (WidgetTester tester) async {
    var mockDao = MockRecipeDao();
    await tester.pumpWidget(
      MaterialApp(
        home: DeleteRecipePage(dao: mockDao),
      ),
    );

    expect(find.text('Delete Recipe'), findsOneWidget);
    expect(find.byType(RecipeList), findsOneWidget);
  });

  testWidgets('RecipeList Test', (WidgetTester tester) async {
    var mockDao = MockRecipeDao();
    final router = AppRouter(dao: mockDao).getRouter();

    final recipes = [
      RecipeEntity(1, 'Recipe 1', 'Description 1', 'Category 1', 'Image 1', 'Cuisine 1', 5),
      RecipeEntity(2, 'Recipe 2', 'Description 2', 'Category 2', 'Image 2', 'Cuisine 2', 2),
    ];
    mockDao.addRecipe(recipes[0]);
    mockDao.addRecipe(recipes[1]);

    await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        )
    );

    await tester.tap(find.text('View Recipes'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Recipe 1'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();
    expect(find.text('Recipe 1'), findsNothing);
  });
}
