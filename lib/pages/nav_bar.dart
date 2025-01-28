import 'package:flutter/material.dart';
import 'package:paws_app/pages/splash_page.dart';

import 'generator_page.dart';
import 'favorites_page.dart';
import 'home_page.dart'; // Import the new Home Page

class NavigationBarPage extends StatefulWidget {
  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  var selectedIndex = 0;

  // Key to control the scaffold (open/close drawer)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget page;

    // Select the page based on the current index
    switch (selectedIndex) {
      case 0:
        page = HomePage();  // Set HomePage as the default
      case 1:
        page = GeneratorPage();
      case 2:
        page = FavoritesPage();
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('PAWS App'),
        leading: IconButton(
          icon: Icon(Icons.menu), // Button to open the drawer
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Clear the navigator stack and push SplashPage when logging out
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashPage()),
                (route) => false, // Remove all previous routes
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Navigation', style: TextStyle(color: Colors.white)),
            ),
            // Home page in the navigation drawer
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  selectedIndex = 0; // Set index to Home
                });
                Navigator.pop(context); // Close the drawer after selection
              },
            ),
            // Generator page in the navigation drawer
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Generator'),
              onTap: () {
                setState(() {
                  selectedIndex = 1; // Set index to Generator
                });
                Navigator.pop(context); // Close the drawer after selection
              },
            ),
            // Favorites page in the navigation drawer
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                setState(() {
                  selectedIndex = 2; // Set index to Favorites
                });
                Navigator.pop(context); // Close the drawer after selection
              },
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
            // If the drawer is open, close it
            _scaffoldKey.currentState?.closeDrawer();
            return false; // Don't exit the app
          }
          return true; // Allow back navigation
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: page, // Display the selected page
              ),
            ),
          ],
        ),
      ),
    );
  }
}
