import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uvento/home.dart';

import 'registerone.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController;
  TextEditingController passController;
  bool passvis = true;
  final _loginFormKey = GlobalKey<FormState>();
  final _scaffoldKey1 = GlobalKey<ScaffoldState>();
  String name = '';
  String type = 'ATTENDEE';

  @override
  void initState() {
    usernameController = TextEditingController();
    passController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Stack(children: <Widget>[
      Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xff102733)),
      ),
      Container(
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
                key: _loginFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 50,
                      // ),
                      Container(
                        height: 120,
                        child: Row(
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
                              padding: const EdgeInsets.only(top: 30,right: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "UVE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    "NTO",
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
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(50, 0, 0, 30),
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: ConstrainedBox(
                        constraints: BoxConstraints.tight(Size(300, 80)),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your username';
                            }
                            // if (!RegExp(r"^(?=.*\d)[\d]{10}$")
                            //     .hasMatch(phoneController.text)) {
                            //   return "Only 10 digits allowed\nDon't Include Country Code";
                            // }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          controller: usernameController,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              labelStyle: TextStyle(color: Colors.yellow[600]),
                              icon: Icon(Icons.person, color: Colors.white),
                              hintText: "Username",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tight(Size(300, 80)),
                          child: TextFormField(
                            obscureText: passvis,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              // if (!RegExp(
                              //         r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                              //     .hasMatch(passController.text)) {
                              //   return "Please include atleast 1 lowercase, 1 uppercase,\n1 digit and 1 special character";
                              // }
                              return null;
                            },
                            controller: passController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passvis = !passvis;
                                      });
                                    },
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 2, 0),
                                        child: Icon(
                                          passvis
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white,
                                        ))),
                                //labelText: "Password",
                                icon: Icon(Icons.lock_outline,
                                    color: Colors.white),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                labelStyle:
                                    TextStyle(color: Colors.yellow[600]),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ),

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
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // if (passController.text.isEmpty ||
                            //     usernameController.text.isEmpty) {
                            //   _scaffoldKey1.currentState.showSnackBar(SnackBar(
                            //     content: Text('Fields Cannot be Empty'),
                            //     duration: Duration(seconds: 2),
                            //     backgroundColor: Colors.cyan,
                            //   ));
                            // }
                            // if (!RegExp(r"^(?=.*\d)[\d]{10}$")
                            //     .hasMatch(usernameController.text)) {
                            //   _scaffoldKey1.currentState.showSnackBar(SnackBar(
                            //     content: Text(
                            //         'Enter a Valid Phone Number\nDo not include Country Code i.e +91'),
                            //     duration: Duration(seconds: 2),
                            //     backgroundColor: Colors.cyan,
                            //   ));
                            // }
                            if (_loginFormKey.currentState.validate()) {
                              login(
                                  usernameController.text, passController.text);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black87,
                            ),
                            child: Center(
                              child: Text("Log in",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "First time here ?  ",
                            style:
                                TextStyle(color: Colors.white60, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPart1()));
                            },
                            child: Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )
                        ],
                      )
                    ])),
          ))
    ])));
  }

  login(username, pass) async {
    var data = {'username': username, 'password': pass, 'type': "ATTENDEE"};
    var jsonData;
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "charset": "utf-8"
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post('https://rpk-happenings.herokuapp.com/login',
        headers: headers, body: json.encode(data));
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        print("id=" + jsonData['id'].toString());
        sharedPreferences.setString("id", jsonData['id'].toString());
        sharedPreferences.setString(
            "token", "Bearer " + jsonData['access_token']);
      });

      var response2 = await http.get(
          'https://rpk-happenings.herokuapp.com/ATTENDEE/' +
              sharedPreferences.getString("id"),
          headers: {"Authorization": sharedPreferences.getString("token")});
      if (response2.statusCode == 200) {
        var userDetails = json.decode(response2.body)['user_details'];
        print(userDetails['name'].runtimeType);
        setState(() {
          name = userDetails['name'];
        });
        print(name);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(
                    name: name,
                  )),
        );
      } else {
        print(response.body);
      }
    } else {
      print(response.body);
    }
  }
}
