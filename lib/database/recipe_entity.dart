import 'package:floor/floor.dart';

@Entity(tableName: "Recipe")
class RecipeEntity
{
  @primaryKey
  final int id;
  final String recipeName;
  final String description;
  final String ingredients;
  final String category;
  final int occurredOn;

  RecipeEntity(this.id, this.recipeName, this.description, this.ingredients,
      this.category, this.occurredOn);
}


