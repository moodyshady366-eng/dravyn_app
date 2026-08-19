import 'package:flutter/material.dart';
import 'core/services/update_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) {
              UpdateService.checkForUpdate(context);
              return Text('Dravyn App');
            }
          ),
        ),
      ),
    );
  }
}
