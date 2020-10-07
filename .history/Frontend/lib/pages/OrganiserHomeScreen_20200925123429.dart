import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/eventform.dart';
import 'package:uvento/models/analyticsModels.dart';
import 'package:uvento/models/organisation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:bezier_chart/bezier_chart.dart';

class OrganiserHomeScreen extends StatefulWidget {

  Organisation organisation;
  OrganiserHomeScreen({this.organisation});

  @override
  _OrganiserHomeScreenState createState() => _OrganiserHomeScreenState();
}

class _OrganiserHomeScreenState extends State<OrganiserHomeScreen> {

  List<Category> data = [];
  var series;
  double screenHeight, screenWidth;
  Map<String, double> dataMap = {
    "Technical": 5,
    "Social": 3,
    "Sports": 2,
    "Cultural": 2,
    "Fests" : 1,
    "Others" : 4,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    data = [
      Category("Technical", 100),
      Category("Social", 300),
      Category("Sports", 500),
      Category("Cultural", 200),
      Category("Fests", 250),
      Category("Others", 400),
    ];

    series = [
      charts.Series(
        id: 'Sales',
        //colorFn: () => char
        domainFn: (Category category, _) => category.category,
        measureFn: (Category category, _) => category.attendees,
        data: data,
        labelAccessorFn: (Category category, _) =>
              '${category.attendees.toString()}'
      )
    ];
  }

  Widget buildBarGraph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 300,
        width: screenWidth -40,
        child: ShaderMask(
          child: charts.BarChart (
            series,
            animate: true,
            animationDuration: Duration(milliseconds: 3000),
            defaultRenderer: new charts.BarRendererConfig(
              cornerStrategy: const charts.ConstCornerStrategy(30),
              barRendererDecorator: new charts.BarLabelDecorator<String>(
                insideLabelStyleSpec: charts.TextStyleSpec(
                  color: charts.Color.white,
                  fontSize: 10
                ),
                outsideLabelStyleSpec: charts.TextStyleSpec(
                  color: charts.Color.white,
                  fontSize: 10
                ),
                labelPosition: charts.BarLabelPosition.outside,
                labelAnchor: charts.BarLabelAnchor.end
              ),
              minBarLengthPx: 10
            ),
            domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.SmallTickRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 10,
                  color: charts.MaterialPalette.white
                ),
                lineStyle: new charts.LineStyleSpec(
                  color: charts.Color.fromHex(code: '#102733')
                )
              ),
              showAxisLine: false
            ),
            primaryMeasureAxis: new charts.NumericAxisSpec(
              renderSpec: new charts.GridlineRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white
                ),
                lineStyle: new charts.LineStyleSpec(
                  color: charts.Color.fromHex(code: '#102733')
                )
              ),
              showAxisLine: false
            ),
            behaviors: [
              new charts.SlidingViewport(),
              new charts.PanAndZoomBehavior(),
              new charts.ChartTitle(
                'Categories V/s Attendees',
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification: charts.OutsideJustification.start,
                innerPadding: 25,
                
              ),
              new charts.ChartTitle(
                'Categories',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification: charts.OutsideJustification.middleDrawArea
              ),
              new charts.ChartTitle(
                'Attendees',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification: charts.OutsideJustification.middleDrawArea
              ),
            ],
          ),
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF51DE93), Color(0xFFFFB540), Color(0xFFFA4169)],
              stops: [
                0.0,
                0.4,
                1.0,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
        ),
      ),
    );
  }

  Widget drawLineGraph() {
    return Container(
      height: 150.0,
      child: charts.LineChart(
        series,
        animate: true,
        defaultRenderer: charts.LineRendererConfig(
          includeArea: true,
          includePoints: true,
          includeLine: true,
          stacked: false,
        ),
        domainAxis: charts.NumericAxisSpec( 
          renderSpec: charts.SmallTickRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 12,
            labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.deepOrange.shadeDefault,
              fontSize: 10,
            ),
            axisLineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.deepOrange.shadeDefault
            ),
          ),
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          showAxisLine: false,
          renderSpec: charts.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 12,
            labelStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.deepOrange.shadeDefault,
              fontSize: 10
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.deepOrange.shadeDefault
            ),
            axisLineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.deepOrange.shadeDefault
            ),
          ),
        ),
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

                  SizedBox(height: 40,),
                      
                  PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 5000),
                    chartLegendSpacing: 40,
                    chartRadius: 150,
                    colorList: pieChartColors,
                    centerText: 10.toString(),
                    initialAngleInDegree: -90,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 60,
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.left,
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
                      showChartValuesOutside: true,
                    ),
                  ),

                  SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.9,
                        child: AutoSizeText(
                          "Figure shows category wise events count in a pie diagram with total event count at center.",
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 30,),
                  buildBarGraph(),
                  SizedBox(height: 30,),
                  //drawLineGraph()

                  Center(
                    child: Container(
                      color: BACKGROUND,
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: BezierChart(
                        bezierChartScale: BezierChartScale.CUSTOM,
                        xAxisCustomValues: const [0, 5, 10, 15, 20, 25, 30, 35],
                        
                        series: const [
                          BezierLine(
                            data: const [
                              DataPoint<double>(value: 10, xAxis: 0),
                              DataPoint<double>(value: 130, xAxis: 5),
                              DataPoint<double>(value: 50, xAxis: 10),
                              DataPoint<double>(value: 150, xAxis: 15),
                              DataPoint<double>(value: 75, xAxis: 20),
                              DataPoint<double>(value: 0, xAxis: 25),
                              DataPoint<double>(value: 5, xAxis: 30),
                              DataPoint<double>(value: 45, xAxis: 35),
                            ],
                          ),
                        ],
                        config: BezierChartConfig(
                          verticalIndicatorStrokeWidth: 3.0,
                          verticalIndicatorColor: Colors.black26,
                          showVerticalIndicator: true,
                          backgroundColor: Colors.red,
                          snap: false,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}