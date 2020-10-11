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
  RangeValues _currentRangeValues = const RangeValues(40, 80);
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
                  child: SingleChildScrollView(
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

                        height == 60 ? Container() : Column(
                          children: [
                            Text("Entry Amount", style: TextStyle(color: Colors.white)),
                            RangeSlider(
                              min: 0,
                              max: 5000,
                              values: _currentRangeValues,
                              labels: RangeLabels(
                                _currentRangeValues.start.round().toString(),
                                _currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _currentRangeValues = values;
                                });
                              },
                            ),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Minimum : " +  _currentRangeValues.start.round().toString(),
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    "Maximum : " + _currentRangeValues.end.round().toString(),
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
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
