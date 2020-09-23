import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/models/attendee.dart';
import 'package:uvento/models/organisation.dart';
import 'package:uvento/pages/AttendeeHomeScreen.dart';
import 'package:uvento/pages/OrganisationProfile.dart';
import 'package:uvento/pages/MyEvents.dart';
import 'package:http/http.dart' as http;

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

  Future<void> getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response2 = await http.get(
        'https://rpk-happenings.herokuapp.com/${type}/' +
            sharedPreferences.getString("id"),
        headers: {"Authorization": sharedPreferences.getString("token")}
      );
      if (response2.statusCode == 200) {
        setState(() {
          loading = false;
        });
        var userDetails = json.decode(response2.body)['user_details'];
        print(userDetails);
        Attendee attendee;
        Organisation organisation;
        if (type == 'ATTENDEE') {
          attendee = Attendee(
              username: userDetails['username'],
              password: userDetails['password'],
              id: userDetails['id'],
              age: userDetails['age'],
              gender: userDetails['gender'],
              name: userDetails['name'],
              phone_no: userDetails['phone_no'],
              address: userDetails['address'],
              imageUrl: userDetails['image'],
              email: userDetails['email_id']);
              
        } else {
          organisation = Organisation(
              username: userDetails['username'],
              password: userDetails['password'],
              id: userDetails['id'],
              details: userDetails['details'],
              subscription: userDetails['subscription'],
              name: userDetails['name'],
              phone_no: userDetails['phone'],
              address: userDetails['address'],
              imageUrl: userDetails['image'],
              email: userDetails['email_id']);
        }
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Home(
                    attendee: attendee,
                    organisation: organisation,
                  )),
                  (route) => false
        );
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
          msg: "Login failed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
        );
        print(response2.body);
      }
  }

  @override
  void initState() {
    super.initState();

    getUserDetails();
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
