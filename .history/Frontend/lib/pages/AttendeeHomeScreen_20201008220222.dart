import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uvento/data/data.dart';
import 'package:uvento/models/attendee.dart';
import 'package:uvento/models/date_model.dart';
import 'package:uvento/models/event.dart';
import 'package:uvento/models/event_type_model.dart';
import 'package:uvento/models/events_model.dart';
import 'package:uvento/constants.dart';
import 'package:flip_card/flip_card.dart';
import 'package:http/http.dart' as http;
import 'package:uvento/pages/SearchEventList.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uvento/pages/EventDetailPageOrganiser.dart';

class AttendeeHomeScreen extends StatefulWidget {
  String name;
  Attendee attendee;
  AttendeeHomeScreen({Key key, this.name, this.attendee}) : super(key: key);

  @override
  _AttendeeHomeScreenState createState() => _AttendeeHomeScreenState();
}

class _AttendeeHomeScreenState extends State<AttendeeHomeScreen> {
  List<DateModel> dates = new List<DateModel>();
  List<EventTypeModel> eventsType = new List();
  List<EventsModel> events = new List<EventsModel>();
  String todayDateIs = "12";
  double screenWidth, screenHeight;
  List<Event> allEvents = [];

  Future<void> getevents() async {
    var response =
        await http.get('https://rpk-happenings.herokuapp.com/events');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        for (Map l in data) {
          allEvents.add(Event.fromMap(l));
        }
       // print(allEvents[0].toJson());
      });
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.name);
    getevents();
    dates = getDates();
    eventsType = getEventTypes();
    events = getEvents();
  }

  Widget flipcard(Event e) {
    String startdate = DateFormat('d MMM, yyyy').format(e.startDate);
    String enddate = DateFormat('d MMM, yyyy').format(e.endDate);
    int date = e.startDate.day;

    return Material(
        color: CARD,
        elevation: 5,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: CARD),
            width: screenWidth / 2 - 25,
            height: 250,
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL, // default
              front: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: CARD),
                  height: 250,
                  width: screenWidth / 2 - 25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.network(e.imageUrl,
                        width: screenWidth / 2 - 25,
                        height: 250,
                        fit: BoxFit.fill),
                  )),
              back: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: CARD),
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth / 2 - 38,
                              child: AutoSizeText(e.title,
                                  minFontSize: 18,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: screenWidth / 2 - 38,
                              child: AutoSizeText(
                                  startdate == enddate
                                      ? startdate
                                      : date.toString() + " - " + startdate,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              FaIcon(FontAwesomeIcons.locationArrow,
                                  color: Colors.white, size: 15),
                              //Icon(Icons.location_on, color: Colors.white, size : 20),
                              SizedBox(width: 5),
                              Container(
                                width: screenWidth / 2 - 68,
                                child: AutoSizeText(e.location,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal)),
                              )
                            ]),
                            SizedBox(height: 10),
                            Row(children: [
                              SizedBox(
                                width: 3,
                              ),
                              FaIcon(FontAwesomeIcons.rupeeSign,
                                  color: Colors.white, size: 15),
                              SizedBox(width: 5),
                              Container(
                                width: screenWidth / 2 - 68,
                                child: AutoSizeText(e.entryamount.toString() + " /-",
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal)),
                              )
                            ]),
                            SizedBox(height: 10),
                            Material(
                                elevation: 5,
                                shadowColor: Colors.black,
                                //color: Colors.yellow[800],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailPageOrganiser(
                                            event: e,
                                            type: ATTENDEE,
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    width: screenWidth * 0.3,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: CARD,
                                      border:
                                          Border.all(color: Colors.yellow[800]),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Center(
                                        child: Text("View More",
                                            style: TextStyle(
                                                color: Colors.yellow[800],
                                                fontWeight: FontWeight.bold))),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  )),
            )));
  }

  Widget popularEventCard(int index) {
    Event event1 = allEvents[index];
    Event event2 = allEvents[allEvents.length - index - 1];
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          flipcard(event1),
          SizedBox(width: 10),
          event1.title != event2.title ? flipcard(event2) : Container()
        ]));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xff102733)),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/logo.png",
                          height: 28,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Happenings",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "",
                              style: TextStyle(
                                  color: Color(0xffFCCD00),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Hello, " + widget.name.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Let's explore what’s happening nearby",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                widget.attendee.imageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.fill,
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Dates
                    // Container(
                    //   height: 60,
                    //   child: ListView.builder(
                    //       itemCount: dates.length,
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemBuilder: (context, index) {
                    //         return DateTile(
                    //           weekDay: dates[index].weekDay,
                    //           date: dates[index].date,
                    //           isSelected: todayDateIs == dates[index].date,
                    //         );
                    //       }),
                    // ),

                    /// Events
                    // SizedBox(
                    //   height: 16,
                    // ),
                    Text(
                      "All Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: eventsType.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return EventTile(
                              imgAssetPath: eventsType[index].imgAssetPath,
                              eventType: eventsType[index].eventType,
                            );
                          }),
                    ),

                    /// Popular Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Popular Events",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    ListView.builder(
                      itemCount: (allEvents.length / 2).toInt(),
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return popularEventCard(index);
                      },
                    ),

                    // Container(
                    //   width : 200,
                    //   height : 300,
                    //   child : FlipCard(
                    //     direction: FlipDirection.HORIZONTAL, // default
                    //     front: Container(
                    //       color: CARD,
                    //       height: 300,
                    //           child: Text('Front'),
                    //       ),
                    //       back: Container(
                    //         color : CARD,
                    //         height: 300,
                    //           child: Text('Back'),
                    //       ),
                    //   )
                    // )

                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  final String weekDay;
  final String date;
  final bool isSelected;
  DateTile({this.weekDay, this.date, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isSelected ? Color(0xffFCCD00) : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  final String imgAssetPath;
  final String eventType;
  EventTile({this.imgAssetPath, this.eventType});

  Future<List<Event>> getCatEvents(category) async {
    List<Event> list = [];
    var response =
        await http.get('https://rpk-happenings.herokuapp.com/events');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (Map l in data) {
        if (l['category'] == category) {
          list.add(Event.fromMap(l));
        }
      }
      // print(list[0].toJson());
      return list;
    } else {
      print(response.body);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        List<Event> catEvents = [];
        catEvents = await getCatEvents(eventType);
        print(catEvents);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchEventList(
                      list: catEvents,
                    )));
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
            color: Color(0xff29404E), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imgAssetPath,
              height: 27,
              color: Colors.yellow[800],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              eventType,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  final String desc;
  final String date;
  final String address;
  final String imgeAssetPath;

  /// later can be changed with imgUrl
  PopularEventTile({this.address, this.date, this.imgeAssetPath, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: CARD,
          //color: Color(0xff29404E),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    desc,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/calender.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        date,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/location.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        address,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Image.network(
                imgeAssetPath,
                height: 100,
                width: 120,
                fit: BoxFit.cover,
              )),
        ],
      ),
    );
  }
}
