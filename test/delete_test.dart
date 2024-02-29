import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_book_app/database/recipe_dao.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/DeletePage.dart';

class MockRecipeDao extends Mock implements RecipeDao {}

void main() {
  late RecipeDao dao;

  setUp(() {
    dao = MockRecipeDao();
  });

  testWidgets('DeleteRecipePage UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DeleteRecipePage(dao: dao),
      ),
    );

    expect(find.text('Delete Recipe'), findsOneWidget);
    expect(find.byType(RecipeList), findsOneWidget);
  });

  testWidgets('RecipeList Test', (WidgetTester tester) async {
    final recipes = [
      RecipeEntity(1, 'Recipe 1', 'Description 1', 'Category 1', 'Image 1', 'Cuisine 1'),
      RecipeEntity(2, 'Recipe 2', 'Description 2', 'Category 2', 'Image 2', 'Cuisine 2'),
    ];

    when(dao.listAllEvents()).thenAnswer((_) => Future.value(recipes));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecipeList(dao: dao),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();

    expect(find.byType(ListTile), findsNWidgets(recipes.length));

    // Test deletion
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();

    verify(await dao.deleteRecipe(recipes.first)).called(1);
    expect(find.text('Recipe "${recipes.first.recipeName}" deleted.'), findsOneWidget);
  });
}
