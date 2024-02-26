import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if(index == 0) {
          GoRouter.of(context).push('/home');
        }
        else if(index == 1) {
          GoRouter.of(context).push('/search');
        }
        else {
          GoRouter.of(context).push('/settings');
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home,semanticLabel:'Home'),
            label: 'Home'

        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.search,semanticLabel:'Search Page'),
            label: 'Search'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings,semanticLabel:'Settings'),
            label: 'Settings'
        ),
      ],
    );
  }
}
