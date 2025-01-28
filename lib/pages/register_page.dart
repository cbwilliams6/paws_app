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
            TextField(
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add registration logic here
                // Navigate to splash page or another page
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