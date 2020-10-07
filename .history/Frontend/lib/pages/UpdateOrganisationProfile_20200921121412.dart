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
    email = widget.organisation.email;
    phone = widget.organisation.phone_no;
    details = widget.organisation.details;
    image = widget.organisation.imageUrl;
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
                onChanged: (value) => name = value,
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
                initialValue: address,
                maxLines: 1,
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

          Material(
            color: Colors.yellow[800],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Update Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}