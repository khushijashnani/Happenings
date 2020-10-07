import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uvento/home.dart';
import 'package:uvento/login.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RegisterPart2 extends StatefulWidget {
  String imageUrl;
  String name;
  int age;
  String phone_no;
  String gender;
  RegisterPart2({this.imageUrl, this.age,this.phone_no,this.gender, this.name});

  @override
  _RegisterPart2State createState() => _RegisterPart2State(name: name, age: age, phone: phone_no, gender: gender, imageUrl: imageUrl);
}

class _RegisterPart2State extends State<RegisterPart2> {

  String imageUrl;
  String phone;
  String name;
  String  gender;
  int age;
  _RegisterPart2State({this.name, this.age, this.phone, this.gender, this.imageUrl});

  TextEditingController usernameController;
  TextEditingController passController;
  TextEditingController nameController;
  TextEditingController addressController;
  TextEditingController ageController;
  TextEditingController emailController;
  TextEditingController phoneController;
  TextEditingController detailsController;
  bool passvis = true;
  final _signupFormKey = GlobalKey<FormState>();
  final _scaffoldKey1 = GlobalKey<ScaffoldState>();
  String username = "", password = "", address = "", email = "", details = "";
  String image = "";
  double screenWidth, screenHeight;
  String type = "ATTENDEE";
  bool isuploading = false;

  @override
  void initState() {
    print(imageUrl);
    usernameController = TextEditingController();
    passController = TextEditingController();
    nameController = TextEditingController();
    ageController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    detailsController = TextEditingController();
    setState(() {
      image = imageUrl;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      key: _scaffoldKey1,
      body: Material(
        color: Color(0xff102733),
        child: isuploading ? 
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Uploading your details...", style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(height: 20,),
              CircularProgressIndicator()
            ],
          ),
        ) :
        ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: InkWell(
                    child: Icon(
                      Icons.keyboard_backspace, 
                      color: Colors.yellow[800],
                      size: 30,
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 10),
                      child: Image.asset(
                        "assets/logo.png",
                        height: 35,
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 30,right: 30.0),
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
                  ]
                ),
              ],
            ),
            SizedBox(height: 30,),
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
                          fontSize: 25
                        ),
                      ),
                      Text(
                        "New Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            "2",
                            style: TextStyle(
                              color: Colors.yellow[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                            ),
                          ),
                          Text(
                            "/2",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Steps",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 30,),

            Form(
              key: _signupFormKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  children: [

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                        // Column(
                        //   children: [
                            // Container(
                            //   width: screenWidth - 180,
                            //   child: TextFormField(
                            //     maxLines: 1,
                            //     controller: nameController,
                            //     onChanged: (value) => name = value,
                            //     validator: (value) {
                            //       if (value.isEmpty) {
                            //         return 'Please enter your name';
                            //       }
                            //       return null;
                            //     },
                            //     style: TextStyle(color: Colors.white),
                            //     decoration: InputDecoration(
                            //       prefixIcon: Icon(Icons.person, color: Colors.grey),
                            //       border: new OutlineInputBorder(
                            //         borderRadius: new BorderRadius.circular(25.0),
                            //         borderSide: new BorderSide(),
                            //       ),
                            //       labelStyle: TextStyle(color: Colors.yellow[600]),
                            //       //icon: Icon(Icons.person, color: Colors.white),
                            //       hintText: "Name",
                            //       hintStyle: TextStyle(color: Colors.grey)
                            //     ),
                            //   )
                            // ),

                            Container(
                              width: screenWidth - 60,
                              child: Row(
                                children: <Widget>[
                                  AutoSizeText(
                                    "Welcome,  ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  Container(
                                    width: screenWidth - 180,
                                    child: AutoSizeText(
                                      name,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Color(0xffFFA700),
                                          fontSize: 25,
                                          fontWeight: FontWeight.w800,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth - 160,
                                      child: AutoSizeText(
                                        "Thank you for registering",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth - 160,
                                      child: AutoSizeText(
                                        "with us",
                                        style: TextStyle(color: Colors.yellow[600], fontSize: 16),
                                        maxLines: 1,
                                      ),
                                    )
                                    // Container(
                                    //   width: screenWidth - 160,
                                    //   child: Row(
                                    //     children: <Widget>[
                                    //       AutoSizeText(
                                    //         "HAPPEN",
                                    //         style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 20,
                                    //             fontWeight: FontWeight.w800,
                                    //             fontStyle: FontStyle.italic),
                                    //       ),
                                    //       AutoSizeText(
                                    //         "INGS",
                                    //         maxLines: 1,
                                    //         style: TextStyle(
                                    //             color: Color(0xffFFA700),
                                    //             fontSize: 20,
                                    //             fontWeight: FontWeight.w800,
                                    //             fontStyle: FontStyle.italic),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                                image == "" ? 
                                Container(
                                  width:  90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(45)),
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      //colorFilter: new ColorFilter.mode(Colors.white, BlendMode.srcOver),
                                      image: AssetImage(
                                        "assets/profilepic.jpg"
                                      ),
                                    ),
                                  ),
                                  child:  Center(),
                                ) : 
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(45)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(45)),
                                    child: Image.network(
                                      imageUrl,
                                      height: 90,
                                      width : 90,
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded /loadingProgress.expectedTotalBytes : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 10,),

                            Container(
                              width: screenWidth - 60,
                              child: TextFormField(
                                maxLines: 1,
                                controller: usernameController,
                                onChanged: (value) => username = value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_pin, color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelStyle: TextStyle(color: Colors.yellow[800]),
                                  //icon: Icon(Icons.person, color: Colors.white),
                                  hintText: "Userame",
                                  hintStyle: TextStyle(color: Colors.grey)
                                ),
                              )
                            ),
                        //   ],
                        // ),
                       
                    //   ],
                    // ),

                    SizedBox(height: 15,),

                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        obscureText: passvis,
                        
                        maxLines: 1,
                        controller: passController,
                        onChanged: (value) => password = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          if (!RegExp(
                                      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                                  .hasMatch(passController.text)) {
                                return "Please include atleast 1 lowercase, 1 uppercase,\n1 digit and 1 special character";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                          suffix: Padding(
                            padding:EdgeInsets.fromLTRB(0, 0, 2, 0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  passvis = !passvis;
                                });
                              },
                              child: Icon(passvis ? Icons.visibility : Icons.visibility_off, color: Colors.white,)
                            )
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ),

                    SizedBox(height: 15,),

                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        maxLines: 1,
                        controller: addressController,
                        onChanged: (value) => address = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Address';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                          
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Address",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ),

                    SizedBox(height: 15,),

                    phone == "" ? Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        controller: phoneController,
                        onChanged: (value) => phone = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Contact Number';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Colors.grey),
                          
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Phone",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ) : Container(),
                    
                    phone == "" ? SizedBox(height: 15,) : Container(),

                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                        onChanged: (value) => email = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email id';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ),

                    SizedBox(height: 15,),

                    Row(
                      children: [
                        Radio(
                          value: "ATTENDEE",
                          groupValue: type,
                          onChanged: (value){
                            setState(() {
                              type = value;
                            });
                          },
                        ),
                        Text(
                          'ATTENDEE',
                          style: new TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                        Radio(
                          value: "ORGANISATION",
                          groupValue: type,
                          onChanged: (value) {
                            setState(() {
                              type = value;
                            });
                          },
                        ),
                        Text(
                          'ORGANISATION',
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15,),

                    type == "ATTENDEE" ? 
                    Container(height: 0,width: 0,)
                    // Row(
                    //   children: [
                    //     Container(
                    //       width: screenWidth*0.3,
                    //       child: TextFormField(
                    //         keyboardType: TextInputType.number,
                    //         maxLines: 1,
                    //         controller: ageController,
                    //         onChanged: (value) => age = value,
                    //         validator: (value) {
                    //           if (value.isEmpty) {
                    //             return 'Enter Age';
                    //           }
                    //           return null;
                    //         },
                    //         style: TextStyle(color: Colors.white),
                    //         decoration: InputDecoration(
                    //           prefixIcon: Icon(Icons.perm_contact_calendar, color: Colors.grey),
                              
                    //           border: new OutlineInputBorder(
                    //             borderRadius: new BorderRadius.circular(25.0),
                    //             borderSide: new BorderSide(),
                    //           ),
                    //           labelStyle: TextStyle(color: Colors.yellow[600]),
                    //           //icon: Icon(Icons.person, color: Colors.white),
                    //           hintText: "Age",
                    //           hintStyle: TextStyle(color: Colors.grey)
                    //         ),
                    //       )
                    //     ),

                    //     Row(
                    //       children: [
                    //         Radio(
                    //           value: "Male",
                    //           groupValue: gender,
                    //           onChanged: (value){
                    //             setState(() {
                    //               gender = value;
                    //             });
                    //           },
                    //         ),
                    //         Text(
                    //           'Male',
                    //           style: new TextStyle(fontSize: 16.0, color: Colors.grey),
                    //         ),
                    //         Radio(
                    //           value: "Female",
                    //           groupValue: gender,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               gender = value;
                    //             });
                    //           },
                    //         ),
                    //         Text(
                    //           'Female',
                    //           style: new TextStyle(
                    //             fontSize: 16.0,
                    //             color: Colors.grey
                    //           ),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // ) 
                    : 
                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        controller: detailsController,
                        onChanged: (value) => details = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Fill details of your organisation';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.event_note, color: Colors.grey),
                          
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.event_note, color: Colors.grey),
                          hintText: "Organisation Details...",
                          hintStyle: TextStyle(color: Colors.grey,),
                          
                        ),
                      )
                    ),

                    SizedBox(height: 15,),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(100))
                      ),
                      height: 60,
                      
                      width: screenWidth - 60,
                      child: InkWell(
                        hoverColor: Colors.grey[700],
                        onTap: (){
                          register();
                        },
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.yellow[600],
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void register() async {
    if (_signupFormKey.currentState.validate()){

      setState(() {
        isuploading = true;
      });

      print(email);
      print(password);
      print(gender);
      print(address);
      print(phone);
      print(name);
      print(username);
      print(age);

      var data;

      if (type == "ATTENDEE"){

        data = {
          'name' : name,
          'username': username, 
          'password': password, 
          'type': type,
          'age' : age,
          'gender' : gender,
          'address' : address,
          'email_id' : email,
          'phone' : phone,
          'image' : imageUrl,
          
        };
      } else {
        data = {
          'name' : name,
          'username': username,
          'password': password,
          'type': type,
          'address' : address,
          'email_id' : email,
          'phone' : phone,
          'image' : imageUrl,
          'details' : details
        };
      }
      print(data);
      var jsonData;
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "charset": "utf-8"
      };
      var response = await http.post('https://rpk-happenings.herokuapp.com/register',
          headers: headers, body: json.encode(data));
      
      print(response.body);
      jsonData = json.decode(response.body);
      String message = jsonData["message"];

      if (message == "User created successfully") {
        setState(() {
          isuploading = false;
        });

        Fluttertoast.showToast(
          msg: "Registered successfully...\nPlease login now",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      }
    }
  }
}