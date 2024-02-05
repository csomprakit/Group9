import 'package:floor/floor.dart';
import './recipe_entity.dart';

@dao
abstract class RecipeDao {
  @insert
  Future<void> addRecipe(RecipeEntity event);
  @Query('SELECT * FROM Recipe')
  Future<List<RecipeEntity>> listAllEvents();
  @Query('SELECT DISTINCT category FROM Recipe')
  Future<List<String>> listCategories();
  @Query('SELECT * FROM Recipe WHERE id = :id')
  Stream<RecipeEntity?> findRecipeById(int id);
}