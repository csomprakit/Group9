import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'recipe_dao.dart';
import 'recipe_entity.dart';

part 'recipe_database.g.dart';

@Database(version: 1, entities: [RecipeEntity])
abstract class RecipeDatabase extends FloorDatabase {
  RecipeDao get recipeDao;

  static Future<RecipeDatabase> initDatabase() async {
    final database = await $FloorRecipeDatabase.databaseBuilder('recipe_database.db').build();
    await insertMockData(database);
    return database;
  }

  static Future<void> insertMockData(RecipeDatabase database) async {
    final recipeDao = database.recipeDao;

    final mockRecipes = [
      RecipeEntity(
          1,
          'Spaghetti Carbonara',
          'Classic Italian pasta dish with bacon, eggs, and cheese',
          'Spaghetti, Eggs, Bacon, Parmesan Cheese, Black Pepper',
          'Pasta',
          'lib/assets/carbonara.jpg'
      ),
      RecipeEntity(
          2,
          'Chicken Curry',
          'Spicy and flavorful chicken curry with a rich sauce',
          'Chicken, Curry Powder, Coconut Milk, Onion, Garlic, Ginger',
          'Curry',
          'lib/assets/food.jpg'
      ),
      RecipeEntity(
          3,
          'Vegetable Stir-Fry',
          'Healthy and colorful vegetable stir-fry with a tangy sauce',
          'Broccoli, Bell Peppers, Carrots, Snap Peas, Soy Sauce, Ginger, Garlic',
          'Stir-Fry',
          'lib/assets/vegetable_stir_fry.jpg'
      ),
      // Add more mock recipes as needed
    ];

    for (final recipe in mockRecipes) {
      await recipeDao.addRecipe(recipe);
    }
  }
}
