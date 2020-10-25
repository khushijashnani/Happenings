import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/eventform.dart';
import 'package:uvento/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:uvento/models/organisation.dart';
import 'package:uvento/pages/AttendeeHomeScreen.dart';
import 'package:uvento/pages/EventDetailPageOrganiser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uvento/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsList extends StatefulWidget {
  int id;
  String name;
  String type;
  Organisation organisation;
  EventsList({Key key, this.id, this.type, this.name, this.organisation}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List list = [];
  double screenHeight, screenWidth;
  bool loading = false;

  getevents() async {
    var jsonData;
    print(widget.type);
    print(widget.id);
    var response = await http.get(
        'https://rpk-happenings.herokuapp.com/${widget.type}/${widget.id}/events');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (Map l in data) {                                                
        list.add(Event.fromMap(l));
      }
      //print(list[1].toJson());
    } else {
      print(response.body);
    }
  }

  Widget subscriptionCard() {
    return Material(
        color: CARD,
        elevation: 10,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        shadowColor: Colors.black,
        child: Container(
          height: screenHeight / 3,
          width: screenWidth - 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)), color: CARD),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.asset(
                    "assets/logo.png",
                    height: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "HAPPEN",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        "INGS",
                        style: TextStyle(
                            color: Color(0xffFFA700),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              ]),
              Container(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                alignment: Alignment.centerLeft,
                child: Text("Yearly subscription",
                    style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500)),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: '⦿',
                    style: TextStyle(
                      color: YELLOW,
                      fontWeight: FontWeight.w200,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' You can post upto 20 events.\n',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '⦿',
                      ),
                      TextSpan(
                        text:
                            ' Enjoy secure validation through our face recognition feature.\n',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: '⦿',
                      ),
                      TextSpan(
                        text:
                            ' Strategize your business plan with the help of our dashboard which contains graphs for data analysis.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  alignment: Alignment.centerRight,
                  child : Material(
                    elevation: 10,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      var response = await http.post(
                          'https://rpk-happenings.herokuapp.com/subs/${int.parse(sharedPreferences.getString("id"))}');
                      if (response.statusCode == 200) {
                        print("Subscribed");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Home(type: ORGANISATION)));
                        Fluttertoast.showToast(
                            msg: "User is successfully subscribed");
                      } else {
                        print(response.body);
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: YELLOW),
                        color: Colors.yellow[800],
                      ),
                      child: Center(
                          child: Text("Buy Now",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                  ),
                )
              )
            )
            ],
          ),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getevents();
  }

  Widget eventCard(Event e) {
    String startdate = DateFormat('d MMM, yyyy').format(e.startDate);
    String enddate = DateFormat('d MMM, yyyy').format(e.endDate);
    int date = e.startDate.day;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CARD,
        elevation: 5,
        shadowColor: Colors.black,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPageOrganiser(
                    event: e,
                    type: ORGANISATION,
                  ),
                ));
          },
          child: Container(
            height: 180,
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
                        height: 20,
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
                        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                        child: Container(
                          width: screenWidth * 0.65 - 45,
                          child: AutoSizeText(
                            e.title,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 0, 10),
                        child: Container(
                          width: screenWidth * 0.65 - 45,
                          child: Row(
                            children: [
                              AutoSizeText(
                                "Organised by ",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 15),
                              ),
                              AutoSizeText(
                                widget.name,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
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
                  width: screenWidth * 0.35,
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
                        width: screenWidth * 0.35,
                        height: 145,
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
        body: loading 
        ? Container(
        height: screenHeight,
        width: screenWidth,
        color: BACKGROUND,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Subscribing",style: GoogleFonts.raleway(color:YELLOW),),
              CircularProgressIndicator(),
            ],
          ),
        ),
      )
      :widget.organisation.subscription 
      ? Stack(
        children: [
          Container(
            color: BACKGROUND,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(25),
                        child: Text(widget.organisation.name +  "'s  events",
                            style: GoogleFonts.raleway(
                                fontSize: 25,
                                color: Colors.yellow[800],
                                fontWeight: FontWeight.bold))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventForm(org_id: widget.id)));
                        },
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          // Icon(Icons.add_circle, color: Colors.yellow[800]),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 25, 25, 25),
                            child: Icon(Icons.add_circle, color: Colors.yellow[800]),
                            // Text(
                            //   "Post an event",
                            //   style:
                            //       TextStyle(color: Colors.white, fontSize: 15),
                            // ),
                          ),
                        ]))
                  ],
                ),
                list.length == 0
                    ? Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "There are no ",
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(
                                  text: "events ",
                                  style: TextStyle(color: Colors.yellow[800])),
                              TextSpan(
                                  text: "yet",
                                  style: TextStyle(color: Colors.white)),
                            ])),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: list.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index != list.length) {
                            // return InkWell(
                            //   onTap: (){
                            //     print(list[index].title);
                            //     Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailPageOrganiser(event: list[index],)));
                            //   },
                            //   child: PopularEventTile(
                            //     imgeAssetPath: list[index].imageUrl,
                            //     address: list[index].location,
                            //     desc: list[index].title,
                            //     date: list[index].startDate.month.toString() +
                            //         list[index].startDate.day.toString() +
                            //         ', ' +
                            //         list[index].startDate.year.toString(),
                            //   ),
                            // );
                            return eventCard(list[index]);
                          }
                        }),

                //eventCard(list[1])
              ],
            ),
          ),
        ],
      ) 
      : Container(
                width: screenWidth,
                height: screenHeight,
                color: BACKGROUND,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Image.asset(
                                    "assets/logo.png",
                                    height: 25,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 20),
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
                              ]),
                          Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: Colors.white),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      widget.organisation.imageUrl,
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.fill,
                                    )),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child : Text("Looks like you haven't subscribed...\n To subscribe go to the dashboard",style :GoogleFonts.raleway(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.w500))
                      ),
                    ),
                    //subscriptionCard(),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                )),
    ));
  }
}
