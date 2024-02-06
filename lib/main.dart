import 'package:flutter/material.dart';
import 'package:recipe_book_app/database/recipe_database.dart'; // Import your recipe database files
import 'HomePage.dart'; // Assuming ReadPage is defined in ReadPage.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RecipeDatabase database = await $FloorRecipeDatabase.databaseBuilder('recipe.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final RecipeDatabase database;

  const MyApp({required this.database, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(database: database), // Pass the database instance to ReadPage
    );
  }
}
