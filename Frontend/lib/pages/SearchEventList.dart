import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/models/event.dart';
import 'package:intl/intl.dart';
import 'package:uvento/pages/EventDetailPageOrganiser.dart';

class SearchEventList extends StatefulWidget {
  String name;
  List<Event> list;
  SearchEventList({Key key, this.list,this.name}) : super(key: key);

  @override
  _SearchEventListState createState() => _SearchEventListState();
}

class _SearchEventListState extends State<SearchEventList> {
  double screenHeight, screenWidth;

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
                                : date.toString() + " - " + enddate,
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
                      Row(children: [
                        SizedBox(
                          width: 22,
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
                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
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

    return Material(
      color: BACKGROUND,
      child: SingleChildScrollView(
          child: Container(
              color: BACKGROUND,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.fromLTRB(20, 37, 0, 0),
                      child: Material(
                        color: BACKGROUND,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 10,
                        child: InkWell(
                          radius: 50,
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.yellow[800],
                            size: 30,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                        child: Text(widget.name,
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ))),
                  ],
                ),
                widget.list == null
                    ? Container(
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
                                  style: TextStyle(color: Colors.white)),
                            ])),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: widget.list.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (index != widget.list.length) {
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
                            return eventCard(widget.list[index]);
                          }
                        }),
              ]))),
    );
  }
}
