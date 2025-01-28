import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username input field
            TextField(
              decoration: InputDecoration(labelText: "Username"),
            ),

            SizedBox(height: 10), // Spacing between input fields

            // Password input field
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),

            SizedBox(height: 20), // Spacing between input fields and register button

            // Register button
            ElevatedButton(
              onPressed: () {
                // Registration logic here later
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
