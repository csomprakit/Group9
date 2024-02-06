import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'recipe_dao.dart';
import 'recipe_entity.dart';

part 'recipe_database.g.dart';

@Database(version: 1, entities: [RecipeEntity])
abstract class RecipeDatabase extends FloorDatabase {
  RecipeDao get recipeDao;
}

