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
        primarySwatch: Colors.blue,
        canvasColor: const Color.fromARGB(255, 48, 47, 47),
        fontFamily: 'Metropolis',
        brightness: Brightness.dark,
        inputDecorationTheme: InputDecorationTheme(
          // Changes the border color when the TextField is selected
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          // Changes the highlight color when the TextField is selected
          selectionColor: Colors.blue,
          cursorColor: Colors.blue,
          selectionHandleColor: Colors.blue,
        ),
        focusColor: Colors.blue, // Changes the focus color
        hoverColor: Colors.blue, // Changes the hover color
      ),
      onGenerateRoute:
          AppRoutes.onGenerateRoute, // Use AppRoutes to generate routes
    );
  }
}


