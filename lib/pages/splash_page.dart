import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    // Navigate to login page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("Login"),
                ),
                SizedBox(height: 20),
                
                // Register Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to register page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
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
