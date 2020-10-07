import 'package:flutter/material.dart';
import 'package:uvento/models/organisation.dart';

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
        Image.network(
          widget.organisation.imageUrl,
          width: screenWidth * 0.9,
          height: screenHeight * 0.23,
          fit: BoxFit.fill,
        )
      ],
    );
  }
}