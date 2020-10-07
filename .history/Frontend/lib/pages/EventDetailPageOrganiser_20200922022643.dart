import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uvento/models/event.dart';
import 'package:uvento/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

class EventDetailPageOrganiser extends StatefulWidget {

  Event event;
  EventDetailPageOrganiser({this.event});

  @override
  _EventDetailPageOrganiserState createState() => _EventDetailPageOrganiserState();
}

class _EventDetailPageOrganiserState extends State<EventDetailPageOrganiser> {

  double screenWidth, screenHeight;
  final dateMapper = {
    1 : 'Mon', 2 : 'Tues', 3 : 'Wed', 4 : 'Thurs', 5 : 'Fri', 6 : 'Sat', 7 : 'Sun'
  };

  Widget eventImage() {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.35,
      child: Stack(
        children: [
          Image.network(
            widget.event.imageUrl,
            width: screenWidth,
            height: screenHeight * 0.35,
            fit: BoxFit.fill,
          ),
          Container(
            width: screenWidth,
            height: screenHeight * 0.35,
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
                      height: screenHeight * 0.24,
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10,20,10),
        child: AutoSizeText(
          widget.event.title,
          style: TextStyle(
            color: Colors.yellow[800], fontWeight: FontWeight.w600, fontSize: 25
          ),
          maxLines: 1,
        ),
      ),
    );
  }

  Widget dateAndTime() {

    String startdate = DateFormat('d MMM, yyyy').format(widget.event.startDate);
    String enddate = DateFormat('d MMM, yyyy').format(widget.event.endDate);
    int startWeek = widget.event.startDate.weekday;
    int endWeek = widget.event.endDate.weekday;

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30,5),
      child: Text(
        dateMapper[startWeek] + ", " + startdate + " - " + dateMapper[endWeek] + ", " + enddate,
        style: TextStyle(
          color: Colors.white
        ),
      )
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
                SizedBox(height: screenHeight * 0.29,),
                Material(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: BACKGROUND,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      eventName(),
                      dateAndTime()
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