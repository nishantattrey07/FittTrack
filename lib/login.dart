import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_routes.dart';
import 'dart:convert';



class login extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(
      String username, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://fitttrack.azurewebsites.net/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, then parse the JSON.
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String token = responseBody['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );
        Navigator.pushNamed(context, AppRoutes.third);
      } else {
        // If the server returns an unsuccessful response code, then throw an exception.
        throw Exception('Failed to login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FittTrack'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                _login(_usernameController.text, _passwordController.text,context);
              },
            ),
            SizedBox(height: 16.0),
            TextButton(
              child: Text('Forgot password?'),
              onPressed: () {
                // Navigate to forgot password screen
              },
            ),
            SizedBox(height: 16.0),
            TextButton(
              child: Text('Sign Up'),
              onPressed: () {
                // Navigate to sign up screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
