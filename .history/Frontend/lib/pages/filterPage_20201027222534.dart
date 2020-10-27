import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uvento/constants.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uvento/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:uvento/pages/EventDetailPageOrganiser.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double screenWidth, screenHeight, height = 60;
  RangeValues _currentRangeValues = const RangeValues(0, 1000);
  String category = "None";
  DateTime currentDate = DateTime.now();
  DateTime date;
  List<String> locations = [];
  bool filterApplied = false;
  String formattedate;
  bool moneyFilter = false;
  List<Event> events = [], filtered = [];
  bool loading = false;

  Future<void> getAllEvents() async {
    setState(() {
      loading = true;
    });
    var response =
        await http.get('https://rpk-happenings.herokuapp.com/events');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        for (Map l in data) {
          DateTime startDate = DateTime.parse(l['start_date']);
          if (currentDate.isBefore(startDate)){
            events.add(Event.fromMap(l));
            filtered.add(Event.fromMap(l));
          }
        }
        print(filtered);
        loading = false;
        // print(allEvents[0].toJson());
      });
    } else {
      print(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllEvents();
    
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

  Widget filterCards() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          date != null || category != null ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  date != currentDate && date != null ? Material(
                    color: Colors.yellow[800],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: BACKGROUND,),
                          SizedBox(width: 5,),
                          Text(
                            "Date : " + formattedate,
                            style: TextStyle(
                              color: BACKGROUND
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){

                            },
                            child: Icon(Icons.cancel, color: BACKGROUND,),
                          )
                        ],
                      ),
                    ),
                  ) : Container(),

                  date != currentDate && date != null ? SizedBox(width: 20,) : Container(),

                  category == "None" ? Container() : Material(
                    color: Colors.yellow[800],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          Icon(Icons.category, color: BACKGROUND,),
                          SizedBox(width: 5,),
                          Text(
                            "Category : " + category,
                            style: TextStyle(
                              color: BACKGROUND
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){

                            },
                            child: Icon(Icons.cancel, color: BACKGROUND,),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ) : Container(),

          locations.length > 0 ? Container(
            height: 45,
            child: ListView.builder(
              itemCount: locations.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: index == 0 ? const EdgeInsets.only(right: 6) : index == locations.length - 1 ? const EdgeInsets.only(left : 6) : const EdgeInsets.only(left : 6, right: 6),
                  child: Material(
                    color: Colors.yellow[800],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: BACKGROUND,),
                          SizedBox(width: 3,),
                          Text(
                            locations[index],
                            style: TextStyle(
                              color: BACKGROUND
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){

                            },
                            child: Icon(Icons.cancel, color: BACKGROUND,),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ) : Container(),
        
          moneyFilter && (_currentRangeValues.start != 0 || _currentRangeValues.end != 1000) ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.yellow[800],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.rupeeSign, color: BACKGROUND, size : 18),
                          SizedBox(width: 5,),
                          Text(
                            "Minimum : " + _currentRangeValues.start.toInt().toString(),
                            style: TextStyle(
                              color: BACKGROUND
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){

                            },
                            child: Icon(Icons.cancel, color: BACKGROUND,),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 20,),

                  Material(
                    color: Colors.yellow[800],
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          FaIcon(FontAwesomeIcons.rupeeSign, color: BACKGROUND, size : 18),
                          SizedBox(width: 5,),
                          Text(
                            "Maximum : " + _currentRangeValues.end.toInt().toString(),
                            style: TextStyle(
                              color: BACKGROUND
                            ),
                          ),
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: (){

                            },
                            child: Icon(Icons.cancel, color: BACKGROUND,),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    formattedate = new DateFormat.yMMMd().format(date == null ? currentDate : date);
    print(date);
    print(currentDate);

    return loading ? 
      Scaffold(
        backgroundColor: BACKGROUND,
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Loading all Events...",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator()
            ],
          ),
        ),
      )
      : 
      SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: BACKGROUND,
              //elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.only(left : 10.0),
                    child: Text(
                      filterApplied ? "Applied Filters" : "Applied Filters : None",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.italic
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  filterApplied ? filterCards() : Container(),
                  SizedBox(height: 20,),

                  filtered.length == 0 ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, color: Colors.yellow[800]),
                        Text(
                          "No events match your filters..",
                          style: TextStyle(
                            color: Colors.white
                          )
                        ),
                      ],
                    ),
                  ) : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: eventCard(filtered[index]),
                      );
                    }
                  )
                ],
              ),
            )
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Material(
              color: CARD,
              elevation: 5,
              shadowColor: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: AnimatedContainer(
                width: screenWidth,
                height: height,
                decoration: BoxDecoration(
                  color: CARD,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                duration: Duration(seconds: 2),
                curve: Curves.fastOutSlowIn,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            height = height == 60 ? screenHeight*0.9 : 60;
                          });
                        },
                        child: Container(
                          height: 60,
                          width: screenWidth,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, color: Colors.white,),
                                SizedBox(width: 5,),
                                Text("Search by filter",
                                textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                    fontSize: 20,
                                    color: Colors.white,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      height == 60 ? Container() : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0,0),
                            child: Material(
                              color: Colors.white,
                              elevation: 5,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text("Entry Amount", style: TextStyle(color: CARD, fontSize: 18), textAlign: TextAlign.start)
                                ),
                              ),
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
                                moneyFilter = true;
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
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

                          Row(
                            children: [
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
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Text("Date", style: TextStyle(color: CARD, fontSize: 18), textAlign: TextAlign.start)
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 0),
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
                                      width: screenWidth * 0.4,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow[800],
                                        borderRadius: BorderRadius.all(Radius.circular(30))
                                      ),
                                      child: Center(child: Text("Select Date", style: TextStyle(color: Colors.black, fontSize: 18),)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left : 20.0),
                            child: Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              child: Text("Searching for events from : " + formattedate, style: TextStyle(fontSize: 15, color : Colors.white), textAlign: TextAlign.center),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                            child: Row(
                              children: [
                                locationCard("Borivali"),

                                SizedBox(width: 10,),
                                locationCard("Andheri"),

                                SizedBox(width: 10,),
                                locationCard("Online")
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Row(
                              children: [
                                locationCard("Bhayandar"),

                                SizedBox(width: 10,),
                                locationCard("Marine Drive")
                              ],
                            ),
                          ),
                        
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                                child: Material(
                                  color: Colors.yellow[800],
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    onTap: (){
                                      setState(() {
                                        locations.clear();
                                        category = "None";
                                        date = currentDate;
                                        _currentRangeValues = RangeValues(0, 1000);
                                        filterApplied = false;
                                        filtered = events;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      child: Text(
                                        "Reset",
                                        style: TextStyle(
                                          color: CARD,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                                child: Material(
                                  color: Colors.yellow[800],
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    onTap: (){
                                      // print(formattedate);
                                      // print(_currentRangeValues.start);
                                      // print(_currentRangeValues.end);
                                      // print(locations);
                                      // print(category);
                                      setState(() {
                                        height = height == 60 ? screenHeight*0.9 : 60;
                                        filterApplied = true;

                                        List<Event> temp = [];

                                        for (Event e in events) {
                                          if ((!moneyFilter || (e.entryamount >= _currentRangeValues.start && e.entryamount <= _currentRangeValues.end)) && 
                                          (category == "None" || e.category == category) && 
                                          (date == null || date == currentDate || date.isBefore(e.startDate))){
                                            if (locations.length == 0){
                                              temp.add(e);
                                            }
                                            else{
                                              for (String s in locations) {
                                                print(s);
                                                print(e.location);
                                                if (e.location.contains(s)){
                                                  print(e.title);
                                                  temp.add(e);
                                                  break;
                                                }
                                              }
                                            }
                                          }
                                        }

                                        filtered = temp;
                                        print(filtered);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                                      child: Text(
                                        "Apply",
                                        style: TextStyle(
                                          color: CARD,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,)
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

  Widget locationCard(String location) {
    return Padding(
      padding: const EdgeInsets.only(left : 0),
      child: Material(
        color: locations.contains(location) ? Colors.yellow[800] : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          onTap: (){
            setState(() {
              if (locations.contains(location)){
                locations.remove(location);
              } else {
                locations.add(location);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 0,),
                Text(
                  location,
                  style: TextStyle(
                    color: locations.contains(location) ? CARD : CARD, fontWeight: FontWeight.w900, fontSize: 15
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget eventCard(Event e) {
    String startdate = DateFormat('d MMM, yyyy').format(e.startDate);
    String enddate = DateFormat('d MMM, yyyy').format(e.endDate);
    int date = e.startDate.day;

    return Padding(
      padding: const EdgeInsets.all(0.0),
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
            height: 160,
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
                        height: 15,
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
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                          width: 17,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
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
                  width: screenWidth * 0.27,
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
                        width: screenWidth * 0.27,
                        height: 135,
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
}
