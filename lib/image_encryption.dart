import 'dart:io';
// import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageUploader(),
    );
  }
}

class ImageUploader extends StatefulWidget {
  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  // Replace with your own encryption key and IV (Initialization Vector)
  final key = encrypt.Key.fromUtf8('YourEncryptionKey');
  final iv = encrypt.IV.fromLength(16);

  File? _imageFile;

  Future<void> _pickImage() async {
    // Implement image picking logic here (e.g., using the image_picker package).
  }

  Future<void> _encryptAndUpload() async {
    final imageBytes = await _imageFile!.readAsBytes();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedImage = encrypter.encryptBytes(imageBytes, iv: iv);
    final encryptedImageData = encryptedImage.base64;

    final fileName = path.basename(_imageFile!.path);
    final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');

    await storageRef.putData(Uint8List.fromList(encryptedImageData.codeUnits));

    print('Image uploaded and encrypted.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(_imageFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _imageFile != null ? _encryptAndUpload : null,
              child: Text('Encrypt and Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
