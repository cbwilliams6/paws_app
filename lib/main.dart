import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'app_state.dart';

void main() {
  runApp(MyApp()); // flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Test App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        initialRoute: '/', // SplashPage will be the initial route
        onGenerateRoute: RouteGenerator.generateRoute, // Custom route generation
      ),
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => MyHomePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('ERROR: Route not found')),
      ),
    );
  }
}
