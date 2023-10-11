import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileStorageDemo(),
    );
  }
}

class FileStorageDemo extends StatefulWidget {
  @override
  _FileStorageDemoState createState() => _FileStorageDemoState();
}

class _FileStorageDemoState extends State<FileStorageDemo> {
  TextEditingController _textEditingController = TextEditingController();
  String _storedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Storage Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: 'Enter Text'),
            ),
            ElevatedButton(
              onPressed: _saveToFile,
              child: Text('Save to File'),
            ),
            ElevatedButton(
              onPressed: _readFromFile,
              child: Text('Read from File'),
            ),
            Text(_storedText),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_text_file.txt');
    await file.writeAsString(_textEditingController.text);
  }

  Future<void> _readFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_text_file.txt');
    if (await file.exists()) {
      final content = await file.readAsString();
      setState(() {
        _storedText = content;
      });
    } else {
      setState(() {
        _storedText = 'File not found.';
      });
    }
  }
}
