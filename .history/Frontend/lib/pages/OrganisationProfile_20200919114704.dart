import 'package:flutter/material.dart';
import 'package:uvento/models/organisation.dart';

class OrganisationProfile extends StatefulWidget {

  Organisation organisation;
  OrganisationProfile({this.organisation});

  @override
  _OrganisationProfileState createState() => _OrganisationProfileState();
}

class _OrganisationProfileState extends State<OrganisationProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.organisation.name)
    );
  }
}