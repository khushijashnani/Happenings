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
  double screenWidth, screenHeight, height = 60;
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
      child: Stack(
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
                    width: screenWidth,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text("Search by filter",
                    textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        color: Colors.white,
                      )
                    ),
                  ),
                  Container(
                    height: 450,
                    child: Column(
                      children: [
                      ],
                    ),
                  ),
                ],
              ),
            )
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              color: CARD,
              elevation: 5,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: InkWell(
                onTap: (){
                  setState(() {
                    height = height == 60 ? screenHeight * 0.8 : 60;
                  });
                },
                child: AnimatedContainer(
                  width: screenWidth * 0.9,
                  height: height,
                  decoration: BoxDecoration(
                    color: CARD,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  duration: Duration(seconds: 1),
                  curve: Curves.bounceIn,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: screenWidth,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Center(
                          child: Text("Search by filter",
                          textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                              color: Colors.white,
                            )
                          ),
                        ),
                      ),

                      Text("hello")
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}
