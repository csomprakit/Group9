import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Settings"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
      ),
      body:
          ListView(
            children: [
              ListTile(
              title: Text("Import Contacts"),
              leading: Icon(Icons.contacts,
                size: 30.0,
                  semanticLabel:'Import Contacts'),
              onTap: (){
                GoRouter.of(context).push('/contacts');
              },
              ),
            ],
          ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
