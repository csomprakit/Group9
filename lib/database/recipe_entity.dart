import 'package:floor/floor.dart';

@Entity(tableName: 'Recipe')
class RecipeEntity {
  @PrimaryKey(autoGenerate: true)
  final int id;
  final String recipeName;
  final String description;
  final String ingredients;
  final String category;
  final String imagePath; // Add imagePath field

  RecipeEntity(this.id, this.recipeName, this.description, this.ingredients, this.category, this.imagePath);
}