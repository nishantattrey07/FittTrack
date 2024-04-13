import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Future<List<dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('https://fitttrack.azurewebsites.net/user/getNutrition'),
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
@override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              var date = DateTime.parse(item['date']).toLocal();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DefaultTabController(
  length: snapshot.data?.length ?? 0,
  child: Column(
    children: [
      TabBar(
        isScrollable: true,
        tabs: snapshot.data!.map<Tab>((item) {
          var date = DateTime.parse(item['date']).toLocal();
          return Tab(text: '${date.year}-${date.month}-${date.day}');
        }).toList(),
      ),
      Container(
        height: 200, // adjust this height to your needs
        child: TabBarView(
          children: snapshot.data!.map<Widget>((item) => Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total Calories: ${item['totalCalories']}'),
                  Text('Total Proteins: ${item['totalProteins']}'),
                  Text('Total Carbs: ${item['totalCarbs']}'),
                  Text('Total Fats: ${item['totalFats']}'),
                ],
              ),
            ),
          )).toList(),
        ),
      ),
    ],
  ),
),
                      DefaultTabController(
                        length: item['categories'].length,
                        child: Column(
                          children: [
                            TabBar(
                              isScrollable: true,
                              tabs: item['categories']
                                  .map<Tab>(
                                      (category) => Tab(text: category['name']))
                                  .toList(),
                            ),
                            Container(
                              height: 200, // adjust this height to your needs
                              child: TabBarView(
                                children: item['categories']
                                    .map<Widget>((category) => Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    'Calories: ${category['calories']}'),
                                                Text(
                                                    'Proteins: ${category['proteins']}'),
                                                Text(
                                                    'Carbs: ${category['carbs']}'),
                                                Text(
                                                    'Fats: ${category['fats']}'),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
