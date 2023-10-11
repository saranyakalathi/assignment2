import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Define the method channel
  static const platform = const MethodChannel('com.example.myapp/toast');

  // Method to show a native toast
  Future<void> _showNativeToast(String message) async {
    try {
      await platform.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      print("Failed to invoke native method: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MethodChannel Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Call the native method to show a toast
              _showNativeToast("Hello from Flutter!");
            },
            child: Text('Show Native Toast'),
          ),
        ),
      ),
    );
  }
}
