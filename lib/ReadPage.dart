import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';
import 'package:recipe_book_app/bottom_nav.dart';
import 'database/recipe_dao.dart';

class Recipe {
  final int id;
  final String? recipeName;
  final String description;
  final String ingredients;
  final String category;
  final String imagePath;

  Recipe({
    required this.id,
    required this.recipeName,
    required this.description,
    required this.ingredients,
    required this.category,
    required this.imagePath,
  });
}

// Mock Data
final List<Recipe> mockRecipes = [
  Recipe(
    id: 1,
    recipeName: 'Spaghetti Carbonara',
    description: 'Classic Italian pasta dish with bacon, eggs, and cheese',
    ingredients: 'Spaghetti, Eggs, Bacon, Parmesan Cheese, Black Pepper',
    category: 'Italian',
    imagePath: 'lib/assets/carbonara.jpg',
  ),
  Recipe(
    id: 2,
    recipeName: 'Chicken Alfredo',
    description: 'Creamy pasta dish with chicken and Alfredo sauce',
    ingredients: 'Fettuccine, Chicken Breast, Heavy Cream, Parmesan Cheese',
    category: 'Italian',
    imagePath: 'lib/assets/chickalfred.jpeg',
  ),
  Recipe(
    id: 3,
    recipeName: 'Spaghetti Bolognese',
    description: 'Classic Italian pasta dish with meaty tomato sauce',
    ingredients:
        'Spaghetti, Ground Beef, Tomato Sauce, Onion, Garlic, Parmesan Cheese',
    category: 'Italian',
    imagePath: 'lib/assets/spaghetti_bolognese.jpg',
  ),
  Recipe(
    id: 4,
    recipeName: 'Vegetable Stir-Fry',
    description: 'Healthy stir-fried vegetables in a savory sauce',
    ingredients:
        'Broccoli, Bell Peppers, Carrots, Snap Peas, Soy Sauce, Ginger, Garlic',
    category: 'Asian',
    imagePath: 'lib/assets/vegetable_stir_fry.jpg',
  ),
];

class ReadPage extends StatelessWidget {
  final RecipeDao dao;

  ReadPage({required this.dao, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              GoRouter.of(context).push('/addRecipe');
            },
          )
        ],
      ),
      body: SafeArea(
          child: FutureBuilder<List<RecipeEntity>>(
              future: dao.listAllEvents(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No recipes found.');
                } else {
                  List<RecipeEntity> recipeEvents = snapshot.data!
                      .map((entity) => RecipeEntity(
                          entity.id,
                          entity.recipeName,
                          entity.description,
                          entity.ingredients,
                          entity.category,
                          entity.imagePath))
                      .toList();
                  return ListView.builder(
                    itemCount: recipeEvents.length,
                    itemBuilder: (context, index) {
                      final recipe = recipeEvents[index];
                      return ListTile(
                        title: Text(recipe.recipeName ?? 'No Name'),
                        subtitle: Text(recipe.description),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                              recipe.imagePath ?? 'lib/assets/carbonara.jpg'),
                        ),
                        onTap: () {
                          // Navigate to recipe details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailsPage(recipe: recipe)),
                          );
                        },
                      );
                    },
                  );
                }
              })),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class RecipeDetailsPage extends StatelessWidget {
  final RecipeEntity recipe;

  RecipeDetailsPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.recipeName ?? 'No Name'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(recipe.description),
            SizedBox(height: 16.0),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(recipe.ingredients),
          ],
        ),
      ),
    );
  }
}
