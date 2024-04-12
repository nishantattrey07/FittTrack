// main.dart
import 'package:flutter/material.dart';
import 'app_routes.dart'; // Import your AppRoutes class

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              color: Color(0xFFDB3022), foregroundColor: Color(0xFF222222)),
          canvasColor: Colors.transparent,
          fontFamily: 'Metropolis',
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all((const Color(0xFF222222))))),
          primaryColor: const Color(0xFF222222),
          scaffoldBackgroundColor: const Color(0xFFF9F9F9),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all((const Color(0xFF222222))))),
          textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF222222)),
              )),
      onGenerateRoute:
          AppRoutes.onGenerateRoute, // Use AppRoutes to generate routes
    );
  }
}
