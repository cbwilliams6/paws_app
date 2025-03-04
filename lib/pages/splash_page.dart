import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      body: Column(
        children: [
          // Top half with logo
          Expanded(
            flex: 2,
            child: Center(
              child: Image.asset(
                'assets/paws_logo.png',
                width: 300,
                height: 300,
              ),
            ),
          ),
          
          // Bottom half with buttons
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login Button
                ElevatedButton(
                  // Navigate to login page
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text("Login"),
                ),

                SizedBox(height: 20), // Vertical spacing between buttons
                
                // Register Button
                ElevatedButton(
                  // Navigate to register page
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text("Register"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
