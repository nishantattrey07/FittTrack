import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Food {
  final String id;
  final String name;
  final String category;
  final double protein;
  final double fat;
  final double carbs;
  final double calories;
  final String quantity;

  Food(
      {required this.id,
      required this.name,
      required this.category,
      required this.protein,
      required this.fat,
      required this.carbs,
      required this.calories,
      required this.quantity});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
      protein: json['protein'].toDouble(),
      fat: json['fat'].toDouble(),
      carbs: json['carbs'].toDouble(),
      calories: json['calories'].toDouble(),
      quantity: json['quantity'],
    );
  }
}

class AddCalorie extends StatefulWidget {
  @override
  _AddCalorieState createState() => _AddCalorieState();
}

class _AddCalorieState extends State<AddCalorie> {
  TextEditingController _searchController = TextEditingController();
  Future<List<Food>>? _foodsFuture;

  @override
  void initState() {
    super.initState();
    _foodsFuture = getFoods();
  }

  Future<List<Food>> getFoods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('https://fitttrack.azurewebsites.net/user/foods'),
      headers: {
        'auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Response Data: $jsonResponse');
      return jsonResponse.map((item) => Food.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _foodsFuture = getFoods().then((foods) => foods
                      .where((food) =>
                          food.name.toLowerCase().contains(value.toLowerCase()))
                      .toList());
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: _foodsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Food food = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text(food.name),
                          subtitle: Text(
                              'Category: ${food.category}\nProtein: ${food.protein}\nFat: ${food.fat}\nCarbs: ${food.carbs}\nCalories: ${food.calories}\nQuantity: ${food.quantity}'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm'),
                                  content:
                                      Text('Do you want to add this food?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        // Store the food data in variables
                                        double calories = food.calories;
                                        double protein = food.protein;
                                        double fat = food.fat;
                                        double carbs = food.carbs;

                                        // Get current date
                                        DateTime now = DateTime.now();
                                        String formattedDate =
                                            DateFormat('yyyy-MM-dd').format(
                                                now); // Format date as needed

                                        // Prepare data
                                        Map<String, dynamic> data = {
                                          'date': formattedDate,
                                          'category': food.category,
                                          'calories': calories,
                                          'proteins': protein,
                                          'carbs': carbs,
                                          'fats': fat,
                                        };

                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        String? token =
                                            prefs.getString('token');
                                        if (token == null) {
                                          throw Exception('Token not found');
                                        }

                                        // Send POST request
                                        final response = await http.post(
                                          Uri.parse(
                                              'https://fitttrack.azurewebsites.net/user/addNutrition'),
                                          headers: {
                                            'Content-Type': 'application/json',
                                            'auth-token':
                                                token, // Assuming you have the token variable available here
                                          },
                                          body: json.encode(data),
                                        );

                                        // Show SnackBar
                                        final snackBar = SnackBar(
                                          content: Text(
                                              response.statusCode == 200
                                                  ? 'Food added successfully'
                                                  : 'Failed to add food'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
              // Your existing builder code here...
            ),
          ),
        ],
      ),
    );
  }
}
