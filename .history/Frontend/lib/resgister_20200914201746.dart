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
  void initState() {
    usernameController = TextEditingController();
    passController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}