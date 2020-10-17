import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/home.dart';
import 'package:uvento/login.dart';
import 'package:uvento/models/attendee.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uvento/models/event.dart';
import 'package:intl/intl.dart';
import 'package:uvento/pages/AttendeeEditProfile.dart';
import 'package:uvento/pages/EventDetailPageOrganiser.dart';
import 'package:uvento/pages/SearchEventList.dart';

class AttendeeProfile extends StatefulWidget {
  Attendee attendee;
  List reviews;
  List<Event> allEvents;
  List<Event> favs;
  AttendeeProfile(
      {Key key, this.attendee, this.reviews, this.allEvents, this.favs})
      : super(key: key);

  @override
  _AttendeeProfileState createState() => _AttendeeProfileState();
}

class _AttendeeProfileState extends State<AttendeeProfile>
    with SingleTickerProviderStateMixin {
  double screenWidth, screenHeight;
  TabController tabController;
  bool loading = false;
  List<Event> events = [];

  Future<void> getevents() async {
    // var response =
    //     await http.get('https://rpk-happenings.herokuapp.com/events');
    // if (response.statusCode == 200) {
    //   var data = json.decode(response.body);
    setState(() {
      for (int i = 0; i < widget.reviews.length; i++) {
        for (Event e in widget.allEvents) {
          if (e.id == widget.reviews[i]["event_id"]) {
            events.add(e);
          }
        }
      }
      print(events);
    });
    // } else {
    //   print(response.body);
    // }
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    print(widget.reviews);
    getevents();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar _getTabBar() {
    return TabBar(
      unselectedLabelColor: Colors.white,
      indicatorColor: BACKGROUND,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: new BubbleTabIndicator(
        indicatorHeight: 43.0,
        indicatorColor: Colors.yellow[800],
        indicatorRadius: 10,
        tabBarIndicatorSize: TabBarIndicatorSize.label,
      ),
      tabs: <Widget>[
        Tab(text: "Your events"),
        Tab(
          text: "Your reviews",
        ),
      ],
      controller: tabController,
    );
  }

  TabBarView _getTabBarView(tabs) {
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }

  void choiceAction(String choice) async {
    if (choice == "Log Out") {
      // print("logout");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      Map<String, String> headers = {
        "Authorization": sharedPreferences.getString("token")
      };
      var response = await http.post(
          'https://rpk-happenings.herokuapp.com/logout',
          headers: headers);
      if (response.statusCode == 200) {
        print("Logged out");
        sharedPreferences.remove("token");
        sharedPreferences.remove("id");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        print(response.body);
      }
    }
  }

  Widget eventCard(Event e) {
    String startdate = DateFormat('d MMM, yyyy').format(e.startDate);
    String enddate = DateFormat('d MMM, yyyy').format(e.endDate);
    int date = e.startDate.day;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: const EdgeInsets.all(0.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CARD,
        elevation: 5,
        shadowColor: Colors.black,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPageOrganiser(
                    event: e,
                    type: ATTENDEE,
                  ),
                ));
          },
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth * 0.65 - 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: screenWidth * 0.4,
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: BACKGROUND,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 4, 10, 4),
                          child: AutoSizeText(
                            startdate == enddate
                                ? startdate
                                : date.toString() + " - " + startdate,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child: Container(
                          width: screenWidth * 0.65 - 45,
                          child: AutoSizeText(
                            e.title,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      Row(children: [
                        SizedBox(
                          width: 17,
                        ),
                        FaIcon(FontAwesomeIcons.rupeeSign,
                            color: Colors.white.withOpacity(0.7), size: 15),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: AutoSizeText(e.entryamount.toString() + " /-",
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal)),
                        )
                      ]),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                      //   child: Container(
                      //     width: screenWidth * 0.65 - 45,
                      //     child: Row(
                      //       children: [
                      //         AutoSizeText(
                      //           "Organised by ",
                      //           maxLines: 1,
                      //           style: TextStyle(
                      //               color: Colors.white.withOpacity(0.7),
                      //               fontSize: 15),
                      //         ),
                      //         AutoSizeText(
                      //           ,
                      //           maxLines: 1,
                      //           style: TextStyle(
                      //               color: Colors.white, fontSize: 18),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: Container(
                          width: screenWidth * 0.65 - 45,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: screenWidth * 0.44,
                                child: AutoSizeText(
                                  e.location,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.27,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(20)),
                    //color: Colors.pink,
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(50)),
                    child: Image.network(e.imageUrl,
                        width: screenWidth * 0.27,
                        height: 135,
                        fit: BoxFit.fill),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileImage() {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50)),
            child: Image.network(
              widget.attendee.imageUrl,
              width: screenWidth,
              height: screenHeight * 0.45,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(10),
            child: Material(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: BACKGROUND,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  onTap: () {
                    //Navigator.pop(context);
                  },
                  child: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    color: BACKGROUND,
                    onSelected: choiceAction,
                    itemBuilder: (BuildContext context) {
                      return choices.map((String choice) {
                        return PopupMenuItem(
                            textStyle: TextStyle(color: Colors.white),
                            value: choice,
                            child: Text(choice));
                      }).toList();
                    },
                  ),
                  // child: Container(
                  //   padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                  //   child: Icon(
                  //     Icons.more_vert,
                  //     color: Colors.white,
                  //     size: 20,
                  //   ),
                  // )
                )),
          )
          // Container(
          //   width: screenWidth,
          //   height: screenHeight * 0.4,
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 5.1, sigmaY: 5.1),
          //     child: Container(
          //       color: Colors.black.withOpacity(0.5),
          //     ),
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         SizedBox(
          //           height: screenHeight * 0.1,
          //         ),
          //         ClipRRect(
          //           borderRadius: BorderRadius.all(Radius.circular(15)),
          //           child: Image.network(
          //             widget.attendee.imageUrl,
          //             width: screenWidth * 0.7,
          //             height: screenHeight * 0.19,
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print(widget.attendee.phone_no);

    return ListView(children: [
      Container(
        color: BACKGROUND,
        child: Stack(children: [
          profileImage(),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: screenWidth * 0.85,
              child: Column(children: [
                SizedBox(
                  height: screenHeight * 0.35,
                ),
                Material(
                    elevation: 15,
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    color: BACKGROUND,
                    child: Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          width: screenWidth,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Center(
                            child: Text(
                              widget.attendee.name,
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.07, 10, screenWidth * 0.07, 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(children: [
                                        // TextSpan(
                                        //     text: "Username : ",
                                        //     style: GoogleFonts.raleway(
                                        //       color: Colors.white,
                                        //     )),
                                        TextSpan(
                                            text: widget.attendee.username,
                                            style: GoogleFonts.raleway(
                                              color: Colors.white,
                                            )),
                                      ]),
                                    ),
                                    // Text(", " + widget.attendee.phone_no,
                                    //     style: GoogleFonts.raleway(
                                    //       color: Colors.white,
                                    //     )),
                                  ]),
                              SizedBox(
                                height: 10,
                              ),
                              //Text(("Phone No :"+ widget.attendee.phone_no).toString(),style: GoogleFonts.raleway(color: Colors.white,))
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.attendee.phone_no,
                                        style: GoogleFonts.raleway(
                                          color: Colors.white,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(widget.attendee.gender,
                                        style: GoogleFonts.raleway(
                                          color: Colors.white,
                                        ))
                                  ]),
                              // Container(
                              //   width: screenWidth,
                              //   child:RichText(

                              //   text : TextSpan(
                              //     children:[
                              //     TextSpan(text:"Phone No :",style: GoogleFonts.raleway(color: Colors.white,)),
                              //     TextSpan(text: widget.attendee.phone_no,style: GoogleFonts.raleway(color: Colors.white,)),
                              //       ]
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Container(
                                      height: 50,
                                      width: screenWidth / 2.3,
                                      child: Material(
                                          elevation: 15,
                                          shadowColor: Colors.black,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: CARD,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchEventList(
                                                            name: "Favourites",
                                                            list: widget.favs,
                                                          )));
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow[800],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                          Icons.favorite_border,
                                                          color: BACKGROUND),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Favourites",
                                                          style: GoogleFonts
                                                              .raleway(
                                                                  color:
                                                                      BACKGROUND,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ])),
                                          ))),
                                  Container(
                                      height: 50,
                                      width: screenWidth / 6,
                                      child: Material(
                                          elevation: 15,
                                          shadowColor: Colors.black,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          color: CARD,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AttendeeEditProfile(attendee: widget.attendee,)));
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.yellow[800],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: Icon(Icons.edit,
                                                    color: Colors.yellow[800])),
                                          ))),
                                  SizedBox(
                                    width: 1,
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ])),
                SizedBox(height: 50),
                Container(
                  height: 500,
                  child: Scaffold(
                    backgroundColor: BACKGROUND,
                    body: Container(
                      height: 500,
                      child: Column(
                        children: <Widget>[
                          _getTabBar(),
                          Container(
                            height: 450,
                            child: _getTabBarView(
                              <Widget>[eventsTab(), reviewsTab()],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ]),
            ),
          )
        ]),
      )
    ]);
  }

  Widget eventsTab() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          itemCount: widget.allEvents.length,
          itemBuilder: (context, index) {
            if (widget.allEvents[index].endDate
                    .difference(DateTime.now())
                    .inDays <=
                0) {
              return Stack(
                children: [
                  eventCard(widget.allEvents[index]),
                  Container(
                    height: 160,
                    color: CARD.withOpacity(0.6),
                  )
                ],
              );
            } else {
              return eventCard(widget.allEvents[index]);
            }
          }),
    );
  }

  Widget reviewsTab() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          itemCount: widget.reviews.length,
          itemBuilder: (context, index) {
            return reviewCards(index);
          }),
    );
  }

  Widget reviewCards(int index) {
    String startdate =
        DateFormat('d MMM, yyyy').format(events[index].startDate);
    String enddate = DateFormat('d MMM, yyyy').format(events[index].endDate);
    int date = events[index].startDate.day;
    int rating = int.parse(widget.reviews[index]["rating"]);

    return Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                            child: AutoSizeText(events[index].title,
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
                            child: Text(widget.reviews[index]["review"],
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
                                  widget.reviews[index]["sentiment"],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text("- " + widget.attendee.name,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14))
                              ],
                            ))),
                  ],
                ))));
  }
}
