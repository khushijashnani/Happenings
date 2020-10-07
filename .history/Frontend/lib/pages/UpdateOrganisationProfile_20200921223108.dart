import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/home.dart';
import 'package:uvento/models/organisation.dart';
import 'package:uvento/constants.dart';
import 'package:http/http.dart' as http;

class UpdateOrganisationProfile extends StatefulWidget {

  Organisation organisation;
  int index;
  UpdateOrganisationProfile({this.organisation, this.index});

  @override
  _UpdateOrganisationProfileState createState() => _UpdateOrganisationProfileState();
}

class _UpdateOrganisationProfileState extends State<UpdateOrganisationProfile> {

  double screenWidth, screenHeight;
  String username = "", password = "", address = "", email = "", details = "", phone = "", name = "";
  String image = "";
  final String type = ORGANISATION;
  final _signupFormKey = GlobalKey<FormState>();
  final _scaffoldKey1 = GlobalKey<ScaffoldState>();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = widget.organisation.username;
    password = widget.organisation.password;
    address = widget.organisation.address;
    email = widget.organisation.email;
    phone = widget.organisation.phone_no;
    details = widget.organisation.details;
    image = widget.organisation.imageUrl;
    name = widget.organisation.name;
  }

  Future<void> updateProfile() async {
    if (_signupFormKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      var data = {
        'name': name,
        'username': username,
        'password': password,
        'type': ORGANISATION,
        'address': address,
        'email_id': email,
        'phone': phone,
        'image': image,
        'details': details
      };

      print(data);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Accept": "application/json",
        "charset": "utf-8",
        "Authorization": sharedPreferences.getString("token")
      };
      
      var response2 = await http.put(
        'https://rpk-happenings.herokuapp.com/${type}/' +
            sharedPreferences.getString("id"),
        headers: headers,
        body: json.encode(data)
      );

      if (response2.statusCode == 200) {
        print(response2.body);
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
          msg: "Updated Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(type: ORGANISATION,),), (route) => false);

      } else {

        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
          msg: "Update failed...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(type: ORGANISATION,),), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey1,
      backgroundColor: BACKGROUND,
      body: loading ? 
      Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Updating your details...",
                style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator()
          ],
        ),
      ) :
      ListView(
        children: [
          SizedBox(height: screenHeight * 0.05),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios, color: Colors.yellow[800],
                  ),
                ),
              ),
              Text(
                widget.organisation.name,
                style: TextStyle(
                  color: Colors.yellow[800],
                  fontStyle: FontStyle.italic,
                  fontSize: 25
                ),
              ),
              Container(width: 20,)
            ],
          ),
          SizedBox(height: screenHeight * 0.05,),

          Form(
            key: _signupFormKey,
            child: Column(
              children: [
                widget.index == 0 ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Container(
                    width: screenWidth - 60,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(25.0),
                      color: CARD,
                    ),
                    child: TextFormField(
                      initialValue: name,
                      maxLines: 1,
                      onChanged: (value) => name = value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person,
                            color: Colors.grey),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(color: CARD),
                        ),
                        labelStyle: TextStyle(color: Colors.yellow[800]),
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                ) : Container(),

                widget.index == 0 ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    width: screenWidth - 60,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(25.0),
                      color: CARD,
                    ),
                    child: TextFormField(
                      initialValue: address,
                      maxLines: 3,
                      onChanged: (value) => address = value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on,
                            color: Colors.grey),
                        border: new OutlineInputBorder(
                          borderRadius:
                              new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.yellow[800]),
                        hintText: "Address",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                ) : Container(),

                widget.index == 1 ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    width: screenWidth - 60,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(25.0),
                      color: CARD,
                    ),
                    child: TextFormField(
                      initialValue: details,
                      maxLines: 10,
                      onChanged: (value) => details = value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.content_paste,
                            color: Colors.grey),
                        border: new OutlineInputBorder(
                          borderRadius:
                              new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.yellow[800]),
                        hintText: "Details",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                ) : Container(),

                widget.index == 2 ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    width: screenWidth - 60,
                    child: TextFormField(
                      initialValue: phone,
                      maxLines: 1,
                      onChanged: (value) => phone = value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone,
                            color: Colors.grey),
                        border: new OutlineInputBorder(
                          borderRadius:
                              new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.yellow[800]),
                        hintText: "Phone",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                ) : Container(),

                widget.index == 2 ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    width: screenWidth - 60,
                    child: TextFormField(
                      initialValue: email,
                      maxLines: 1,
                      onChanged: (value) => email = value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email,
                            color: Colors.grey),
                        border: new OutlineInputBorder(
                          borderRadius:
                              new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.yellow[800]),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                ) : Container(),

                widget.index == 3 ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    width: screenWidth - 60,
                    child: TextFormField(
                      initialValue: username,
                      maxLines: 1,
                      onChanged: (value) => username = value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.contacts,
                            color: Colors.grey),
                        border: new OutlineInputBorder(
                          borderRadius:
                              new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.yellow[800]),
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                ) : Container(),

                widget.index == 3 ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Container(
                    width: screenWidth - 60,
                    child: TextFormField(
                      initialValue: password,
                      maxLines: 1,
                      onChanged: (value) => password= value,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock,
                            color: Colors.grey),
                        border: new OutlineInputBorder(
                          borderRadius:
                              new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.yellow[800]),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  ),
                ) : Container(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.yellow[800],
                    child: InkWell(
                      onTap: (){
                        updateProfile();
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}