import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController usernameController;
  TextEditingController passController;
  bool passvis = true;
  final _loginFormKey = GlobalKey<FormState>();
  final _scaffoldKey1 = GlobalKey<ScaffoldState>();
  String name = '';
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}