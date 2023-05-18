import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_image_practice/database_helper.dart';
import 'package:sqflite_image_practice/utility.dart';

import '../model/photo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() async {
    final data = await dbHelper.getPhotos();

    setState(() {
      photos = data;
    });

    print(photos.length);
  }

  Image getImageFromPhoto(Photo photo) {
    Uint8List data = Utility.dataFromBase64String(photo.imageString);
    Image img = Image.memory(
      data,
      fit: BoxFit.fill,
    );
    return img;
  }

  Future<Uint8List> getImageDataFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      return Uint8List(0);
    }
    return await pickedFile.readAsBytes();
  }

  Future<void> addImage(Uint8List imgData) async {
    Photo photo = Photo(Utility.base64String(imgData));
    await dbHelper.insertPhoto(photo);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database storing images practice"),
      ),
      body: ListView.builder(
        itemCount: photos.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          return getImageFromPhoto(photos[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          Uint8List data = await getImageDataFromGallery();
          if (data.isEmpty) {
            return;
          }
          addImage(data);
        },
      ),
    );
  }
}
