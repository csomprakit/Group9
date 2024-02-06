import 'package:flutter/material.dart';
import 'database/recipe_database.dart'; // Import your recipe database files
import 'ReadPage.dart'; // Assuming RecipesPage is defined in RecipesPage.dart

class HomePage extends StatelessWidget {
  final RecipeDatabase database;

  const HomePage({required this.database, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Recipe Book'),
        backgroundColor: Colors.orangeAccent, // Change the color of the app bar
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'lib/assets/food.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to My Recipe Book!',
                  style: TextStyle(fontSize: 24.0, color: Colors.white),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to recipes page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReadPage(database: database)),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange)
                  ),
                  child: Text(
                      'View Recipes',
                      style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
