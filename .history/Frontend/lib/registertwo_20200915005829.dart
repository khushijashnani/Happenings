import 'package:flutter/material.dart';

class RegisterPart2 extends StatefulWidget {
  @override
  _RegisterPart2State createState() => _RegisterPart2State();
}

class _RegisterPart2State extends State<RegisterPart2> {

  TextEditingController usernameController;
  TextEditingController passController;
  bool passvis = true;
  final _signupFormKey = GlobalKey<FormState>();
  final _scaffoldKey1 = GlobalKey<ScaffoldState>();
  String name = '';
  String image = "";
  double screenWidth, screenHeight;

  @override
  void initState() {
    usernameController = TextEditingController();
    passController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenWidth = MediaQuery.of(context).size.height;
    
    return Scaffold(
      key: _scaffoldKey1,
      body: Material(
        color: Color(0xff102733),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: InkWell(
                    child: Icon(
                      Icons.keyboard_backspace, 
                      color: Colors.yellow[600],
                      size: 30,
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 10),
                      child: Image.asset(
                        "assets/logo.png",
                        height: 35,
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 30,right: 30.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "HAPPEN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "INGS",
                            style: TextStyle(
                                color: Color(0xffFFA700),
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                    ),
                  ]
                ),
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0,30, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                      Text(
                        "New Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            "2",
                            style: TextStyle(
                              color: Colors.yellow[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                            ),
                          ),
                          Text(
                            "/2",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                            ),
                          )
                        ],
                      ),
                      Text(
                        "Steps",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            SizedBox(height: 30,),

            Form(
              key: _signupFormKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [

                      ],
                    ),
                    Container(
                      width:  100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: new ColorFilter.mode(Colors.white, BlendMode.srcOver),
                          image: AssetImage(
                            //"assets/Images/Industry Badges/Logistics.jpg",
                            "assets/profile.png"
                          ),
                        ),
                      ),
                      child:  Center(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}