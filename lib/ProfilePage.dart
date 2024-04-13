import 'package:fitttrack/app_routes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  Future<Map<String, dynamic>> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('https://fitttrack.azurewebsites.net/user/profile'),
      headers: {
        'auth-token': token,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updatePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.put(
      Uri.parse('https://fitttrack.azurewebsites.net/user/updatePassword'),
      headers: {
        'auth-token': token,
      },
      body: jsonEncode(<String, String>{
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update password');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Handle the tap event here
            print('AppBar title tapped');
            Navigator.pushNamed(context, AppRoutes.third);
          },
          child: Text('Profile'),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name: ${snapshot.data?['name']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Username: ${snapshot.data?['username']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Email: ${snapshot.data?['email']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Change Password'),
                            content: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: _passwordController,
                                decoration:
                                    InputDecoration(labelText: 'New Password'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your new password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    updatePassword(_passwordController.text);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Change Password'),
                  ),
                  ElevatedButton(
  onPressed: () async {
    // Clear local user data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Navigate to the login page
    Navigator.pushNamed(context, AppRoutes.third);
  },
  child: Text('Logout'),
),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
