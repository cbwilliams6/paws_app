import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paws_app/pages/splash_page.dart';

import 'generator_page.dart';
import 'favorites_page.dart';
import 'gallery_page.dart';
import 'activity_log_page.dart';
import 'home_page.dart';

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
      case 3:
        page = GalleryPage();
      case 4:
        page = ActivityLogPage();
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
            onPressed: () async {
              try {
                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();
                
                // Clear the navigator stack and push SplashPage when logging out
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashPage()),
                  (route) => false, // Remove all previous routes
                );
              } catch (e) {
                // Handle error if signing out fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to log out. Please try again.')),
                );
              }
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
            // Gallery page in the navigation drawer
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Gallery'),
              onTap: () {
                setState(() {
                  selectedIndex = 3; // Set index to Gallery
                });
                Navigator.pop(context); // Close the drawer after selection
              },
            ),
            // Activity Log page in the navigation drawer
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Activity Log'),
              onTap: () {
                setState(() {
                  selectedIndex = 4; // Set index to Activity Log
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
