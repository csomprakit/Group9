// Import necessary files
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'recipe_entity.dart';
import 'recipe_dao.dart';
import 'recipe_database.dart';

// Define the function to insert mock data
Future<void> insertMockData() async {
  // Initialize the database
  final recipeDatabase =
  await $FloorRecipeDatabase.databaseBuilder('recipe_database.db').build();

  // Get the RecipeDao instance from the database
  final recipeDao = recipeDatabase.recipeDao;

  // Create mock recipes
  final List<RecipeEntity> mockRecipes = [
    RecipeEntity(
      1,
      'Spaghetti Carbonara',
      'Classic Italian pasta dish with bacon, eggs, and cheese',
      'Spaghetti, Eggs, Bacon, Parmesan Cheese, Black Pepper',
      'Pasta',
    ),
    RecipeEntity(
      2,
      'Chicken Curry',
      'Spicy and flavorful chicken curry with a rich sauce',
      'Chicken, Curry Powder, Coconut Milk, Onion, Garlic, Ginger',
      'Curry',
    ),
    RecipeEntity(
      3,
      'Vegetable Stir-Fry',
      'Healthy and colorful vegetable stir-fry with a tangy sauce',
      'Broccoli, Bell Peppers, Carrots, Snap Peas, Soy Sauce, Ginger, Garlic',
      'Stir-Fry',
    ),
    // Add more mock recipes as needed
  ];

  // Insert each mock recipe into the database
  for (RecipeEntity recipe in mockRecipes) {
    await recipeDao.addRecipe(recipe);
  }

  // Close the database after inserting mock data
  await recipeDatabase.close();
}
