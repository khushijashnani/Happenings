import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/AttendeeList.dart';
import 'package:uvento/eventform.dart';
import 'package:uvento/home.dart';
import 'package:uvento/models/event.dart';
import 'package:uvento/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';

class EventDetailPageOrganiser extends StatefulWidget {
  Event event;
  String type;
  EventDetailPageOrganiser({this.event, this.type});

  @override
  _EventDetailPageOrganiserState createState() =>
      _EventDetailPageOrganiserState();
}

class _EventDetailPageOrganiserState extends State<EventDetailPageOrganiser> {
  List<int> favs = [];
  List<int> registeredevents = [];
  List reviews = [];
  TextEditingController content;
  int rating = 1;
  String org_name = "Happenings";
  List<Event> recommended_events = [];
  int attendee_id = 0;

  getUserDetails() async {
    setState(() {
      loading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int id = int.parse(sharedPreferences.getString("id"));

    if (widget.type == ATTENDEE) {
      var fav = await http.get(
          'https://rpk-happenings.herokuapp.com/${widget.type}/$id/favs',
          headers: {"Authorization": sharedPreferences.getString("token")});
      if (fav.statusCode == 200) {
        var data = json.decode(fav.body);
        for (Map f in data) {
          print(f);
          favs.add(int.parse(f['event_id']));
        }
        var registers = await http.get(
            'https://rpk-happenings.herokuapp.com/${widget.type}/$id/registeredevents',
            headers: {"Authorization": sharedPreferences.getString("token")});
        if (registers.statusCode == 200) {
          data = json.decode(registers.body);
          for (Map f in data) {
            print(f);
            registeredevents.add(int.parse(f['id']));
          }
          print(registeredevents);
          print(favs);
          setState(() {
            registered = registeredevents.contains(int.parse(widget.event.id));
            favourite = favs.contains(int.parse(widget.event.id));
          });
          print(registered);
          int event_id = int.parse(widget.event.id);
          var response = await http.get(
              'https://rpk-happenings.herokuapp.com/recommedations/content_based/${attendee_id}/${event_id}');
          if (response.statusCode == 200) {
            var data = json.decode(response.body);
            print(data);
            setState(() {
              for (Map l in data) {
                recommended_events.add(Event.fromMap(l));
              }
              print(recommended_events);
            });
          } else {
            print(response.body);
          }
        } else {
          Fluttertoast.showToast(msg: registers.body);
        }
      } else {
        Fluttertoast.showToast(msg: fav.body);
      }
    }
    if (widget.event.endDate.difference(DateTime.now()).inMicroseconds > 0) {
      DateTime d = DateTime.now();
      diff = widget.event.startDate.difference(d);
    } else {
      diff = null;
    }

    var headers = {
      "Authorization": sharedPreferences.getString("token"),
      HttpHeaders.contentTypeHeader: "application/json",
    };
    int event_id = int.parse(widget.event.id);
    final response = await http.get(
        "http://rpk-happenings.herokuapp.com/event/${event_id}",
        headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        reviews = json.decode(response.body)["reviews"];
        print(reviews);
        loading = false;
      });
    } else {
      Fluttertoast.showToast(msg: response.body);
    }
  }

  bool registered = false;
  bool favourite = false;
  Duration diff;
  bool loading = false;

  Future<void> getOrgName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var headers = {
      "Authorization": sharedPreferences.getString("token"),
      HttpHeaders.contentTypeHeader: "application/json",
    };
    int org_id = int.parse(widget.event.organiser_id);
    final response = await http.get(
        "http://rpk-happenings.herokuapp.com/org_name/${org_id}",
        headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        org_name = json.decode(response.body)["org_name"];
        print(org_name);
      });
    } else {
      Fluttertoast.showToast(msg: response.body);
    }
  }

  // Future<void> getRecommendedEvents() async {
    
    
  // }

  @override
  void initState() {
    getUserDetails();
    getOrgName();
    //getRecommendedEvents();
    content = TextEditingController();
    super.initState();
  }

  Widget reviewsTab() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Container(
              width: screenWidth - 60,
              child: Text(
                "Reviews",
                style: GoogleFonts.raleway(
                    color: Colors.yellow[800],
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return reviewCards(index);
              }),
        ]));
  }

  Widget reviewCards(int index) {
    String startdate = DateFormat('d MMM, yyyy').format(widget.event.startDate);
    String enddate = DateFormat('d MMM, yyyy').format(widget.event.endDate);
    int date = widget.event.startDate.day;
    int rating = int.parse(reviews[index]["rating"]);

    return Padding(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Material(
            color: CARD,
            elevation: 5,
            shadowColor: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
                //height: 50,
                decoration: BoxDecoration(
                  color: CARD,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Container(
                            width: screenWidth * 0.8,
                            child: AutoSizeText(widget.event.title,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Container(
                            width: screenWidth * 0.8,
                            child: AutoSizeText(
                                //"Mon, 26 July 2000 - Wed, 28 July 2020",
                                startdate == enddate
                                    ? startdate
                                    : date.toString() + " - " + startdate,
                                style: TextStyle(
                                  color: Colors.grey,
                                )))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 5),
                        child: Container(
                            width: screenWidth * 0.8,
                            child: Text(reviews[index]["review"],
                                //"It was a wonderful event!! Enjoyed a lott and hope to see more such events...Thank You so much for it",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Container(
                            width: screenWidth * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                rating >= 1
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                      )
                                    : Container(),
                                rating > 1 ? SizedBox(width: 5) : Container(),
                                rating >= 2
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                      )
                                    : Container(),
                                rating > 2 ? SizedBox(width: 5) : Container(),
                                rating >= 3
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                      )
                                    : Container(),
                                rating > 3 ? SizedBox(width: 5) : Container(),
                                rating >= 4
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                      )
                                    : Container(),
                                rating > 4 ? SizedBox(width: 5) : Container(),
                                rating >= 5
                                    ? Icon(
                                        Icons.star,
                                        color: Colors.yellow[800],
                                      )
                                    : Container(),
                                rating > 5 ? SizedBox(width: 5) : Container(),
                              ],
                            ))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
                        child: Container(
                            width: screenWidth * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  reviews[index]["sentiment"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ))),
                  ],
                ))));
  }

  double screenWidth, screenHeight;
  final dateMapper = {
    1: 'Mon',
    2: 'Tues',
    3: 'Wed',
    4: 'Thurs',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun'
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
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.network(
                      widget.event.imageUrl,
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.24,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(13.0, 15, 13, 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black.withOpacity(0.3),
                    child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 5, 3, 5.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ))),
                widget.type == ORGANISATION
                    ? widget.event.endDate.difference(DateTime.now()).inMicroseconds > 0 
                    ? Material(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black.withOpacity(0.3),
                        child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            onTap: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventForm(
                                          org_id: int.parse(sharedPreferences
                                              .getString('id')),
                                          e: widget.event)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            )))
                      : Container()
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget eventName() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 20, 20),
        child: AutoSizeText(
          widget.event.title,
          style: GoogleFonts.raleway(
              color: Colors.yellow[800],
              fontWeight: FontWeight.w600,
              fontSize: 30),
          maxLines: 3,
        ),
      ),
    );
  }

  Widget dateAndTime(icon, DateTime date) {
    int startWeek = date.weekday;
    print(date);
    print(startWeek);
    print(dateMapper[startWeek]);
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
        child: Row(children: [
          Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CARD,
              elevation: 5,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  child: icon,
                ),
              )),
          SizedBox(
            width: 0,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(20, 15, 30, 15),
            child: AutoSizeText(
              dateMapper[startWeek] +
                  ", " +
                  DateFormat('d MMM, yyyy').format(date) +
                  " at " +
                  date.hour.toString().padLeft(2, "0") +
                  ":" +
                  date.minute.toString().padLeft(2, "0"),
              style: TextStyle(color: Colors.white),
              maxLines: 2,
            ),
          )
        ]));
  }

  Widget address() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 2, 30, 2),
        child: Row(children: [
          Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CARD,
              elevation: 5,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  child: Icon(Icons.location_on, color: Colors.white),
                ),
              )),
          // SizedBox(
          //   width: 10,
          // ),
          Container(
            width: screenWidth * 0.5,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
            child: AutoSizeText(
              widget.event.location,
              style: TextStyle(color: Colors.white),
              maxLines: 4,
            ),
          ),
        ]));
  }

  Widget ticketPrice() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 2),
        child: Row(children: [
          Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CARD,
              elevation: 5,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                    child: FaIcon(
                  FontAwesomeIcons.rupeeSign,
                  color: Colors.white,
                  size: 20,
                )),
              )),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(20, 15, 30, 15),
            child: AutoSizeText(
              widget.event.entryamount.toString(),
              style: TextStyle(color: Colors.white),
              maxLines: 2,
            ),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return loading
        ? Container(
            color: BACKGROUND,
            height: screenHeight,
            width: screenWidth,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: ListView(
              children: [
                Stack(
                  children: [
                    eventImage(),
                    Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.29,
                        ),
                        Material(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                            color: BACKGROUND,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    eventName(),
                                    widget.type == ATTENDEE
                                        ? !favourite
                                            ? Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    30, 0, 30, 15),
                                                child: Material(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: CARD,
                                                    elevation: 5,
                                                    shadowColor: Colors.black,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      onTap: () async {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        SharedPreferences
                                                            sharedPreferences =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        int id = int.parse(
                                                            sharedPreferences
                                                                .getString(
                                                                    "id"));
                                                        var fav = await http.post(
                                                            'https://rpk-happenings.herokuapp.com/add_to_favourite/user/$id/event/${widget.event.id}',
                                                            headers: {
                                                              "Authorization":
                                                                  sharedPreferences
                                                                      .getString(
                                                                          "token")
                                                            });
                                                        if (fav.statusCode ==
                                                            200) {
                                                          setState(() {
                                                            loading = false;
                                                            favourite = true;
                                                          });
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Home(
                                                                                type: ATTENDEE,
                                                                              )));
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Added to favourites.");
                                                        } else {
                                                          print(fav.body);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Icon(
                                                            Icons
                                                                .favorite_border,
                                                            color: Colors.red),
                                                      ),
                                                    )))
                                            : Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    30, 0, 30, 15),
                                                child: Material(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: CARD,
                                                    elevation: 5,
                                                    shadowColor: Colors.black,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      onTap: () async {
                                                        setState(() {
                                                          loading = true;
                                                        });
                                                        SharedPreferences
                                                            sharedPreferences =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        int id = int.parse(
                                                            sharedPreferences
                                                                .getString(
                                                                    "id"));
                                                        var fav = await http.delete(
                                                            'https://rpk-happenings.herokuapp.com/add_to_favourite/user/$id/event/${widget.event.id}',
                                                            headers: {
                                                              "Authorization":
                                                                  sharedPreferences
                                                                      .getString(
                                                                          "token")
                                                            });
                                                        if (fav.statusCode ==
                                                            200) {
                                                          setState(() {
                                                            loading = false;
                                                            favourite = false;
                                                          });
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Home(
                                                                                type: ATTENDEE,
                                                                              )));
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Removed from favourites.");
                                                        } else {
                                                          print(fav.body);
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Icon(
                                                            Icons.favorite,
                                                            color: Colors.red),
                                                      ),
                                                    )))
                                        : Container()
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 30),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "- " + org_name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(10),
                                  child: Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                    color: CARD,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.local_offer,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(widget.event.category,
                                              style: TextStyle(
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                dateAndTime(
                                    Icon(
                                      Icons.hourglass_empty,
                                      color: Colors.white,
                                    ),
                                    widget.event.startDate),
                                dateAndTime(
                                    Icon(
                                      Icons.hourglass_full,
                                      color: Colors.white,
                                    ),
                                    widget.event.endDate),
                                address(),
                                ticketPrice(),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                  child: Container(
                                    width: screenWidth - 60,
                                    child: Text(
                                      "About",
                                      style: GoogleFonts.raleway(
                                          color: Colors.yellow[800],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: Container(
                                    width: screenWidth - 60,
                                    child: Text(
                                      widget.event.description,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 20, 30, 10),
                                  child: Container(
                                    width: screenWidth - 60,
                                    child: Text(
                                      "Speciality",
                                      style: GoogleFonts.raleway(
                                          color: Colors.yellow[800],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: Container(
                                    width: screenWidth - 60,
                                    child: Text(
                                      widget.event.speciality,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                reviews.length != 0
                                    ? reviewsTab()
                                    : Container(),
                                // SizedBox(height: 70),
                                widget.type == ATTENDEE && recommended_events.length != 0
                                ?  Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: Container(
                                    width: screenWidth - 60,
                                    child: Text(
                                      "Similar events",
                                      style: GoogleFonts.raleway(
                                          color: Colors.yellow[800],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                ) : Container(),
                                widget.type == ATTENDEE && recommended_events.length != 0
                                ? Container(
                                  height: 260,
                                  child: ListView.builder(
                                    itemCount: recommended_events.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return recommendedEventCard(index);
                                    },
                                  ),
                                ) : Container(),
                                SizedBox(height: 70),
                              ],
                            )),

                      ],
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: widget.type == ATTENDEE
                ? (diff != null && diff.inMilliseconds > 0)
                    ? !registered
                        ? FloatingActionButton.extended(
                            onPressed: () async {
                              // Add your onPressed code here!
                              print("On register");
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      title: Text(
                                        'Are you sure about registering?\nYour profile image will be used for validating you at the day of the event.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xff102733),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      children: <Widget>[
                                        Divider(
                                          thickness: 2,
                                          indent: 20,
                                          endIndent: 20,
                                        ),
                                        SimpleDialogOption(
                                            child: Text(
                                              "Yes",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: CARD),
                                            ),
                                            onPressed: () async {
                                              SharedPreferences
                                                  sharedPreferences =
                                                  await SharedPreferences
                                                      .getInstance();

                                              var response = await http.post(
                                                'https://rpk-happenings.herokuapp.com/register_for_event/event/' +
                                                    widget.event.id.toString() +
                                                    '/user/' +
                                                    sharedPreferences
                                                        .getString("id"),
                                              );
                                              if (response.statusCode == 200) {
                                                print(
                                                    "Registered for the event");
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home(
                                                                type:
                                                                    ATTENDEE)));
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Registered for the event");
                                              } else {
                                                print(response.body);
                                              }
                                            }),
                                        SimpleDialogOption(
                                            child: Text(
                                              "No",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: CARD),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    );
                                  });
                            },
                            label: Text('Register',
                                style: TextStyle(color: BACKGROUND)),
                            icon: Icon(Icons.arrow_forward_ios),
                            backgroundColor: Colors.yellow[800],
                          )
                        : FloatingActionButton.extended(
                            backgroundColor: Colors.yellow[800],
                            onPressed: () {},
                            label: Text(
                                diff.inDays.toString() == "1"
                                    ? (diff.inDays.toString() + " day to go")
                                    : diff.inDays.toString() + " days to go",
                                style: TextStyle(color: BACKGROUND)),
                          )
                    : registered
                        ? FloatingActionButton.extended(
                            backgroundColor: Colors.yellow[800],
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  elevation: 12,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext bc) {
                                    return StatefulBuilder(builder: (BuildContext
                                            context,
                                        StateSetter
                                            setState /*You can rename this!*/) {
                                      return Wrap(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                            margin: EdgeInsets.all(15.0),
                                            padding: EdgeInsets.fromLTRB(
                                                18, 0, 18, 0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Center(
                                                          child: Container(
                                                        height: 2,
                                                        width: 50,
                                                        color: Colors.black,
                                                        margin: EdgeInsets.only(
                                                            top: 20),
                                                      )),
                                                    ),
                                                    Expanded(
                                                      child: ListView(
                                                        children: <Widget>[
                                                          ListTile(
                                                              title: Text(
                                                                  "Write a review",
                                                                  style: GoogleFonts.raleway(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              subtitle: Text(
                                                                  " Happenings",
                                                                  style: GoogleFonts.raleway(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                              trailing: InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                  Icons.cancel,
                                                                  size: 30,
                                                                  color:
                                                                      BACKGROUND,
                                                                ),
                                                              )),
                                                          Divider(
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .blue[50],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0)),
                                                            child: TextField(
                                                              minLines: 4,
                                                              maxLines: 4,
                                                              controller:
                                                                  content,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      "Your review ...",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20.0,
                                                          ),
                                                          Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          0),
                                                              child: Text(
                                                                  "Choose your Rating",
                                                                  style: GoogleFonts.raleway(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    10, 0),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "1");
                                                                      setState(
                                                                          () {
                                                                        rating =
                                                                            1;
                                                                      });
                                                                    },
                                                                    child: rating <
                                                                            1
                                                                        ? Icon(Icons
                                                                            .star_border)
                                                                        : Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.yellow[800],
                                                                          )),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "2");
                                                                      setState(
                                                                          () {
                                                                        rating =
                                                                            2;
                                                                      });
                                                                    },
                                                                    child: rating <
                                                                            2
                                                                        ? Icon(Icons
                                                                            .star_border)
                                                                        : Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.yellow[800],
                                                                          )),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "3");
                                                                      setState(
                                                                          () {
                                                                        rating =
                                                                            3;
                                                                      });
                                                                    },
                                                                    child: rating <
                                                                            3
                                                                        ? Icon(Icons
                                                                            .star_border)
                                                                        : Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.yellow[800],
                                                                          )),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "4");
                                                                      setState(
                                                                          () {
                                                                        rating =
                                                                            4;
                                                                      });
                                                                    },
                                                                    child: rating <
                                                                            4
                                                                        ? Icon(Icons
                                                                            .star_border)
                                                                        : Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.yellow[800],
                                                                          )),
                                                                GestureDetector(
                                                                    onTap: () {
                                                                      print(
                                                                          "5");
                                                                      setState(
                                                                          () {
                                                                        rating =
                                                                            5;
                                                                      });
                                                                    },
                                                                    child: rating <
                                                                            5
                                                                        ? Icon(Icons
                                                                            .star_border)
                                                                        : Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                Colors.yellow[800],
                                                                          )),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Container(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Spacer(),
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      print(
                                                                          rating);
                                                                      print(content
                                                                          .text);
                                                                      setState(
                                                                          () {
                                                                        loading =
                                                                            true;
                                                                      });
                                                                      SharedPreferences
                                                                          sharedPreferences =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                      int id = int.parse(
                                                                          sharedPreferences
                                                                              .getString("id"));
                                                                      Map data =
                                                                          {
                                                                        "event_id": int.parse(widget
                                                                            .event
                                                                            .id),
                                                                        "review":
                                                                            content.text,
                                                                        "rating":
                                                                            rating
                                                                      };
                                                                      var review = await http.post(
                                                                          'https://rpk-happenings.herokuapp.com/add_review/' +
                                                                              sharedPreferences.getString("id"),
                                                                          headers: {
                                                                            "Content-type":
                                                                                "application/json",
                                                                            "Accept":
                                                                                "application/json",
                                                                            "charset":
                                                                                "utf-8",
                                                                            "Authorization":
                                                                                sharedPreferences.getString("token")
                                                                          },
                                                                          body: json.encode(data));
                                                                      if (review
                                                                              .statusCode ==
                                                                          200) {
                                                                        Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => Home(type: ATTENDEE)));
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "Review added");
                                                                      } else {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                review.body);
                                                                      }

                                                                      setState(
                                                                          () {
                                                                        loading =
                                                                            true;
                                                                      });
                                                                    },
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          BACKGROUND,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_forward,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30.0,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ],
                                      );
                                    });
                                  });
                            },
                            label: Text("Write a review",
                                style: TextStyle(color: BACKGROUND)),
                          )
                        : Container()
                : FloatingActionButton.extended(
                    backgroundColor: Colors.yellow[800],
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendeeList(
                                  event_id: widget.event.id,
                                  startDate: widget.event.startDate,
                                  endDate: widget.event.endDate)));
                    },
                    label: Text("See your attendees",
                        style: TextStyle(color: BACKGROUND)),
                  ));
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
            width: screenWidth / 1.5,
            height: 250,
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL, // default
              front: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: CARD),
                  height: 250,
                  width: screenWidth / 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.network(e.imageUrl,
                        width: screenWidth / 1.5,
                        height: 250,
                        fit: BoxFit.fill),
                  )),
              back: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: CARD,
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.dstATop),
                        image: new NetworkImage(
                          e.imageUrl,

                        ),
                      ),
                  ),
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
                              width: screenWidth / 1.5,
                              child: AutoSizeText(e.title,
                                  textAlign: TextAlign.start,
                                  minFontSize: 18,
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: Colors.yellow[800],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: (screenWidth / 1.5) - 10,
                              child: AutoSizeText(
                                  startdate == enddate
                                      ? startdate
                                      : date.toString() + " - " + enddate,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
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
                                width: screenWidth / 1.5 - 68,
                                child: AutoSizeText(e.location,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
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
                                width: screenWidth / 1.5 - 68,
                                child: AutoSizeText(
                                    e.entryamount.toString() + " /-",
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
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

  Widget recommendedEventCard(int index) {
    Event event1 = recommended_events[index];
    // Event event2 = allEvents[allEvents.length - index - 1];
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: flipcard(event1));
  }
}
