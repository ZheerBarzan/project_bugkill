import 'package:flutter/material.dart';
import 'package:project_bugkill/components/my_drawer.dart';
import 'package:project_bugkill/pages/home_page.dart';
import 'package:project_bugkill/pages/profile_page.dart';
import 'package:project_bugkill/pages/settings_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 0;

  List pages = [
    const HomePage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.primary,
            activeColor: Theme.of(context).colorScheme.secondary,
            tabBackgroundColor: Theme.of(context).colorScheme.inversePrimary,
            gap: 8,
            onTabChange: goToPage,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "H O M E",
              ),
              GButton(
                icon: Icons.person,
                text: "P R O F I L E",
              ),
              GButton(
                icon: Icons.settings,
                text: "S E T T I N G S",
              ),
            ],
          ),
        ),
      ),
    );
  }
}