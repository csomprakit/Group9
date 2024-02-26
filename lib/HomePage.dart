import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'database/recipe_database.dart'; // Import your recipe database files
import 'bottom_nav.dart';

class HomePage extends StatelessWidget {
  final RecipeDatabase database;

  const HomePage({required this.database, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Recipe Book'),
        automaticallyImplyLeading: false,
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
                    GoRouter.of(context).push('/search');
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
      bottomNavigationBar: BottomNav(),
    );
  }
}
