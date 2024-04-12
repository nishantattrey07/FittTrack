// app_routes.dart
import 'package:flutter/material.dart';
import 'login.dart'; // Import your screen widgets here
import 'userscreen.dart';
import 'InfoScreen.dart';
import 'AddCalorie.dart';
import 'AddFood.dart';
import 'ProfilePage.dart'; 
import 'Signup.dart';// Import UserScreen widget

class AppRoutes {
  static const first = '/';
  static const second = '/second';
  static const third = '/third';
  static const fourth = '/fourth';
  static const fifth = '/fifth'; 
  static const sixth = '/sixth';
  static const seventh = '/seventh';
  // Define a constant for the third route

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case first:
        return MaterialPageRoute(builder: (_) => login());
      case second:
        return MaterialPageRoute(builder: (_) => signup());
      case third:
        return MaterialPageRoute(builder: (_) => userscreen());
      case fourth:
        return MaterialPageRoute(builder: (_) => InfoScreen());
      case fifth:
        return MaterialPageRoute(builder: (_) => AddCalorie());
      case sixth:
        return MaterialPageRoute(builder: (_) => AddFood());
      case seventh:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => signup());
    }
  }
}
