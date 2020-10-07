import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uvento/models/event.dart';
import 'package:uvento/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EventDetailPageOrganiser extends StatefulWidget {

  Event event;
  EventDetailPageOrganiser({this.event});

  @override
  _EventDetailPageOrganiserState createState() => _EventDetailPageOrganiserState();
}

class _EventDetailPageOrganiserState extends State<EventDetailPageOrganiser> {

  double screenWidth, screenHeight;

  Widget eventImage() {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.3,
      child: Stack(
        children: [
          Image.network(
            widget.event.imageUrl,
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
                      widget.event.imageUrl,
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

  Widget eventName() {
    return Container(
      width: screenWidth,

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
            eventImage(),
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
                      SizedBox(height: 20,),
                      eventName()
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