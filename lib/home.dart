import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final picker = ImagePicker();
  File _image;
  bool _loading = false;
  List _output;

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value) {
      // setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _loading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF415301),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Text(
                'Seedling AI',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 28),
              ),
              // Dividing box - - - - - - - - - - - - - - - - - - - - - - - - -|
              SizedBox(height: 40),
              // Whitebox container.- - - - - - - - - - - - - - - - - - - - - -|
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 150,
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/logo.png',
                                    ),
                                    // Buttuns: Buttons.separator.
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 300,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            Image.file(_image), // Global _image
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    _output != null
                                        ? Text(
                                            'It is a baby: ${_output[0]['label']}',
                                            style: TextStyle(
                                                color: Color(0xFF415301),
                                                fontSize: 25))
                                        : Container(),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              width: 80,
                              alignment: Alignment.center,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  color: Color(0xFF),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Image.asset('assets/camera0.png'),
                            ),
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: pickGalleryImage,
                            child: Container(
                              width: 80,
                              alignment: Alignment.center,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  color: Color(0xFF),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Image.asset('assets/gallery0.png'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
