import 'package:flutter/material.dart';

class AddCalorie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Information:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This is some information about the app.',
              style: TextStyle(fontSize: 18),
            ),
            // Add more Text Widgets here for more information
          ],
        ),
      ),
    );
  }
}
