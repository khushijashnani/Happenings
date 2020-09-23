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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND,
    );
  }
}