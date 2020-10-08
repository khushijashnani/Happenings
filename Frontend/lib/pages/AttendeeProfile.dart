import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/login.dart';
import 'package:uvento/models/attendee.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendeeProfile extends StatefulWidget {
  Attendee attendee;
  AttendeeProfile({Key key, this.attendee}) : super(key: key);

  @override
  _AttendeeProfileState createState() => _AttendeeProfileState();
}

class _AttendeeProfileState extends State<AttendeeProfile>
    with SingleTickerProviderStateMixin {
  double screenWidth, screenHeight;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar _getTabBar() {
    return TabBar(
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
                                          child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow[800],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.favorite_outline,
                                                        color: BACKGROUND),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text("Favourites",
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color:
                                                                    BACKGROUND,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ])))),
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
                                          child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.yellow[800],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Icon(Icons.edit,
                                                  color: Colors.yellow[800])))),
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
                              <Widget>[Icon(Icons.home), reviewsTab()],
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

  Widget reviewsTab() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          itemCount: 5,
          itemBuilder: (context, index) {
            return reviewCards();
          }),
    );
  }

  Widget reviewCards() {
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
                            child: AutoSizeText("Marathon Bounce",
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
                                "Mon, 26 July 2000 - Wed, 28 July 2020",
                                style: TextStyle(
                                  color: Colors.grey,
                                )))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 5),
                        child: Container(
                            width: screenWidth * 0.8,
                            child: Text(
                                "It was a wonderful event!! Enjoyed a lott and hope to see more such events...Thank You so much for it",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Container(
                            width: screenWidth * 0.8,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[800],
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[800],
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow[800],
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star_half,
                                  color: Colors.yellow[800],
                                ),
                                SizedBox(width: 5),
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
                                  "Positive",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text("- Priyav Mehta",
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
