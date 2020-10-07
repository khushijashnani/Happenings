import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/models/attendee.dart';
import 'package:uvento/models/organisation.dart';
import 'package:uvento/pages/AttendeeHomeScreen.dart';
import 'package:uvento/pages/OrganisationProfile.dart';
import 'package:uvento/pages/MyEvents.dart';

class Home extends StatefulWidget {
  Attendee attendee;
  Organisation organisation;
  Home({Key key, this.attendee, this.organisation}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String type = '';
  int currentIndex = 0;
  PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String uid;
  int _page = 0;
  final profileRefresh = ChangeNotifier();
  var _pageOption;
  @override
  void initState() {
    super.initState();
    if (widget.attendee != null) {
      print("attendee");
      type = ATTENDEE;
    } else {
      print("organisation");
      type = ORGANISATION;
    }
    _pageController = PageController();
  }

  getBottomNav() {
    return type == ATTENDEE
        ? BottomNavyBar(
            backgroundColor: Color(0xff102733),
            selectedIndex: _page,
            showElevation: true,
            itemCornerRadius: 20,
            curve: Curves.easeInBack,
            onItemSelected: (index) => setState(() {
              _page = index;
              // _pageController.animateToPage(index,
              //     duration: Duration(milliseconds: 1000), curve: Curves.ease);
            }),
            items: [
              BottomNavyBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                  activeColor: Colors.yellow[800],
                  textAlign: TextAlign.center,
                  inactiveColor: Colors.white),
              BottomNavyBarItem(
                  icon: Icon(Icons.explore),
                  title: Text('Explore'),
                  activeColor: Colors.yellow[800],
                  textAlign: TextAlign.center,
                  inactiveColor: Colors.white),
              BottomNavyBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text('Account'),
                  activeColor: Colors.yellow[800],
                  textAlign: TextAlign.center,
                  inactiveColor: Colors.white),
            ],
          )
        : BottomNavyBar(
            backgroundColor: Color(0xff102733),
            selectedIndex: _page,
            showElevation: true,
            itemCornerRadius: 20,
            curve: Curves.easeInBack,
            onItemSelected: (index) => setState(() {
              _page = index;
              // _pageController.animateToPage(index,
              //     duration: Duration(milliseconds: 1000), curve: Curves.ease);
            }),
            items: [
              BottomNavyBarItem(
                  icon: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                  activeColor: Colors.yellow[800],
                  textAlign: TextAlign.center,
                  inactiveColor: Colors.white),
              BottomNavyBarItem(
                  icon: Icon(Icons.explore),
                  title: Text('Explore'),
                  activeColor: Colors.yellow[800],
                  textAlign: TextAlign.center,
                  inactiveColor: Colors.white),
              BottomNavyBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text('Account'),
                  activeColor: Colors.yellow[800],
                  textAlign: TextAlign.center,
                  inactiveColor: Colors.white),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff102733),
        bottomNavigationBar: getBottomNav(),
        body: IndexedStack(
            index: _page,
            children: type == ATTENDEE
                ? <Widget>[
                    AttendeeHomeScreen(name: widget.attendee.name),
                    Container(
                      child: Center(child: Text("SEARCH")),
                    ),
                    Container(
                      child: Center(child: Text("PROFILE")),
                    )
                  ]
                : <Widget>[

                    AttendeeHomeScreen(name:widget.organisation.name),
                    // Container(
                    //   child: Center(child: Text("SEARCH")),
                    // ),
                    
                    EventsList(id:widget.organisation.id,type:type),
                    OrganisationProfile(organisation: widget.organisation),
                    // Container(
                    //   child: Center(child: Text("PROFILE")),
                    // )
                  ]),
      ),
    );
  }
}
