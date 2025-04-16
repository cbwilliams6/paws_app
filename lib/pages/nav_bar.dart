import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paws_app/pages/splash_page.dart';

import 'gallery_page.dart';
import 'activity_log_page.dart';
import 'settings_page.dart';
import 'home_page.dart';

class NavigationBarPage extends StatefulWidget {
  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  @override
  void initState() {
    super.initState();
    _updatePiUserId();
  }

  Future<void> _updatePiUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('raspberry_pis').doc('pi1').set({
        'currentUserId': user.uid,
      });
      print('Updated Pi pairing with user ID: ${user.uid}');
    }
  }

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
        page = GalleryPage();
      case 2:
        page = ActivityLogPage();
      case 3:
        page = SettingsPage();
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
                await FirebaseFirestore.instance.collection('raspberry_pis').doc('pi1').update({
                  'currentUserId': FieldValue.delete(),
                });
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
              child: Image.asset(
                'assets/paws_logo.png',
                fit: BoxFit.contain,
              ),
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
            // Gallery page in the navigation drawer
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                setState(() {
                  selectedIndex = 1; // Set index to Gallery
                });
                Navigator.pop(context); // Close the drawer after selection
              },
            ),
            // Activity Log page in the navigation drawer
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Activity Log'),
              onTap: () {
                setState(() {
                  selectedIndex = 2; // Set index to Activity Log
                });
                Navigator.pop(context); // Close the drawer after selection
              },
            ),
            // Settings page in the navigation drawer
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                setState(() {
                  selectedIndex = 3; // Set index to Activity Log
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
