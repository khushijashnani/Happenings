import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/constants.dart';

class AttendeeList extends StatefulWidget {
  String event_id;
  DateTime startDate;
  DateTime endDate;
  AttendeeList({Key key, this.startDate, this.endDate, this.event_id})
      : super(key: key);

  @override
  _AttendeeListState createState() => _AttendeeListState();
}

class _AttendeeListState extends State<AttendeeList> {
  List<String> urls;
  List names;
  List encodings;
  DateTime d;

  getAttendees() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var registers = await http.get(
        'https://rpk-happenings.herokuapp.com/validate_attendee/' +
            widget.event_id,
        headers: {"Authorization": sharedPreferences.getString("token")});
    if (registers.statusCode == 200) {
      var data = json.decode(registers.body);
      setState(() {
        //urls = data['imageUrls'];
        names = data['names'];
        encodings = data['encodings'];
      });
      print(names);
      print(encodings);
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    d = DateTime.now();
    getAttendees();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: BACKGROUND,
        appBar: AppBar(
          title: Text("Attendees"),
          backgroundColor: BACKGROUND,
        ),
        // body: ListWheelScrollView.useDelegate(
        //   // itemExtent: ,
        //   childDelegate:
        //       ListWheelChildBuilderDelegate(builder: (context, index) {
        //     return Container(
        //         width: screenWidth,
        //         height: 55,
        //         padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        //         child: Material(
        //           elevation: 5,
        //           shadowColor: Colors.black,
        //           borderRadius: BorderRadius.all(Radius.circular(25)),
        //           color: CARD,
        //           child: Container(
        //               decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.all(Radius.circular(25)),
        //                   color: CARD),
        //               child: ListTile(
        //                 title: Text("w"
        //                     //   name.text,
        //                     //   style: TextStyle(
        //                     //     color: Colors.white,
        //                     //     fontSize: 16
        //                     //   )
        //                     ),
        //                 trailing: InkWell(
        //                   onTap: () {
        //                     // setState(() {
        //                     //   showName = true;
        //                     // });
        //                   },
        //                   child: Icon(Icons.edit, color: Colors.white),
        //                 ),
        //                 leading: Icon(Icons.person, color: Colors.white),
        //               )),
        //         ));
        //   }),
        // ),
        floatingActionButton:
            d.isAfter(widget.startDate) && d.isBefore(widget.endDate)
                ? FloatingActionButton.extended(
                    backgroundColor: YELLOW,
                    onPressed: () {},
                    label: Text("Validate"))
                : Container(),
      ),
    );
  }
}
