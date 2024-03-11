import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/UpdatePage.dart';
import 'package:recipe_book_app/HomePage.dart';
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
  testWidgets('UpdateRecipeForm UI Test', (WidgetTester tester) async {
    var mockDao = MockRecipeDao();
    final recipe = RecipeEntity(1, 'Recipe 1', 'Description 1', 'Category 1', 'Image 1', 'Cuisine 1', 5);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UpdateRecipeForm(dao: mockDao, recipe: recipe),
        ),
      ),
    );
    expect(find.text('Recipe Name'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Ingredients'), findsOneWidget);
    expect(find.text('Cuisine'), findsOneWidget);
    expect(find.text('Update Recipe'), findsOneWidget);
  });

  testWidgets('UpdateRecipeForm Submit Test', (WidgetTester tester) async {
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

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Updated Recipe Name');
    await tester.enterText(find.byType(TextField).at(1), 'Updated Description');

    await tester.tap(find.text('Update Recipe').last);
    await tester.pumpAndSettle();

  });
}

