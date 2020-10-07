import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uvento/home.dart';
import 'package:uvento/models/event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';

class EventForm extends StatefulWidget {
  int org_id;
  EventForm({Key key, this.org_id}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _eventFormKey = GlobalKey<FormState>();
  TextEditingController title;
  TextEditingController desc;
  TextEditingController entryamount;
  DateTime startDate;
  DateTime endDate;
  TextEditingController location;
  String category;
  TextEditingController speciality;
  String imageUrl;
  File image;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    title = TextEditingController();
    desc = TextEditingController();
    location = TextEditingController();
    category = "Others";
    speciality = TextEditingController();
    entryamount = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xff102733),
      body: loading
          ? Center(child:CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "New Event",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 150,
                    width: 200,
                    color: image != null ? Colors.transparent : Colors.grey,
                    child: Center(
                      child: image != null
                          ? Image.file(
                              image,
                              fit: BoxFit.fill,
                            )
                          : GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        title: Text(
                                          'Select an Image',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xff102733),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        children: <Widget>[
                                          Divider(
                                            thickness: 2,
                                            indent: 20,
                                            endIndent: 20,
                                          ),
                                          SimpleDialogOption(
                                              child: Text(
                                                "Camera",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                _pickImage(ImageSource.camera);
                                              }),
                                          SimpleDialogOption(
                                              child: Text(
                                                "Gallery",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                _pickImage(ImageSource.gallery);
                                              }),
                                          SimpleDialogOption(
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Upload image")
                                ],
                              ),
                            ),
                    ),
                  ),
                  Form(
                    key: _eventFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: TextFormField(
                              maxLines: 1,
                              controller: title,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a title for your event';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.title, color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  //icon: Icon(Icons.title, color: Colors.white),
                                  hintText: "Title",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: TextFormField(
                              maxLines: 2,
                              controller: desc,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a description for your event';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.description,
                                      color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  //icon: Icon(Icons.title, color: Colors.white),
                                  hintText: "Description",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: TextFormField(
                              maxLines: 1,
                              controller: location,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a location for your event';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.location_on,
                                      color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  //icon: Icon(Icons.title, color: Colors.white),
                                  hintText: "Location",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.fromLTRB(30, 10, 20, 10),
                                    child: Text(
                                      "Start Date :",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                Container(
                                    child: Text(
                                        startDate.day.toString() +
                                            "/" +
                                            startDate.month.toString() +
                                            "/" +
                                            startDate.year.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15))),
                              ],
                            ),
                            Expanded(
                          child:Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                                child: RaisedButton(
                                  splashColor: Color(0xff102733),
                                  color: Colors.yellow[800],
                                  child: Text("Change",
                                      style: TextStyle(
                                          color:  Color(0xff102733),
                                          fontSize: 15)),
                                  onPressed: () async {
                                    DateTime d = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2021)) ??
                                        DateTime.now();
                                    setState(() {
                                      startDate = d;
                                    });
                                  },
                                )),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding:
                                        EdgeInsets.fromLTRB(30, 10, 30, 10),
                                    child: Text(
                                      "End Date :",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                Container(
                                    child: Text(
                                        endDate.day.toString() +
                                            "/" +
                                            endDate.month.toString() +
                                            "/" +
                                            endDate.year.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15))),
                              ],
                            ),
                            Expanded(
                          child:Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                                child: RaisedButton(
                                  splashColor: Color(0xff102733),
                                  color: Colors.yellow[800],
                                  child: Text(
                                    "Change",
                                    style: TextStyle(
                                        color: Color(0xff102733),
                                        fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    DateTime d = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2021)) ??
                                        DateTime.now();
                                    setState(() {
                                      endDate = d;
                                    });
                                  },
                                )),)
                          ],
                        ),

                        Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: TextFormField(
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              controller: entryamount,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an entry amount for your event';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: FaIcon(FontAwesomeIcons.moneyBill, color: Colors.grey,),
                                      //Icon(Icons.account_balance_wallet, color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  //icon: Icon(Icons.title, color: Colors.white),
                                  hintText: "Entry Amount",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            )),
                        //   ],
                        // )
                        Container(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: TextFormField(
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              controller: speciality,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter a speciality for your event';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.label_important,
                                      color: Colors.grey),
                                  border: new OutlineInputBorder(
                                    
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(color: Colors.yellow[800]),
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  //icon: Icon(Icons.title, color: Colors.white),
                                  hintText: "Speciality",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            )),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Container(
                            width : 140,
                            padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                            child: Text("Category :",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          Expanded(
                          child:Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(color: Colors.yellow[800]),
                                  ),
                              ),
                              hint: Text(
                                "Category",
                              ),
                              items: <String>[
                                'Technical',
                                'Sports',
                                'Medical',
                                'Education',
                                'Concert',
                                'Others'
                              ].map<DropdownMenuItem<String>>((String value) {
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
                          ),)
                        ]),
                        Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                            child: FlatButton(
                                splashColor: Colors.yellow[800],
                                textColor: Colors.yellow[800],
                                onPressed: () {
                                  addEvent();
                                },
                                child: Container(
                                  width: 100,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            ),
    ));
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop();
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      image = selected;
    });
  }

  Future<void> addEvent() async {
    if (_eventFormKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      final String picture1 =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      FirebaseStorage storage =  FirebaseStorage.instance;
      StorageUploadTask task1 = storage.ref().child(picture1).putFile(image);
      task1.onComplete.then((snapshot) async {
        String url = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
        print(url);
        print("valid");
        Event e = Event(
            title: title.text,
            category: category,
            description: desc.text,
            startDate: startDate,
            endDate: endDate,
            imageUrl: imageUrl,
            location: location.text,
            speciality: speciality.text,
            entryamount: int.parse(entryamount.text));
        print(e.category);
        print(e.description);
        print(e.endDate);
        print(e.speciality);
        print(e.startDate);
        print(e.id);
        print(e.imageUrl);
        print(e.location);
        print(e.title);
        var data = e.toJson();
        data.putIfAbsent('org_id', () => widget.org_id);
        print(data);
        Map<String, String> headers = {
          "Content-type": "application/json",
          "Accept": "application/json",
          "charset": "utf-8"
        };
        var response = await http.post('https://rpk-happenings.herokuapp.com/event',
            headers: headers, body: json.encode(data));
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "Event posted successfully.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);
          setState(() {
            loading = false;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Home(type: ORGANISATION,)));
        } else {
          print("not");
          Fluttertoast.showToast(
              msg: "Please try again...",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);
        }
    
      }).catchError((e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
      });
    } else if (image == null) {
      Fluttertoast.showToast(
          msg: "Please upload an image for your event...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    } else {
      Fluttertoast.showToast(
          msg: "Please enter the rest of the details ...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      return;
    }
   
  }
}
