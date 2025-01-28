import 'package:flutter/material.dart';
import 'nav_bar.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Ensure that Splash and Login pages are removed from the stack when going to Home
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavigationBarPage()),
      (route) => false, // Removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Login page title
              Text('Login', style: Theme.of(context).textTheme.headlineMedium),

              SizedBox(height: 20), // Spacing between title text and textfields

              // Username input field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10), // Spacing between input fields

              // Password input field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20), // Spacing between textfields and login button

              // Login button
              ElevatedButton(
                onPressed: _login, // Use the _login method which uses named routes
                child: Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
