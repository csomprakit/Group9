class Recipe
{
  final int id;
  final String recipeName;
  final String description;
  final String ingredients;
  final String category;
  final DateTime date;

  Recipe(this.id, this.recipeName, this.description, this.ingredients,
      this.category, this.date);
}