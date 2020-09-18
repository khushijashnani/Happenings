import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'registertwo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPart1 extends StatefulWidget {
  @override
  _RegisterPart1State createState() => _RegisterPart1State();
}

class _RegisterPart1State extends State<RegisterPart1> {
  File _profile, _aadhar;
  String name;
  int age;
  String phone_no;
  String gender;
  bool isuploading = false;
  bool verify_Aadhar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  /// Select an image via gallery or camera
  Future<void> _pickProfileImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _profile = selected;
    });
  }

  Future<void> _pickAadharImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _aadhar = selected;
    });
  }

  Future readText() async {

    print("Inside Read Text");

    FirebaseVisionImage image = FirebaseVisionImage.fromFile(_aadhar);
    TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    print("Before Vision Text");
    VisionText text = await recognizer.processImage(image);

    setState(() {
      print(text.blocks[0].lines);
      name = text.blocks[1].lines[0].text;
      age = DateTime.now().year -
          int.parse(text.blocks[1].lines[1].text.split("/")[3].toString());
      // aadhar_no = text.blocks[2].lines[0].text;
      phone_no = text.blocks[1].lines[3].text.split(" ")[2];
      gender = text.blocks[1].lines[2].text.split("/")[1];
    });

    print(name);
    print(age);
    //print(aadhar_no);
    print(phone_no);
    print(gender);
    return true;

  }

  Future<void> uploadImages() async {
    if (_profile != null && _aadhar != null) {
      setState(() {
        isuploading = true;
      });

      String profileImageUrl;
      final String picture1 =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageUploadTask task1 = storage.ref().child(picture1).putFile(_profile);
      
      task1.onComplete.then((snapshot) async {

        bool rc = await readText();

        setState(() {
          verify_Aadhar = rc;
          isuploading = false;
        });

        profileImageUrl = await snapshot.ref.getDownloadURL();
        print(profileImageUrl);

        Fluttertoast.showToast(
            msg: "Aadhar verified, Profile Image uploaded.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RegisterPart2(imageUrl: profileImageUrl, name:name, age:age,gender:gender, phone_no: phone_no)));
      }).catchError((e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      });
    } else if (_profile == null) {
      Fluttertoast.showToast(
          msg: "Please Upload Profile Image...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    } else if (_aadhar == null) {
      Fluttertoast.showToast(
          msg: "Please Upload Aadhar Image...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: Color(0xff102733)),
              ),
              isuploading
                  ? Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Verifying Aadhar...",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          SizedBox(
                            height: 30,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    )
                  : Container(
                      child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 30, 0, 0),
                                child: InkWell(
                                  child: Icon(
                                    Icons.keyboard_backspace,
                                    color: Colors.yellow[600],
                                    size: 30,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, right: 10),
                                      child: Image.asset(
                                        "assets/logo.png",
                                        height: 35,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30, right: 30.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "HAPPEN",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          Text(
                                            "INGS",
                                            style: TextStyle(
                                                color: Color(0xffFFA700),
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800,
                                                fontStyle: FontStyle.italic),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Create",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    ),
                                    Text(
                                      "New Account",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "1",
                                          style: TextStyle(
                                              color: Colors.yellow[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        Text(
                                          "/2",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "Steps",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          DottedBorder(
                            color: Colors.yellow[600],
                            padding: EdgeInsets.all(8),
                            dashPattern: [6],
                            borderType: BorderType.Circle,
                            child: Container(
                              height: 160,
                              width: double.maxFinite,
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Color(0xff102733),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _pickProfileImage(
                                              ImageSource.camera);
                                        },
                                        child: Icon(Icons.add_a_photo,
                                            color: Colors.white, size: 30),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Use Camera",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _pickProfileImage(
                                              ImageSource.gallery);
                                        },
                                        child: Icon(Icons.photo_library,
                                            color: Colors.white, size: 30),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Use Gallery",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _profile != null
                                ? _profile.path.split('/').last
                                : "Upload Your Profile Image",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 30),
                          DottedBorder(
                            color: Colors.yellow[600],
                            padding: EdgeInsets.all(8),
                            dashPattern: [6],
                            borderType: BorderType.Circle,
                            child: Container(
                              height: 160,
                              width: double.maxFinite,
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                color: Color(0xff102733),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _pickAadharImage(
                                              ImageSource.camera);
                                        },
                                        child: Icon(Icons.add_a_photo,
                                            color: Colors.white, size: 30),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Use Camera",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _pickAadharImage(
                                              ImageSource.gallery);
                                        },
                                        child: Icon(Icons.photo_library,
                                            color: Colors.white, size: 30),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Use Gallery",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _aadhar != null
                                ? _aadhar.path.split('/').last
                                : "Upload Your Aadhar Card",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 30, 30),
                            child: GestureDetector(
                                onTap: () {
                                  uploadImages();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Verify",
                                      style: TextStyle(
                                          color: Colors.yellow[600],
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: Colors.yellow[600]),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
