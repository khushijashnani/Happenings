import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/eventform.dart';
import 'package:uvento/models/organisation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uvento/organiserDashboard/PieChartView.dart';
import 'package:pie_chart/pie_chart.dart';

class OrganiserHomeScreen extends StatefulWidget {

  Organisation organisation;
  OrganiserHomeScreen({this.organisation});

  @override
  _OrganiserHomeScreenState createState() => _OrganiserHomeScreenState();
}

class _OrganiserHomeScreenState extends State<OrganiserHomeScreen> {

  double screenHeight, screenWidth;
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };
  final pieChartColors = [
    Color.fromRGBO(82, 98, 255, 1), //  rgb(82, 98, 255)
    Color.fromRGBO(46, 198, 255, 1), // rgb(46, 198, 255)
    Color.fromRGBO(123, 201, 82, 1), // rgb(123, 201, 82)
    Color.fromRGBO(255, 171, 67, 1), // rgb(255, 171, 67)
    Color.fromRGBO(252, 91, 57, 1), //  rgb(252, 91, 57)
    Color.fromRGBO(139, 135, 130, 1), //rgb(139, 135, 130)
  ];

  Widget organiserCard(double bL, double bR, double tL, double tR, String top, String bottom, String alignment, IconData icon) {
    return Material(
      color: CARD,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(tL),
        topRight: Radius.circular(tR),
        bottomLeft: Radius.circular(bL),
        bottomRight: Radius.circular(bR),
      ),
      elevation: 5,
      shadowColor: Colors.black,
      child: Container(
        alignment: alignment == "tL" ? Alignment.topLeft : alignment == "tR" ?  Alignment.topRight : alignment == "bL" ? Alignment.bottomLeft : Alignment.bottomRight,
        width: screenWidth * 0.4,
        height: 100,
        decoration: BoxDecoration(
          color: CARD,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(tL),
            topRight: Radius.circular(tR),
            bottomLeft: Radius.circular(bL),
            bottomRight: Radius.circular(bR),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: alignment == "tL" || alignment == "tR" ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: alignment == "tL" || alignment == "bL" ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: alignment == "tR" || alignment == "bR" ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  icon == null ? Container() : Padding(
                    padding: const EdgeInsets.only(right : 3.0),
                    child: FaIcon(
                      icon, size: 15, color: YELLOW,
                    ),
                  ),
                  Text(
                    top,
                    style: TextStyle(
                      color: YELLOW, fontSize: 18
                    ),
                  ),
                ],
              ),
              Text(
                bottom,
                style: TextStyle(
                  color: Colors.white, fontSize: 18
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoriesRow() {
    return Expanded(
      flex: 3,
      child: Column(
        children: [

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: BACKGROUND
              ),
            ),

            Container(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, 
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Image.asset(
                                "assets/logo.png",
                                height: 25,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2, top: 20),
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
                          ]
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top : 20.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EventForm(org_id: widget.organisation.id,)));
                            },
                            child: Icon(
                              Icons.add_circle, color: YELLOW,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                organiserCard(10, 80, 10, 10, "25", "Events", "tL", null),
                                SizedBox(height: 20,),
                                organiserCard(10, 10, 10, 80, "35000 +", "Revenue", "bL", FontAwesomeIcons.rupeeSign),
                              ],
                            ),

                            Column(
                              children: [
                                organiserCard(80, 10, 10, 10, "1000 +", "Attendees", "tR", FontAwesomeIcons.userFriends),
                                SizedBox(height: 20,),
                                organiserCard(10, 10, 80, 10, "500 +", "Reviews", "bR", FontAwesomeIcons.comments),
                              ],
                            ),
                          ],
                        ),

                        Container(
                          width: screenWidth - 40,
                          height: 220,
                          child: Center(
                            child: Container(
                              width: screenWidth * 0.5,
                              height: 100,
                              decoration: BoxDecoration(
                                color: BACKGROUND,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: AutoSizeText(
                                    widget.organisation.name,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: YELLOW, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 30
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  

                  // Container(
                  //   height: screenHeight * 0.35,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         Expanded(
                  //           child: Row(
                  //             children: <Widget>[
                  //               categoriesRow(),
                  //               PieChartView(),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 40,),
                      
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: Duration(milliseconds: 5000),
                        chartLegendSpacing: 40,
                        chartRadius: 150,
                        colorList: pieChartColors,//[Colors.blue, Colors.orange, Colors.red, Colors.white],
                        initialAngleInDegree: -90,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 60,
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,color: Colors.white
                          ),
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                        ),
                      ),

                  SizedBox(height: 40,),

                  // Padding(
                  //   padding: const EdgeInsets.all(20.0),
                  //   child: Material(
                  //     color: CARD,
                  //     elevation: 5,
                  //     shadowColor: Colors.black,
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     child: Container(
                  //       width: screenWidth - 40,
                  //       height: 200,
                  //       decoration: BoxDecoration(
                  //         color: CARD,
                  //         borderRadius: BorderRadius.all(Radius.circular(10)),
                  //       ),
                  //       child: 
                  //     ),
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}