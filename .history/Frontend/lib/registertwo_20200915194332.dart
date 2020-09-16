import 'package:flutter/material.dart';

class RegisterPart2 extends StatefulWidget {
  String imageUrl;
  RegisterPart2({this.imageUrl});

  @override
  _RegisterPart2State createState() => _RegisterPart2State(imageUrl: imageUrl);
}

class _RegisterPart2State extends State<RegisterPart2> {

  String imageUrl;
  _RegisterPart2State({this.imageUrl});

  TextEditingController usernameController;
  TextEditingController passController;
  TextEditingController nameController;
  TextEditingController addressController;
  TextEditingController ageController;
  TextEditingController emailController;
  TextEditingController phoneController;
  bool passvis = true;
  final _signupFormKey = GlobalKey<FormState>();
  final _scaffoldKey1 = GlobalKey<ScaffoldState>();
  String name = "", username = "", password = "", address = "", age = "", email = "", phone = "", gender = "Male";
  String image = "";
  double screenWidth, screenHeight;

  @override
  void initState() {
    print(imageUrl);
    usernameController = TextEditingController();
    passController = TextEditingController();
    nameController = TextEditingController();
    ageController = TextEditingController();
    addressController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    setState(() {
      image = imageUrl;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    
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
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: screenWidth - 180,
                              child: TextFormField(
                                maxLines: 1,
                                controller: nameController,
                                onChanged: (value) => name = value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelStyle: TextStyle(color: Colors.yellow[600]),
                                  //icon: Icon(Icons.person, color: Colors.white),
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.grey)
                                ),
                              )
                            ),

                            SizedBox(height: 10,),

                            Container(
                              width: screenWidth - 180,
                              child: TextFormField(
                                maxLines: 1,
                                controller: usernameController,
                                onChanged: (value) => username = value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_pin, color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelStyle: TextStyle(color: Colors.yellow[600]),
                                  //icon: Icon(Icons.person, color: Colors.white),
                                  hintText: "Userame",
                                  hintStyle: TextStyle(color: Colors.grey)
                                ),
                              )
                            )
                          ],
                        ),
                        image == "" ? 
                        Container(
                          width:  90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              //colorFilter: new ColorFilter.mode(Colors.white, BlendMode.srcOver),
                              image: AssetImage(
                                "assets/profilepic.jpg"
                              ),
                            ),
                          ),
                          child:  Center(),
                        ) : 
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(45)),
                            child: Image.network(
                              imageUrl,
                              height: 90,
                              width : 90,
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded /loadingProgress.expectedTotalBytes : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 15,),

                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        obscureText: passvis,
                        
                        maxLines: 1,
                        controller: passController,
                        onChanged: (value) => password = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                          suffix: Padding(
                            padding:EdgeInsets.fromLTRB(0, 0, 2, 0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  passvis = !passvis;
                                });
                              },
                              child: Icon(passvis ? Icons.visibility : Icons.visibility_off, color: Colors.white,)
                            )
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ),

                    SizedBox(height: 15,),

                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        maxLines: 1,
                        controller: addressController,
                        onChanged: (value) => address = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Address';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_on, color: Colors.grey),
                          
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Address",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ),

                    SizedBox(height: 15,),

                    Row(
                      children: [
                        Container(
                          width: screenWidth*0.3,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: ageController,
                            onChanged: (value) => age = value,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Age';
                              }
                              return null;
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.perm_contact_calendar, color: Colors.grey),
                              
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              labelStyle: TextStyle(color: Colors.yellow[600]),
                              //icon: Icon(Icons.person, color: Colors.white),
                              hintText: "Age",
                              hintStyle: TextStyle(color: Colors.grey)
                            ),
                          )
                        ),

                        Row(
                          children: [
                            Radio(
                              value: "Male",
                              groupValue: gender,
                              onChanged: (value){
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                            Text(
                              'Male',
                              style: new TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                            Radio(
                              value: "Female",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value;
                                });
                              },
                            ),
                            Text(
                              'Female',
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    SizedBox(height: 15,),

                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        controller: phoneController,
                        onChanged: (value) => phone = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your Contact Number';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Colors.grey),
                          
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Phone",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ),
                    
                    SizedBox(height: 15,),

                    Container(
                      width: screenWidth - 60,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                        onChanged: (value) => email = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email id';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email, color: Colors.grey),
                          
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          labelStyle: TextStyle(color: Colors.yellow[600]),
                          //icon: Icon(Icons.person, color: Colors.white),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.grey)
                        ),
                      )
                    ),

                    SizedBox(height: 15,),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(100))
                      ),
                      height: 60,
                      
                      width: screenWidth - 60,
                      child: InkWell(
                        hoverColor: Colors.grey[700],
                        onTap: (){
                          register();
                        },
                        child: Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.yellow[600],
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void register() async {
    if (_signupFormKey.currentState.validate()){

      print(email);
      print(password);
      print(gender);
      print(address);
      print(phone);
      print(name);
      print(username);
      print(age);

    }
  }
}