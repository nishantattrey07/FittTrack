// // Uri.parse(''),

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'app_routes.dart';
import 'dart:convert';
import 'Signup.dart';

class login extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String token = responseBody['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

    String? savedToken = prefs.getString('token');
        print('Saved token: $savedToken');
        Navigator.pushNamed(context, AppRoutes.first);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(e.toString())),
      // );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          canvasColor: const Color.fromARGB(255, 48, 47, 47),
          fontFamily: 'Metropolis',
          brightness: Brightness.dark,
        ),
        home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 32, 32, 32),
          body: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.15, // Adjust this value as needed
                left: MediaQuery.of(context).size.width *
                    0.05, // Adjust this value as needed
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.75,
                  child: Card(
                    color: Colors.white,
                    // ...
                    child: Padding(
                      padding: EdgeInsets.all(35.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                focusNode: _usernameFocusNode,
                                controller: _usernameController,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    color: _usernameFocusNode.hasFocus
                                        ? Colors.blue
                                        : Color.fromARGB(255, 107, 105, 105),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                focusNode: _passwordFocusNode,
                                controller: _passwordController,
                                cursorColor: Colors.blue,
                                style: TextStyle(color: Colors.black),
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    color: _passwordFocusNode.hasFocus
                                        ? Colors.blue
                                        : Color.fromARGB(255, 107, 105, 105),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.0),
                            ElevatedButton(
                              onPressed: () {
                                _login(
                                  _usernameController.text,
                                  _passwordController.text,
                                  context,
                                );
                              },
                              child: Text('Sign In',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue, // background color
                                foregroundColor: Colors.white, // text color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(30), // curved edges
                                ),
                                minimumSize: Size(double.infinity,
                                    50), // make the button long
                              ),
                            ),
                            SizedBox(height: 90),
                            Divider(
                              color: Colors.grey,
                              height: 20,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'New here?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.second);
                                  },
                                  child: Text(
                                    ' Sign Up',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

// ...
// ...
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
