import 'package:fitttrack/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class signup extends StatelessWidget {
  signup({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();


Future<void> signUp(BuildContext context) async {
    try {
      final url = 'https://fitttrack.azurewebsites.net/user/signup';

      final body = jsonEncode({
        'name': _nameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];

        // Store the token using SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        String? savedToken = prefs.getString('token');
        print('Saved token: $savedToken');

        // Navigate to the user screen.
        Navigator.pushNamed(context, AppRoutes.first);
      } else {
        // Handle the error here.
        print('Sign up failed with status code: ${response.statusCode}.');

        // Show a Snackbar with the error message
       
      }
    } catch (e) {
      // Handle the exception here.
      print('An error occurred: $e');

      // Show a Snackbar with the error message
      
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
                top: MediaQuery.of(context).size.height * 0.15, // Adjust this value as needed
                left: MediaQuery.of(context).size.width * 0.05, // Adjust this value as needed
                child: Text(
                  'Sign Up',
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
                                focusNode: _nameFocusNode,
                                controller: _nameController,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Name',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  labelStyle: TextStyle(
                                    color: _nameFocusNode.hasFocus
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
                                focusNode: _emailFocusNode,
                                controller: _emailController,
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  labelStyle: TextStyle(
                                    color: _emailFocusNode.hasFocus
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
                                signUp(context);
                              },
                              child: Text('Sign Up',
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
                                  'Already have an account?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.third);
                                  },
                                  child: Text(
                                    ' Log In',
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
