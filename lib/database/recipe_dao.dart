import 'package:floor/floor.dart';
import 'package:recipe_book_app/database/recipe_entity.dart';

@dao
abstract class RecipeDao {
  @insert
  Future<void> addRecipe(RecipeEntity recipe);

  @update
  Future<void> updateRecipe(RecipeEntity recipe);

  @delete
  Future<void> deleteRecipe(RecipeEntity recipe);

  @Query('SELECT * FROM RecipeEntity')
  Future<List<RecipeEntity>> listAllRecipes();

  // New method to retrieve the rating of a recipe
  @Query('SELECT rating FROM RecipeEntity WHERE id = :id')
  Future<int?> getRecipeRating(int id);

  // New method to update the rating of a recipe
  @Query('UPDATE RecipeEntity SET rating = :rating WHERE id = :id')
  Future<void> updateRecipeRating(int id, int rating);
}
