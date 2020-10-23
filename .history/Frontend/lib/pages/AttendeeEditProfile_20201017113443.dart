import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/home.dart';
import 'package:uvento/models/event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uvento/models/attendee.dart';

class AttendeeEditProfile extends StatefulWidget {
  Attendee attendee;
  AttendeeEditProfile({Key key, this.attendee}) : super(key: key);

  @override
  _AttendeeEditProfileState createState() => _AttendeeEditProfileState();
}

class _AttendeeEditProfileState extends State<AttendeeEditProfile> {
  final _AttendeeEditProfileKey = GlobalKey<FormState>();
  TextEditingController name;
  TextEditingController age;
  TextEditingController address;
  TextEditingController username;
  TextEditingController password;
  TextEditingController email;
  String gender;
  TextEditingController phone_no;
  String imageUrl;
  File image;
  bool loading = false;
  bool showName = false, showAddress = false, showUsername = false, showPassword = false, showEmail = false, showPhone = false;
  bool cName = false, cAddress = false, cUsername = false, cPassword = false, cEmail = false, cPhone = false;
  final _signupFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double screenWidth, screenHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = null;
    if (widget.attendee != null) {
      name = TextEditingController(text: widget.attendee.name);
      age = TextEditingController(text: widget.attendee.age.toString());
      address = TextEditingController(text: widget.attendee.address);
      phone_no = TextEditingController(text: widget.attendee.phone_no);
      username = TextEditingController(text: widget.attendee.username);
      password = TextEditingController(text: widget.attendee.password);
      email = TextEditingController(text: widget.attendee.email);
      gender = widget.attendee.gender;
      imageUrl = widget.attendee.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff102733),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _signupFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: Icon(Icons.arrow_back_ios, color: Colors.yellow[800])
                            )
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child : Text("Update Profile", style: TextStyle(color: Colors.white, fontSize : 18))
                          ),
                          Container()
                        ]
                      ),
                    ),

                    SizedBox(height: 20),

                    Stack(
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            child: Image.network(
                              widget.attendee.imageUrl,
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 50,
                            height: 50
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 20),

                    showName
                    ? 
                    Container(
                        width: screenWidth,
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  width: screenWidth - 80,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
                                  child: TextFormField(
                                    initialValue: name.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      setState(() {
                                        name.text = value;
                                        cName = true;
                                      });
                                      
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle,
                                          color: Colors.white),
                                      border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: new BorderSide(color: CARD),
                                      ),
                                      labelStyle: TextStyle(color: Colors.yellow[800]),
                                      hintText: "Name",
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Material(
                                  color: CARD,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: InkWell(
                                    onTap: (){
                                      setState((){
                                        showName = false;
                                      });
                                    },
                                    child: Icon(Icons.check_circle, color: Colors.white,),
                                  )
                                )

                              )
                            ],
                          ),
                      )
                     : Container(
                        width: screenWidth,
                        height: 55,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Material(
                          elevation: 5,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: CARD,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: CARD),
                              child: ListTile(
                                title: Text(
                                  name.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                  )
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showName = true;
                                    });
                                  },
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                                leading:
                                    Icon(Icons.account_circle, color: Colors.white),
                              )),
                        )),

                        SizedBox(height: 15),

                        showUsername
                        ? Container(
                            width: screenWidth,
                            height: 60,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      width: screenWidth - 80,
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        color: CARD,
                                      ),
                                      child: TextFormField(
                                        initialValue: username.text,
                                        maxLines: 1,
                                        onChanged: (value) {
                                          setState(() {
                                            username.text = value;
                                            cUsername = true;
                                          });
                                          
                                        },
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person,
                                              color: Colors.white),
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(color: CARD),
                                          ),
                                          labelStyle: TextStyle(color: Colors.yellow[800]),
                                          hintText: "Username",
                                          hintStyle: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Material(
                                      color: CARD,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: InkWell(
                                        onTap: (){
                                          setState((){
                                            showUsername = false;
                                          });
                                        },
                                        child: Icon(Icons.check_circle, color: Colors.white,),
                                      )
                                    )

                                  )
                                ],
                              ),
                          )
                        : Container(
                            width: screenWidth,
                            height: 55,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Material(
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              color: CARD,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      color: CARD),
                                  child: ListTile(
                                    title: Text(
                                      username.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                      )
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showUsername = true;
                                        });
                                      },
                                      child: Icon(Icons.edit, color: Colors.white),
                                    ),
                                    leading:
                                        Icon(Icons.person, color: Colors.white),
                                  )),
                            )),

                    SizedBox(height: 15),
                    showPassword
                        ? Container(
                            width: screenWidth,
                            height: 60,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      width: screenWidth - 80,
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        color: CARD,
                                      ),
                                      child: TextFormField(
                                        initialValue: password.text,
                                        maxLines: 1,
                                        onChanged: (value) {
                                          setState(() {
                                            password.text = value;
                                            cPassword = true;
                                          });
                                          
                                        },
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock,
                                              color: Colors.white),
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(color: CARD),
                                          ),
                                          labelStyle: TextStyle(color: Colors.yellow[800]),
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Material(
                                      color: CARD,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: InkWell(
                                        onTap: (){
                                          setState((){
                                            showPassword = false;
                                          });
                                        },
                                        child: Icon(Icons.check_circle, color: Colors.white,),
                                      )
                                    )

                                  )
                                ],
                              ),
                          )
                        : Container(
                            width: screenWidth,
                            height: 55,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Material(
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              color: CARD,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      color: CARD),
                                  child: ListTile(
                                    title: Text(
                                      password.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                      )
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showPassword = true;
                                        });
                                      },
                                      child: Icon(Icons.edit, color: Colors.white),
                                    ),
                                    leading:
                                        Icon(Icons.lock, color: Colors.white),
                                  )),
                            )),

                    SizedBox(height: 15),

                    showAddress
                        ? Container(
                            width: screenWidth,
                            height: 60,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Container(
                                      width: screenWidth - 80,
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        color: CARD,
                                      ),
                                      child: TextFormField(
                                        initialValue: address.text,
                                        maxLines: 1,
                                        onChanged: (value) {
                                          setState(() {
                                            address.text = value;
                                            cAddress = true;
                                          });
                                          
                                        },
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.location_on,
                                              color: Colors.white),
                                          border: new OutlineInputBorder(
                                            borderRadius: new BorderRadius.circular(25.0),
                                            borderSide: new BorderSide(color: CARD),
                                          ),
                                          labelStyle: TextStyle(color: Colors.yellow[800]),
                                          hintText: "Address",
                                          hintStyle: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Material(
                                      color: CARD,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: InkWell(
                                        onTap: (){
                                          setState((){
                                            showAddress = false;
                                          });
                                        },
                                        child: Icon(Icons.check_circle, color: Colors.white,),
                                      )
                                    )

                                  )
                                ],
                              ),
                          )
                        : Container(
                            width: screenWidth,
                            height: 55,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Material(
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              color: CARD,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      color: CARD),
                                  child: ListTile(
                                    title: Text(
                                      address.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                      )
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        setState(() {
                                          showAddress = true;
                                        });
                                      },
                                      child: Icon(Icons.edit, color: Colors.white),
                                    ),
                                    leading:
                                        Icon(Icons.location_on, color: Colors.white),
                                  )),
                            )),

                    SizedBox(height : 15),

                    showEmail
                    ? 
                    Container(
                        width: screenWidth,
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  width: screenWidth - 80,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
                                  child: TextFormField(
                                    initialValue: email.text,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      setState(() {
                                        email.text = value;
                                        cEmail = true;
                                      });
                                      
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email,
                                          color: Colors.white),
                                      border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: new BorderSide(color: CARD),
                                      ),
                                      labelStyle: TextStyle(color: Colors.yellow[800]),
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Material(
                                  color: CARD,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: InkWell(
                                    onTap: (){
                                      setState((){
                                        showEmail = false;
                                      });
                                    },
                                    child: Icon(Icons.check_circle, color: Colors.white,),
                                  )
                                )

                              )
                            ],
                          ),
                      )
                     : Container(
                        width: screenWidth,
                        height: 55,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Material(
                          elevation: 5,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: CARD,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: CARD),
                              child: ListTile(
                                title: Text(
                                  email.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                  )
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showEmail = true;
                                    });
                                  },
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                                leading:
                                    Icon(Icons.email, color: Colors.white),
                              )),
                        )),

                    SizedBox(height: 15),

                    showPhone
                    ? 
                    Container(
                        width: screenWidth,
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  width: screenWidth - 80,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
                                  child: TextFormField(
                                    initialValue: phone_no.text,
                                    maxLines: 1,
                                    onChanged: (value){
                                      setState(() {
                                        phone_no.text = value;
                                        cPhone = true;
                                      });
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone,
                                          color: Colors.white),
                                      border: new OutlineInputBorder(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: new BorderSide(color: CARD),
                                      ),
                                      labelStyle: TextStyle(color: Colors.yellow[800]),
                                      hintText: "Phone Number",
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Material(
                                  color: CARD,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: InkWell(
                                    onTap: (){
                                      setState((){
                                        showPhone = false;
                                      });
                                    },
                                    child: Icon(Icons.check_circle, color: Colors.white,),
                                  )
                                )

                              )
                            ],
                          ),
                      )
                     : Container(
                        width: screenWidth,
                        height: 55,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Material(
                          elevation: 5,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: CARD,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: CARD),
                              child: ListTile(
                                title: Text(
                                  phone_no.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                  )
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showPhone = true;
                                    });
                                  },
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                                leading:
                                    Icon(Icons.phone, color: Colors.white),
                              )),
                        )),

                    SizedBox(height: 25),

                    (cName || cAddress || cUsername || cPassword || cEmail || cPhone) ? 
                    Material(
                      color: Colors.yellow[800],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        onTap: (){
                          //updateAttendee();
                        },
                        child: Container(
                          height: 60,
                          width: screenWidth - 40,
                          child: Center(
                            child: Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    : Container()
                  ],
                ),
              ),
            ),
    ));
  }

  // Future<void> updateAttendee() async{

  // }

  // Future<void> _pickImage(ImageSource source) async {
  //   Navigator.of(context).pop();
  //   File selected = await ImagePicker.pickImage(source: source);
  //   setState(() {
  //     image = selected;
  //   });
  //   print(image.toString());
  // }

  // Future<void> addEvent() async {
  //   if (widget.e == null) {
  //     print("e is null");
  //     if (_AttendeeEditProfileKey.currentState.validate()) {
  //       setState(() {
  //         loading = true;
  //       });
  //       final String picture1 =
  //           "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
  //       FirebaseStorage storage = FirebaseStorage.instance;
  //       StorageUploadTask task1 = storage.ref().child(picture1).putFile(image);
  //       task1.onComplete.then((snapshot) async {
  //         String url = await snapshot.ref.getDownloadURL();
  //         setState(() {
  //           imageUrl = url;
  //         });
  //         print(url);
  //         print("valid");
  //         var data = {
  //           "title": title.text,
  //           "category": category,
  //           "description": desc.text,
  //           "start_date": startDate.toString(),
  //           "end_date": endDate.toString(),
  //           "image": imageUrl,
  //           "location": location.text,
  //           "speciality": speciality.text,
  //           "max_count": int.parse(maxCount.text),
  //           "entry_amount": int.parse(entryamount.text),
  //           "org_id": widget.org_id
  //         };
  //         print(data);
  //         Map<String, String> headers = {
  //           "Content-type": "application/json",
  //           "Accept": "application/json",
  //           "charset": "utf-8"
  //         };
  //         var response = await http.post(
  //             'https://rpk-happenings.herokuapp.com/event',
  //             headers: headers,
  //             body: json.encode(data));
  //         if (response.statusCode == 200) {
  //           Fluttertoast.showToast(
  //               msg: "Event posted successfully.",
  //               toastLength: Toast.LENGTH_LONG,
  //               gravity: ToastGravity.BOTTOM);
  //           setState(() {
  //             loading = false;
  //           });
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => Home(
  //                         type: ORGANISATION,
  //                       )));
  //         } else {
  //           print("not");
  //           Fluttertoast.showToast(
  //               msg: "Please try again...",
  //               toastLength: Toast.LENGTH_LONG,
  //               gravity: ToastGravity.BOTTOM);
  //         }
  //       }).catchError((e) {
  //         Fluttertoast.showToast(
  //             msg: e.toString(),
  //             toastLength: Toast.LENGTH_LONG,
  //             gravity: ToastGravity.BOTTOM);
  //       });
  //     } else if (image == null) {
  //       Fluttertoast.showToast(
  //           msg: "Please upload an image for your event...",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM);
  //       return;
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Please enter the rest of the details ...",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM);
  //       return;
  //     }
  //   } else {
  //     if (_AttendeeEditProfileKey.currentState.validate()) {
  //       setState(() {
  //         loading = true;
  //       });
  //       print("e is not null");
  //       if (image != null) {
  //         final String picture1 =
  //             "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
  //         FirebaseStorage storage = FirebaseStorage.instance;
  //         StorageUploadTask task1 =
  //             storage.ref().child(picture1).putFile(image);
  //         task1.onComplete.then((snapshot) async {
  //           String url = await snapshot.ref.getDownloadURL();
  //           setState(() {
  //             imageUrl = url;
  //             widget.e.imageUrl = url;
  //           });
  //           print(url);
  //           api();
  //         }).catchError((e) {
  //           Fluttertoast.showToast(
  //               msg: e.toString(),
  //               toastLength: Toast.LENGTH_LONG,
  //               gravity: ToastGravity.BOTTOM);
  //         });
  //       } else {
  //         api();
  //       }
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Please enter the rest of the details ...",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM);
  //       return;
  //     }
  //   }
  // }

  // void api() async {
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "Accept": "application/json",
  //     "charset": "utf-8"
  //   };
  //   widget.e.title = title.text;
  //   widget.e.description = desc.text;
  //   widget.e.location = location.text;
  //   widget.e.speciality = speciality.text;
  //   widget.e.entryamount = int.parse(entryamount.text);
  //   widget.e.startDate = startDate;
  //   widget.e.endDate = endDate;
  //   widget.e.category = category;
  //   widget.e.maxCount = int.parse(maxCount.text);
  //   print(widget.e.category);
  //   print(widget.e.description);
  //   print(widget.e.endDate);
  //   print(widget.e.speciality);
  //   print(widget.e.startDate);
  //   print(widget.e.id);
  //   print(widget.e.imageUrl);
  //   print(widget.e.location);
  //   print(widget.e.title);
  //   print(widget.e.maxCount);
  //   print(widget.e.currentCount);
  //   var data = widget.e.toJson();
  //   var id = data['id'];
  //   data.remove('id');
  //   data.putIfAbsent('event_id', () => id);
  //   var response = await http.put('https://rpk-happenings.herokuapp.com/event',
  //       headers: headers, body: json.encode(data));
  //   if (response.statusCode == 200) {
  //     Fluttertoast.showToast(
  //         msg: "Event updated successfully.",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM);
  //     setState(() {
  //       loading = false;
  //     });
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => Home(
  //                   type: ORGANISATION,
  //                 )));
  //   } else {
  //     print("not");
  //     Fluttertoast.showToast(
  //         msg: "Please try again...",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM);
  //   }
  // }
}
