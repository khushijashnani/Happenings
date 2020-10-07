import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/pages/AttendeeHomeScreen.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double screenWidth, screenHeight;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: BACKGROUND,
              elevation: 5,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text("Search by filter",
                        style: GoogleFonts.raleway(
                          fontSize: 25,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    height: 450,
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20,10,20,10),
            alignment: Alignment.centerRight,
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.yellow[800],
              elevation: 5,
              child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                      height: 50,
                      width: screenWidth/3,
                      child: Text("Search",style: GoogleFonts.raleway(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: BACKGROUND,
                        )))),
            ))
      ],
    ));
  }
}
