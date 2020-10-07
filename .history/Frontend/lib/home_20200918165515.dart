import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
    _pageController = PageController();
    _pageOption =  [
      // MenuDashBoard(uid:uid, notifier: profileRefresh,),
      // Exploration(uid:uid),
      // Admission(uid:uid),
      // ProfilePage(uid: uid, notifier: profileRefresh,)

    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Scaffold(
         body: ,
       ),
    );
  }
}