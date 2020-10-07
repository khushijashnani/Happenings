import 'package:flutter/material.dart';
import 'package:uvento/models/organisation.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';

class OrganisationProfile extends StatefulWidget {

  Organisation organisation;
  OrganisationProfile({this.organisation});

  @override
  _OrganisationProfileState createState() => _OrganisationProfileState();
}

class _OrganisationProfileState extends State<OrganisationProfile> {
  double screenWidth, screenHeight;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ListView(
      children: [
        Stack(
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
                  color: Colors.black.withOpacity(0.0),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}