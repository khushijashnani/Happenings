import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/eventform.dart';
import 'package:uvento/models/event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:uvento/pages/AttendeeHomeScreen.dart';
import 'package:uvento/pages/EventDetailPageOrganiser.dart';

class EventsList extends StatefulWidget {
  int id;
  String type;
  EventsList({Key key, this.id, this.type}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  List list = [];
  double screenHeight, screenWidth;

  getevents() async {
    var jsonData;
    var response = await http.get(
        'https://rpk-happenings.herokuapp.com/${widget.type}/${widget.id}/events');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (Map l in data) {
        list.add(Event.fromMap(l));
      }
      print(list[0].toJson());
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getevents();
  }

  Widget eventCard(Event e){
    String startdate = DateFormat('d MMM, yyyy').format(e.startDate);
    String enddate = DateFormat('d MMM, yyyy').format(e.endDate);
    int date = e.startDate.day;
    int startWeek = e.startDate.weekday;
    int endWeek = e.endDate.weekday;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: CARD,
        elevation: 5,
        shadowColor: Colors.black,
        child: InkWell(
          onTap: (){},
          child: Container(
            height: 150,
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
                      SizedBox(height: 20,),
                      Container(
                        width: screenWidth * 0.4,
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: BACKGROUND,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 4, 10, 4),
                          child: AutoSizeText(
                            startdate == enddate ? startdate : date.toString() + " - " + startdate,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: screenWidth * 0.65 - 30,
                        child: AutoSizeText(
                          e.title,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth * 0.35,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                    //color: Colors.pink,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
                    child: Image.network(
                      e.imageUrl,
                      width: screenWidth * 0.35,
                      height: 125,
                      fit: BoxFit.fill
                    ),
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
        backgroundColor: Color(0xff102733),
        body: SingleChildScrollView(
          child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "My Events",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EventForm(org_id: widget.id)));
                    },
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add_circle, color: Colors.yellow[800]),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 25, 25, 25),
                        child: Text(
                          "Post an event",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ]))
              ],
            ),
            list.length == 0 ? 
            Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "There are no\n",
                        style: TextStyle(color: Colors.white)),
                    TextSpan(
                        text: "events\n",
                        style: TextStyle(color: Colors.yellow[800])),
                    TextSpan(
                        text: "yet",
                        style: TextStyle(color: Colors.white)
                    ),
                  ]
                )
              ),
            )
            : 
            ListView.builder(
              padding: EdgeInsets.fromLTRB(10,5,10,5),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index != list.length) {
                  return InkWell(
                    onTap: (){
                      print(list[index].title);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailPageOrganiser(event: list[index],)));
                    },
                    child: PopularEventTile(
                      imgeAssetPath: list[index].imageUrl,
                      address: list[index].location,
                      desc: list[index].title,
                      date: list[index].startDate.month.toString() +
                          list[index].startDate.day.toString() +
                          ', ' +
                          list[index].startDate.year.toString(),
                    ),
                  );
                }
              }
            ),

            eventCard(list[0])
          ],
        ),
      ),
      )
    );
  }
}
