import 'package:flutter/material.dart';
import 'package:uvento/models/organisation.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:uvento/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.03,),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.network(
                      widget.organisation.imageUrl,
                      width: screenWidth*0.7,
                      height: screenHeight * 0.19,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ],
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 5),
                  child: Container(
                    width: screenWidth*0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: AutoSizeText(
                      widget.organisation.name,
                      style: TextStyle(
                        color: YELLOW,
                        fontSize: 25
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 5),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 0, 0,0),
                        child: Container(
                          width: screenWidth*0.7,
                          child: Text(
                            widget.organisation.address,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,10,0),
              child: InkWell(
                onTap: (){},
                child: Icon(Icons.arrow_forward_ios, color: YELLOW)),
            ),
          ],
        ),
      ),
    );
  }

  Widget details() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: BACKGROUND,
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screenWidth * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.organisation.details,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,10,0),
              child: InkWell(
                onTap: (){},
                child: Icon(Icons.arrow_forward_ios, color: YELLOW,)
              ),
            )
          ],
        ),
        
      ),
    );
  }

  Widget contactDetails() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: BACKGROUND,
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AutoSizeText(
                      "+91 " + widget.organisation.phone_no,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AutoSizeText(
                      widget.organisation.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,10,0),
              child: InkWell(
                onTap: (){},
                child: Icon(Icons.arrow_forward_ios, color: YELLOW)
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
        
        Stack(
          children: [
            profileImage(),
            Column(
              children: [
                SizedBox(height: screenHeight * 0.25,),
                Material(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: BACKGROUND,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.person_pin),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Personal Details : ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      nameAndAddress(),
                      details(),
                      contactDetails()
                    ],
                  )
                ),
              ],
            ),
            
          ],
        ),
        
      ],
    );
  }
}