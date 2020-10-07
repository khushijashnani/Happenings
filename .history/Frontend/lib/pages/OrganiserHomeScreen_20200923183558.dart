import 'package:flutter/material.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/eventform.dart';
import 'package:uvento/models/organisation.dart';

class OrganiserHomeScreen extends StatefulWidget {

  Organisation organisation;
  OrganiserHomeScreen({this.organisation});

  @override
  _OrganiserHomeScreenState createState() => _OrganiserHomeScreenState();
}

class _OrganiserHomeScreenState extends State<OrganiserHomeScreen> {

  double screenHeight, screenWidth;

  Widget organiserCard(double bL, double bR, double tL, double tR, String top, String bottom, String alignment) {
    return Material(
      color: CARD,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(tL),
        topRight: Radius.circular(tR),
        bottomLeft: Radius.circular(bL),
        bottomRight: Radius.circular(bR),
      ),
      elevation: 5,
      shadowColor: Colors.black,
      child: Container(
        alignment: alignment == "tL" ? Alignment.topLeft : alignment == "tR" ?  Alignment.topRight : alignment == "bL" ? Alignment.bottomLeft : Alignment.bottomRight,
        width: screenWidth * 0.4,
        height: 100,
        decoration: BoxDecoration(
          color: CARD,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tL),
            topRight: Radius.circular(tR),
            bottomLeft: Radius.circular(bL),
            bottomRight: Radius.circular(bR),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                top,
                style: TextStyle(
                  color: YELLOW, fontSize: 18
                ),
              ),
              Text(
                bottom,
                style: TextStyle(
                  color: Colors.white, fontSize: 18
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: BACKGROUND
              ),
            ),

            Container(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, 
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Image.asset(
                                "assets/logo.png",
                                height: 25,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2, top: 20),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "HAPPEN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    "INGS",
                                    style: TextStyle(
                                        color: Color(0xffFFA700),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                          ]
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top : 20.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EventForm(org_id: widget.organisation.id,)));
                            },
                            child: Icon(
                              Icons.add_circle, color: YELLOW,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                organiserCard(10, 80, 10, 10, "25", "Events", "tL"),
                                SizedBox(height: 20,),
                                organiserCard(10, 10, 10, 80, "500 +", "Attendees", "tR"),
                                // Material(
                                //   color: CARD,
                                //   borderRadius: BorderRadius.only(
                                //     topLeft: Radius.circular(10),
                                //     topRight: Radius.circular(80),
                                //     bottomLeft: Radius.circular(10),
                                //     bottomRight: Radius.circular(10),
                                //   ),
                                //   elevation: 5,
                                //   shadowColor: Colors.black,
                                //   child: Container(
                                //     width: screenWidth * 0.4,
                                //     height: 100,
                                //     decoration: BoxDecoration(
                                //       color: CARD,
                                //       borderRadius: BorderRadius.only(
                                //         topLeft: Radius.circular(10),
                                //         topRight: Radius.circular(80),
                                //         bottomLeft: Radius.circular(10),
                                //         bottomRight: Radius.circular(10),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),

                            Column(
                              children: [
                                Material(
                                  color: CARD,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(80),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  child: Container(
                                    width: screenWidth * 0.4,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: CARD,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(80),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Material(
                                  color: CARD,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(80),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  child: Container(
                                    width: screenWidth * 0.4,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: CARD,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(80),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}