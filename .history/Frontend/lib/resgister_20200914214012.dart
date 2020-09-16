import 'dart:io';


import 'package:flutter/material.dart';

//import 'package:image_picker/image_picker.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  File _imageFile;
  String name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0xff102733)),
            ),
            Container(
              child: ListView(
                children: [
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 10),
                        child: IconButton(
                          icon: Icon(
                            Icons.keyboard_backspace, 
                            color: Colors.yellow[600],
                            size: 30,
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
              //     Row(
              //   children: <Widget>[
              //     Text(
              //       "UVE",
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 25,
              //           fontWeight: FontWeight.w800),
              //     ),
              //     Text(
              //       "NTO",
              //       style: TextStyle(
              //           color: Color(0xffFFA700),
              //           fontSize: 25,
              //           fontWeight: FontWeight.w800),
              //     )
              //   ],
              // ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0,30, 0),
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
                                fontSize: 30
                              ),
                            ),
                            Text(
                              "New Account",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30
                                  ),
                                ),
                                Text(
                                  "/2",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}