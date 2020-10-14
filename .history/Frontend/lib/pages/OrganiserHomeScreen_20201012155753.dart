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

class OrganiserHomeScreen extends StatefulWidget {

  Organisation organisation;
  int revenue, no_of_events, attendees, org_reviews;
  Map pieData, barGraph, lineGraph, groupBarGraph; 
  OrganiserHomeScreen({this.organisation, this.revenue, this.no_of_events, this.attendees, this.org_reviews,
                        this.pieData, this.barGraph, this.lineGraph, this.groupBarGraph});

  @override
  _OrganiserHomeScreenState createState() => _OrganiserHomeScreenState();
}

class _OrganiserHomeScreenState extends State<OrganiserHomeScreen> {

  List<Category> data = [];
  List<EventsAndAttendees> data_line = [];
  List<Sentiment> pos_data = [], neg_data = [];

  var series, series_line, series_group;
  double screenHeight, screenWidth;
  var customTickFormatter;
  Map<String, double> dataMap = new Map();
  final pieChartColors = [
    Color.fromRGBO(82, 98, 255, 1), //  rgb(82, 98, 255)
    Color.fromRGBO(46, 198, 255, 1), // rgb(46, 198, 255)
    Color.fromRGBO(123, 201, 82, 1), // rgb(123, 201, 82)
    Color.fromRGBO(255, 171, 67, 1), // rgb(255, 171, 67)
    Color.fromRGBO(252, 91, 57, 1), //  rgb(252, 91, 57)
    Color.fromRGBO(139, 135, 130, 1), //rgb(139, 135, 130)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Pie Chart Data
    var labels = widget.pieData["labels"];
    var pie_data = widget.pieData["data"];
    print(labels);
    print(pie_data);
    setState(() {
      for (int i = 0; i < labels.length; i++) {
        print(labels[i]);
        print(pie_data[i]);
        dataMap[labels[i]] = double.parse(pie_data[i].toString());
      }
    });

    // Categories bar graph data
    var categories_labels = widget.barGraph["labels"];
    var categories_data = widget.barGraph["data"];
    setState(() {
      for (int i = 0; i < categories_labels.length; i++) {
        Category cat = Category(categories_labels[i], categories_data[i]);
        data.add(cat);
      }

      for (int i = 0; i < 7; i++){
        if (data.length >= 6){
          break;
        }
        print("hello");
        Category cat = Category("-", 0);
        data.add(cat);
      }
    });
    series = [
      charts.Series(
        id: 'Attendees',
        //colorFn: () => char
        domainFn: (Category category, _) => category.category,
        measureFn: (Category category, _) => category.attendees,
        data: data,
        labelAccessorFn: (Category category, _) =>
              '${category.attendees.toString()}'
      )
    ];

    // Line Graph Data
    var line_labels = widget.lineGraph["labels"];
    var line_data = widget.lineGraph["data"];
    setState(() {
      for (int i = 0; i < line_labels.length; i++) {
        EventsAndAttendees obj = EventsAndAttendees(i, line_data[i]);
        data_line.add(obj);
      }
    });
    // data_line = [
    //   EventsAndAttendees(0, 200),
    //   EventsAndAttendees(1, 150),
    //   EventsAndAttendees(2, 300),
    //   EventsAndAttendees(3, 100),
    //   EventsAndAttendees(4, 500),
    //   EventsAndAttendees(5, 350)
    // ];

    series_line = [
      charts.Series(
        id: 'Attendees',
        domainFn: (EventsAndAttendees eventsAndAttendees, _) => eventsAndAttendees.event_no,
        measureFn: (EventsAndAttendees eventsAndAttendees, _) => eventsAndAttendees.attendees,
        data: data_line,
        labelAccessorFn: (EventsAndAttendees eventsAndAttendees, _) => "${eventsAndAttendees.attendees}"
      )
    ];

    // Group Bar Graph data
    var sentiment_labels = widget.groupBarGraph["labels"];
    var positive = widget.groupBarGraph["positive"];
    var negative = widget.groupBarGraph["negative"];
    setState(() {
      for (int i = 0; i < sentiment_labels.length; i++) {
        Sentiment sent_pos = Sentiment(sentiment_labels[i], positive[i]);
        Sentiment sent_neg = Sentiment(sentiment_labels[i], negative[i]);
        pos_data.add(sent_pos);
        neg_data.add(sent_neg);
      }
    });
    series_group = [
      charts.Series(
        id: 'Positive',
        domainFn: (Sentiment sentiment, _) => sentiment.event,
        measureFn: (Sentiment sentiment, _) => sentiment.attendees,
        data: pos_data,
        labelAccessorFn: (Sentiment sentiment, _) => "${sentiment.attendees}"
      ),
      charts.Series(
        id: 'Negative',
        domainFn: (Sentiment sentiment, _) => sentiment.event,
        measureFn: (Sentiment sentiment, _) => sentiment.attendees,
        data: neg_data,
        labelAccessorFn: (Sentiment sentiment, _) => "${sentiment.attendees}"
      ),
    ];
  }

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

  Widget buildBarGraph() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 300,
        width: screenWidth * 0.4 + screenWidth * ((data.length) * 0.1),
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
              //colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],//[Color(0xFFFFB540), Color(0xFFFA4169)],
              colors: [Color(0xFF2980B9), Color(0xFF6DD5FA), Color(0xFFffffff)],
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
      height: 300.0,
      width : screenWidth * 0.5 + screenWidth * ((data_line.length) * 0.1),
      child: ShaderMask(
        child: charts.LineChart(
          
          series_line,
          animate: true,
          animationDuration: Duration(milliseconds: 2000),
          defaultRenderer: charts.LineRendererConfig(
            includeArea: true,
            includePoints: true,
            includeLine: true,
            stacked: false,
          ),
          domainAxis: charts.NumericAxisSpec( 
            tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: data_line.length),
            tickFormatterSpec: customTickFormatter,
            renderSpec: charts.SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 10,
              tickLengthPx: 0,
              labelOffsetFromAxisPx: 12,
              //labelRotation: -30,
              labelStyle: charts.TextStyleSpec(
                lineHeight: 2.5,
                color: charts.MaterialPalette.white,
                fontSize: 8,
              ),
              axisLineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.white
              ),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            showAxisLine: false,
            tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: data_line.length - 1),
            renderSpec: charts.GridlineRendererSpec(
              tickLengthPx: 0,
              labelOffsetFromAxisPx: 12,
              labelStyle: charts.TextStyleSpec(
                color: charts.MaterialPalette.white,
                fontSize: 10
              ),
              lineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.white,
              ),
              axisLineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.white,
              ),
            ),
          ),
          behaviors: [
            new charts.SeriesLegend(
                position: charts.BehaviorPosition.top,
                showMeasures: true,
                
                entryTextStyle: charts.TextStyleSpec(
                  color: charts.Color.white
                )
              ),
            new charts.SlidingViewport(),
            new charts.PanAndZoomBehavior(),
            new charts.ChartTitle(
              'Events V/s Attendees',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.start,
              innerPadding: 25,
              titleStyleSpec: charts.TextStyleSpec(
                color: charts.Color.fromHex(code: '#ffffff'), fontWeight: "Bold"
              )
            ),
            new charts.ChartTitle(
              'Events',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
              titleStyleSpec: charts.TextStyleSpec(
                color: charts.MaterialPalette.blue.shadeDefault
              )
            ),
            new charts.ChartTitle(
              'Attendees',
              behaviorPosition: charts.BehaviorPosition.start,
              titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
              titleStyleSpec: charts.TextStyleSpec(
                color: charts.MaterialPalette.blue.shadeDefault
              )
            ),
          ],
        ),
        shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              //colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],//[Color(0xFFFFB540), Color(0xFFFA4169)],Color(0xFF0083B0), 
              colors: [Color(0xFF00d2ff), Color(0xFF56CCF2), Color(0xFFffffff)],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
      ),
    );
  }

  Widget drawGroupGraph() {
    print(series_group.length);
    return Container(
        height: 300,
        width: pos_data.length <= 5 ? screenWidth : screenWidth + screenWidth * ((pos_data.length - 5) * 0.15),
        child: charts.BarChart (
            series_group,
            animate: true,
            animationDuration: Duration(milliseconds: 3000),
            barGroupingType: charts.BarGroupingType.grouped,
            defaultRenderer: new charts.BarRendererConfig(
              //symbolRenderer: charts.CustomSymbolRenderer => Icons.cloud,
              //cornerStrategy: const charts.ConstCornerStrategy(100),
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
              //minBarLengthPx: 10
            ),
            domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.SmallTickRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                  fontSize: 10,
                  color: charts.MaterialPalette.white
                ),
                lineStyle: new charts.LineStyleSpec(
                  color: charts.Color.fromHex(code: '#56CCF2')
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
                  color: charts.Color.fromHex(code: '#56CCF2')
                )
              ),
              showAxisLine: false
            ),
            behaviors: [
              new charts.SeriesLegend(
                position: charts.BehaviorPosition.bottom,
                showMeasures: true,
                
                entryTextStyle: charts.TextStyleSpec(
                  color: charts.Color.white
                )
              ),
              new charts.SlidingViewport(),
              new charts.PanAndZoomBehavior(),
              new charts.ChartTitle(
                'Reviews of Attendees',
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification: charts.OutsideJustification.start,
                innerPadding: 25,
                titleStyleSpec: charts.TextStyleSpec(
                  color: charts.Color.white
                )
              ),
              new charts.ChartTitle(
                'Events',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                titleStyleSpec: charts.TextStyleSpec(
                  color: charts.Color.fromHex(code: '#6DD5FA')
                )
              ),
              new charts.ChartTitle(
                'Attendees',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                titleStyleSpec: charts.TextStyleSpec(
                  color: charts.Color.fromHex(code: '#6DD5FA')
                )
                
              ),
            ],
          ),
      );
  }
  
  @override
  Widget build(BuildContext context) {

    print(widget.pieData);
    print(widget.barGraph);
    print(widget.lineGraph);
    print(widget.groupBarGraph);

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    customTickFormatter =
      charts.BasicNumericTickFormatterSpec((num value) {
        // var d = ;
        return widget.lineGraph["labels"][value.toInt()];
        
      });

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.7, 0.9],
                  colors: [
                    BACKGROUND,
                    Color(0xFF193d50),
                  ],
                ),
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
                                organiserCard(10, 80, 10, 10, "${widget.no_of_events}", "Events", "tL", null),
                                SizedBox(height: 20,),
                                organiserCard(10, 10, 10, 80, "${widget.revenue} +", "Revenue", "bL", FontAwesomeIcons.rupeeSign),
                              ],
                            ),

                            Column(
                              children: [
                                organiserCard(80, 10, 10, 10, "${widget.attendees} +", "Attendees", "tR", FontAwesomeIcons.userFriends),
                                SizedBox(height: 20,),
                                organiserCard(10, 10, 80, 10, "${widget.org_reviews} +", "Reviews", "bR", FontAwesomeIcons.comments),
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
                  Container(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        child: buildBarGraph(),
                      )
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        child: drawLineGraph(),
                      )
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        child: drawGroupGraph(),
                      )
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}