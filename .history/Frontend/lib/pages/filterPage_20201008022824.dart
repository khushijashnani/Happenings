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
  double screenWidth, screenHeight, height = 40;
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
            color: Colors.white,
            child: InkWell(
              onTap: (){
                setState(() {
                  height = 200;
                });
              },
              child: AnimatedContainer(
                width: screenWidth * 0.9,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  //borderRadius: ,
                ),
                // Define how long the animation should take.
                duration: Duration(seconds: 2),
                // Provide an optional curve to make the animation feel smoother.
                curve: Curves.fastOutSlowIn,
              ),
            ),
          ),
        )

            // Container(
            // child : DraggableScrollableSheet(
            //   initialChildSize: 0.1,
            //   minChildSize: 0.1,
            //   maxChildSize: 0.8,
            //   builder: (BuildContext context, ScrollController scrollController){
            //     return Container(
            //       color: Colors.white,
            //       child: ListView.builder(
            //         controller: scrollController,
            //         itemCount: 20,
            //         itemBuilder: (BuildContext context, int index){
            //           return ListTile(title : Text('Item $index'),);
            //         }),
            //     );
            //   },
            // ))
        // Container(
        //     height: 50,
        //     margin: EdgeInsets.fromLTRB(20,10,20,10),
        //     alignment: Alignment.centerRight,
        //     child: Material(
        //       borderRadius: BorderRadius.all(Radius.circular(20)),
        //       color: Colors.yellow[800],
        //       elevation: 5,
        //       child: InkWell(
        //           child: Container(
        //             alignment: Alignment.center,
        //               height: 50,
        //               width: screenWidth/3,
        //               child: Text("Search",style: GoogleFonts.raleway(
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.bold,
        //                   color: BACKGROUND,
        //                 )))),
        //     ))
      ],
    ));
  }
}
