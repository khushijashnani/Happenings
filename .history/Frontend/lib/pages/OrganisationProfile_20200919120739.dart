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
        Stack(
          child: Image.network(
            widget.organisation.imageUrl,
            width: screenWidth * 0.9,
            height: screenHeight * 0.3,
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }
}