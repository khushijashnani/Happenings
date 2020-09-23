import 'package:flutter/material.dart';
import 'package:uvento/models/organisation.dart';
import 'package:uvento/constants.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = widget.organisation.username;
    password = widget.organisation.password;
    address = widget.organisation.address;
    email = widget.organisation.username;
    phone = widget.organisation.username;
    details = widget.organisation.username;
    image = widget.organisation.username;
    name = widget.organisation.name;
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: BACKGROUND,
      body: ListView(
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

          widget.index == 0 ? Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
              width: screenWidth - 60,
              child: TextFormField(
                initialValue: name,
                maxLines: 1,
                onChanged: (value) => username = value,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person,
                      color: Colors.grey),
                  border: new OutlineInputBorder(
                    borderRadius:
                        new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  labelStyle:
                      TextStyle(color: Colors.yellow[800]),
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
              child: TextFormField(
                initialValue: name,
                maxLines: 1,
                onChanged: (value) => address = value,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_pin,
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

          widget.index == 0 ? Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              width: screenWidth - 60,
              child: TextFormField(
                initialValue: details,
                maxLines: 3,
                onChanged: (value) => details = value,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_pin,
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
        ],
      ),
    );
  }
}