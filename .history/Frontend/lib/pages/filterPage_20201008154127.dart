import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/pages/AttendeeHomeScreen.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double screenWidth, screenHeight, height = 60;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  String category = "None";
  DateTime currentDate = DateTime.now();
  DateTime date;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  Future<void> selectDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
      context: context, 
      initialDate: currentDate,
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100),
      builder: (context, child) {
        return SingleChildScrollView(child: child,);
      });

    if (selectedDate != null){
      setState(() {
        date = selectedDate;
        print(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String formattedate = new DateFormat.yMMMd().format(date == null ? currentDate : date);

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
                      InkWell(
                        onTap: (){
                          setState(() {
                            height = height == 60 ? screenHeight * 0.8 : 60;
                          });
                        },
                        child: Container(
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
                      ),

                      height == 60 ? Container() : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0,0),
                            child: Container(
                              child: Text("Entry Amount", style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.start)
                            ),
                          ),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 0,0),
                            child: Material(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text("Category", style: TextStyle(color: CARD, fontSize: 18), textAlign: TextAlign.start)
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Material(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: CARD,
                              elevation: 10,
                              shadowColor: Colors.black,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
                                decoration: BoxDecoration(
                                  //border: Border.all(color: Colors.yellow[800]),
                                  borderRadius: new BorderRadius.circular(25.0),
                                  color: CARD.withOpacity(0.5),
                                ),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  hint: Text(
                                    "Category",
                                  ),
                                  items: <String>[
                                    'Health & Wellness',
                                    'Photography',
                                    'Cultural',
                                    'Outdoor & Adventure',
                                    'Tech',
                                    'Sports',
                                    'Music & Arts',
                                    'Social',
                                    'Educational',
                                    'Sci-fi & Games',
                                    'Career & Business',
                                    'Others',
                                    'None'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    );
                                  }).toList(),
                                  iconSize: 20,
                                  elevation: 16,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (newValue) {
                                    setState(() {
                                      category = newValue;
                                      print(category);
                                    });
                                  },
                                  dropdownColor: Color(0xff102733),
                                  value: category,
                                ),
                              ),
                            )
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                            child: Material(
                              color: Colors.yellow[800],
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child: InkWell(
                                onTap: () {
                                  selectDate(context);
                                },
                                child: Container(
                                  width: screenWidth * 0.5,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[800],
                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                  ),
                                  child: Center(child: Text("Select Date", style: TextStyle(color: Colors.black, fontSize: 18),)),
                                ),
                              ),
                            ),
                          ),

                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text("Searching for events from : " + formattedate, style: TextStyle(fontSize: 16, color : Colors.white), textAlign: TextAlign.center),
                          ),
                        ],
                      )
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
