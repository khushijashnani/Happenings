import 'package:flutter/material.dart';
import 'package:uvento/models/organisation.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:uvento/constants.dart';

class OrganisationProfile extends StatefulWidget {

  Organisation organisation;
  OrganisationProfile({this.organisation});

  @override
  _OrganisationProfileState createState() => _OrganisationProfileState();
}

class _OrganisationProfileState extends State<OrganisationProfile> {
  double screenWidth, screenHeight;

  Widget profileImage() {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.3,
      child: Stack(
        children: [
          Image.network(
            widget.organisation.imageUrl,
            width: screenWidth,
            height: screenHeight * 0.3,
            fit: BoxFit.fill,
          ),
          Container(
            width: screenWidth,
            height: screenHeight * 0.3,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.1, sigmaY: 5.1),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: Image.network(
              widget.organisation.imageUrl,
              width: screenWidth*0.7,
              height: screenHeight * 0.21,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget nameAndAddress() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: BACKGROUND,
        elevation: 5,
        shadowColor: Colors.black,
        child: Column(
          children: [
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: AutoSizeText(
                widget.organisation.name,
                style: TextStyle(
                  color: YELLOW,
                  fontSize: 20
                ),
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      children: [
        
        profileImage(),
        SizedBox(height: 20,),
        nameAndAddress()
      ],
    );
  }
}