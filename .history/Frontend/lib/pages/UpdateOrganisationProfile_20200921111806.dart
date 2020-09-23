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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back, color: Colors.yellow[800],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}