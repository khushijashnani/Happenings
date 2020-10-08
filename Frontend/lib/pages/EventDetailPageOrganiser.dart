import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/eventform.dart';
import 'package:uvento/home.dart';
import 'package:uvento/models/event.dart';
import 'package:uvento/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

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

  getUserDetails() async {
    setState(() {
      loading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int id = int.parse(sharedPreferences.getString("id"));
    var fav = await http.get(
        'https://rpk-happenings.herokuapp.com/${widget.type}/$id/favs',
        headers: {"Authorization": sharedPreferences.getString("token")});
    if (fav.statusCode == 200) {
      var data = json.decode(fav.body);
      for (Map f in data) {
        print(f);
        favs.add(int.parse(f['id']));
      }

      var registers = await http.get(
          'https://rpk-happenings.herokuapp.com/${widget.type}/$id/registeredevents',
          headers: {"Authorization": sharedPreferences.getString("token")});
      if (registers.statusCode == 200) {
        var data = json.decode(fav.body);
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
        if (registered) {
          DateTime d = DateTime.now();
          diff = d.difference(widget.event.startDate);
        }
        setState(() {
          loading = false;
        });
      } else {
        Fluttertoast.showToast(msg: registers.body);
      }
    } else {
      Fluttertoast.showToast(msg: fav.body);
    }
  }

  bool registered = false;
  bool favourite = false;
  Duration diff;
  bool loading = false;

  @override
  void initState() {
    getUserDetails();

    super.initState();
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

  // Widget dateAndTime() {
  //   String startdate = DateFormat('d MMM, yyyy').format(widget.event.startDate);
  //   String enddate = DateFormat('d MMM, yyyy').format(widget.event.endDate);
  //   int startWeek = widget.event.startDate.weekday;
  //   int endWeek = widget.event.endDate.weekday;

  //   return Padding(
  //       padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
  //       child: Material(
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //         color: CARD,
  //         elevation: 5,
  //         shadowColor: Colors.black,
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.date_range,
  //                     color: Colors.white,
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     dateMapper[startWeek] +
  //                         ", " +
  //                         startdate +
  //                         " - " +
  //                         dateMapper[endWeek] +
  //                         ", " +
  //                         enddate,
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                     ),
  //                     textAlign: TextAlign.left,
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 0,
  //               ),
  //               // Row(
  //               //   children: [
  //               //     Icon(Icons.favorite, color: CARD,size: 30,),
  //               //     SizedBox(width: 10,),
  //               //     Text(
  //               //       "10 am - 9 pm",
  //               //       style: TextStyle(
  //               //         color: Colors.grey,
  //               //       ),
  //               //       textAlign: TextAlign.left,
  //               //     ),
  //               //   ],
  //               // ),
  //             ],
  //           ),
  //         ),
  //       ));
  // }

  Widget dateAndTime(icon, date) {
    int startWeek = date.weekday;

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
                  DateFormat('d MMM, yyyy').format(widget.event.endDate) +
                  " at " +
                  date.hour.toString() +
                  ":" +
                  date.minute.toString(),
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
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(5),
            child: InkWell(
              onTap: () {},
              child: Text(
                "Get location",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ))
        ]));
    //       child: Row(
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.all(20),
    //                 child:Icon(Icons.location_on, color: Colors.white),
    //               ),
    //               SizedBox(width: 6,),
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children : [
    //                   Padding(
    //                     padding: EdgeInsets.all(5),
    //                       child: Text(
    //                       widget.event.location,
    //                       style: TextStyle(
    //                         color: Colors.white
    //                       ),
    //                     ),
    //                   ),
    //                   SizedBox(height: 5,),
    //                   Container(
    //                     width: screenWidth*0.6,
    //                     padding: EdgeInsets.all(5),
    //                     child: InkWell(
    //                       onTap: (){},
    //                       child: Text(
    //                         "Get location",
    //                         style: TextStyle(
    //                           color: Colors.grey
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ]
    //               )
    //             ],
    //           ),
    //     ),
    //   ),])
    // );
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
          // SizedBox(
          //   width: 10,
          // ),
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

  // Widget ticketPrice() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
  //     child: Material(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //       color: CARD,
  //       elevation: 5,
  //       shadowColor: Colors.black,
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 5.0, right: 5),
  //                   child: FaIcon(
  //                     FontAwesomeIcons.rupeeSign,
  //                     color: Colors.white,
  //                     size: 20,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 8,
  //                 ),
  //                 Text(
  //                   widget.event.entryamount.toString(),
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(
  //               height: 8,
  //             ),
  //             Row(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 0.0, right: 0),
  //                   //child: FaIcon(FontAwesomeIcons.codeBranch, color: Colors.white, size: 20,),
  //                   child: Icon(
  //                     Icons.category,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 8,
  //                 ),
  //                 Text(
  //                   widget.event.category + " Event",
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    // String startdate = DateFormat('d MMM, yyyy').format(widget.event.startDate);
    // String enddate = DateFormat('d MMM, yyyy').format(widget.event.endDate);

    return loading
        ? Container(
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
                                                          });
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
                                                          });
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
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(10),
                                  child: Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(40),
                                    ),
                                    color: CARD,
                                    child: Container(
                                      // width: screenWidth/2,
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
                                      Icons.hourglass_top_rounded,
                                      color: Colors.white,
                                    ),
                                    widget.event.startDate),
                                dateAndTime(
                                    Icon(
                                      Icons.hourglass_bottom_rounded,
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
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: widget.type == ATTENDEE
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
                                    'Are you sure about registering?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff102733),
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
                                          SharedPreferences sharedPreferences =
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
                                            print("Registered for the event");
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home(type: ATTENDEE)));
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
                        icon: Icon(
                          Icons.how_to_reg,
                        ),
                        backgroundColor: Colors.yellow[800],
                      )
                    : FloatingActionButton.extended(
                        backgroundColor: Colors.yellow[800],
                        onPressed: () {},
                        label: Text(diff.inDays.toString() + " days to go",
                            style: TextStyle(color: BACKGROUND)),
                      )
                : FloatingActionButton.extended(
                    onPressed: () {},
                    label: Text("See Reviews",
                        style: TextStyle(color: BACKGROUND)),
                    backgroundColor: Colors.yellow[800],
                  ),
            //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
  }
}
