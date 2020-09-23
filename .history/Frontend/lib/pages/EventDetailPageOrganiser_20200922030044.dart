import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uvento/models/event.dart';
import 'package:uvento/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CARD,
        elevation: 5,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.date_range, color: Colors.white,),
                  SizedBox(width: 6,),
                  Text(
                    dateMapper[startWeek] + ", " + startdate + " - " + dateMapper[endWeek] + ", " + enddate,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              SizedBox(height: 0,),
              Row(
                children: [
                  Icon(Icons.access_time, color: CARD,),
                  SizedBox(width: 6,),
                  Text(
                    "10 am - 9 pm",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget address() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30,5),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CARD,
        elevation: 5,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white),
                  SizedBox(width: 6,),
                  Text(
                    widget.event.location,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: CARD),
                  SizedBox(width: 6,),
                  InkWell(
                    onTap: (){},
                    child: Text(
                      "Get location",
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget ticketPrice() {

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30,5),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CARD,
        elevation: 5,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  //Icon(Icons.attach_money, color: Colors.white),
                  FaIcon(FontAwesomeIcons.rupeeSign, color: Colors.white),
                  SizedBox(width: 8,),
                  Text(
                    widget.event.location,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                      dateAndTime(),
                      address(),
                      ticketPrice()
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