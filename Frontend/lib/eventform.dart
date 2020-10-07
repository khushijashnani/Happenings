import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uvento/constants.dart';
import 'package:uvento/home.dart';
import 'package:uvento/models/event.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'constants.dart';

class EventForm extends StatefulWidget {
  int org_id;
  Event e;
  EventForm({Key key, this.org_id, this.e}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _eventFormKey = GlobalKey<FormState>();
  TextEditingController title;
  TextEditingController desc;
  TextEditingController entryamount;
  TextEditingController maxCount;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
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

    image = null;
    if (widget.e == null) {
      startDate = DateTime.now();
      endDate = DateTime.now();
      title = TextEditingController();
      desc = TextEditingController();
      maxCount = TextEditingController();
      location = TextEditingController();
      category = "Others";
      speciality = TextEditingController();
      entryamount = TextEditingController();
      startTime = TimeOfDay.now();
      endTime = TimeOfDay.now();
    } else {
      print(widget.e.maxCount);
      startDate = widget.e.startDate;
      endDate = widget.e.endDate;
      title = TextEditingController(text: widget.e.title);
      desc = TextEditingController(text: widget.e.description);
      location = TextEditingController(text: widget.e.location);
      category = widget.e.category;
      speciality = TextEditingController(text: widget.e.speciality);
      entryamount =
          TextEditingController(text: widget.e.entryamount.toString());
      startTime = TimeOfDay(
          hour: widget.e.startDate.hour, minute: widget.e.startDate.minute);
      endTime = TimeOfDay(
          hour: widget.e.endDate.hour, minute: widget.e.endDate.minute);
      maxCount = TextEditingController(text: widget.e.maxCount.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xff102733),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(25),
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            )),
                        widget.e == null
                            ? Text(
                                "New Event",
                                style: GoogleFonts.raleway(
                                    color: Colors.yellow[800],
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "Update Event",
                                style: GoogleFonts.raleway(
                                    color: Colors.yellow[800],
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
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
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            );
                          });
                    },
                    child: Container(
                        decoration: new BoxDecoration(
                          color: image != null || widget.e != null
                              ? Colors.transparent
                              : Colors.grey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(30),
                          //border: Border.all(width: 4.0, color: Colors.yellow[800]),
                        ),
                        padding: EdgeInsets.all(20),
                        height: 150,
                        width: MediaQuery.of(context).size.width - 100,
                        child: Center(
                            child: widget.e == null
                                ? image != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                            Image.file(
                                              image,
                                              fit: BoxFit.fill,
                                            ),
                                            Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: GestureDetector(
                                                  child: Text(
                                                      "Click here to \nchange again",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Colors.yellow,
                                                          decorationThickness:
                                                              1)),
                                                ))
                                          ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.add_a_photo),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Upload an image")
                                        ],
                                      )
                                : image == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                            Image.network(
                                              widget.e.imageUrl,
                                              fit: BoxFit.fill,
                                            ),
                                            Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: GestureDetector(
                                                  child: Text(
                                                      "Click here to \nchange again",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Colors.yellow,
                                                          decorationThickness:
                                                              1)),
                                                ))
                                          ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                            Image.file(
                                              image,
                                              fit: BoxFit.fill,
                                            ),
                                            Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: GestureDetector(
                                                  child: Text(
                                                      "Click here to \nchange again",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Colors.yellow,
                                                          decorationThickness:
                                                              1)),
                                                ))
                                          ]))),
                  ),
                  Form(
                    key: _eventFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Material(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: CARD,
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: Container(
                                  decoration: BoxDecoration(
                                    //border: Border.all(color: Colors.yellow[800]),
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
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
                                        prefixIcon: Icon(Icons.title,
                                            color: Colors.grey),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(25.0),
                                          borderSide: new BorderSide(
                                              color: Colors.yellow[800]),
                                        ),
                                        //labelStyle: TextStyle(color: Colors.white),
                                        //icon: Icon(Icons.title, color: Colors.white),
                                        hintText: "Title",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  )),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Material(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: CARD,
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: Container(
                                  decoration: BoxDecoration(
                                    //border: Border.all(color: Colors.yellow[800]),
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
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
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        //icon: Icon(Icons.title, color: Colors.white),
                                        hintText: "Description",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  )),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Material(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: CARD,
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: Container(
                                  decoration: BoxDecoration(
                                    //border: Border.all(color: Colors.yellow[800]),
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
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
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        //icon: Icon(Icons.title, color: Colors.white),
                                        hintText: "Location",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  )),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(30, 10, 20, 10),
                                  child: Text(
                                    "Start :",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              // Column(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              // children: [
                              Container(
                                  child: Text(
                                      startDate.day.toString() +
                                          "/" +
                                          startDate.month.toString() +
                                          "/" +
                                          startDate.year.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15))),
                              Text("  at  ",
                                  style: TextStyle(
                                      color: Colors.yellow[800], fontSize: 15)),
                              Container(
                                  child: Text(
                                      startTime.hour
                                              .toString()
                                              .padLeft(2, '0') +
                                          ":" +
                                          startTime.minute
                                              .toString()
                                              .padLeft(2, '0'),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15)))
                              // ])
                            ]),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
                                    child: Material(
                                      elevation: 5,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      color: Colors.black,
                                      child: InkWell(
                                          onTap: () async {
                                            DateTime d = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2021)) ??
                                                DateTime.now();
                                            TimeOfDay t = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            d = d.add(Duration(
                                                hours: t.hour,
                                                minutes: t.minute));
                                            setState(() {
                                              startDate = d;
                                              startTime = t;
                                            });
                                            print(d);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                              color: Colors.yellow[800],
                                            ),
                                            child: Text("Change",
                                                style: TextStyle(
                                                    color: Color(0xff102733),
                                                    fontSize: 15)),
                                          )),
                                    )))
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
                                      "End :",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                                // Row(children: [
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
                                Text("  at  ",
                                    style: TextStyle(
                                        color: Colors.yellow[800],
                                        fontSize: 15)),
                                Container(
                                    child: Text(
                                        endTime.hour
                                                .toString()
                                                .padLeft(2, '0') +
                                            ":" +
                                            endTime.minute
                                                .toString()
                                                .padLeft(2, '0'),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)))
                                // ])
                              ],
                            ),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
                                    child: Material(
                                      elevation: 5,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      color: Colors.yellow[800],
                                      child: InkWell(
                                          onTap: () async {
                                            DateTime d = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2021)) ??
                                                DateTime.now();
                                            TimeOfDay t = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            d = d.add(Duration(
                                                hours: t.hour,
                                                minutes: t.minute));
                                            setState(() {
                                              endDate = d;
                                              endTime = t;
                                            });
                                            print(d);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25)),
                                              color: Colors.yellow[800],
                                            ),
                                            child: Text(
                                              "Change",
                                              style: TextStyle(
                                                  color: Color(0xff102733),
                                                  fontSize: 15),
                                            ),
                                          )),
                                    )))
                          ],
                        ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Material(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: CARD,
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: Container(
                                  decoration: BoxDecoration(
                                    //border: Border.all(color: Colors.yellow[800]),
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
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
                                        prefixIcon: //FaIcon(FontAwesomeIcons.moneyBill, color: Colors.grey,),
                                            Icon(Icons.account_balance_wallet,
                                                color: Colors.grey),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(25.0),
                                          borderSide: new BorderSide(),
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        //icon: Icon(Icons.title, color: Colors.white),
                                        hintText: "Entry Amount",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  )),
                            )),
                        //   ],
                        // )
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Material(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: CARD,
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: Container(
                                  decoration: BoxDecoration(
                                    //border: Border.all(color: Colors.yellow[800]),
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
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
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        //icon: Icon(Icons.title, color: Colors.white),
                                        hintText: "Speciality",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  )),
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Material(
                              borderRadius: new BorderRadius.circular(25.0),
                              color: CARD,
                              elevation: 5,
                              shadowColor: Colors.black,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    color: CARD,
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    controller: maxCount,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter a max count for your event';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.people,
                                            color: Colors.grey),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(25.0),
                                        ),
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        //icon: Icon(Icons.title, color: Colors.white),
                                        hintText: "Max count",
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  )),
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                padding: EdgeInsets.fromLTRB(30, 5, 10, 5),
                                child: Text("Category :",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17)),
                              ),
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 10),
                                      child: Material(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        color: CARD,
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(15, 5, 10, 5),
                                          decoration: BoxDecoration(
                                            //border: Border.all(color: Colors.yellow[800]),
                                            borderRadius:
                                                new BorderRadius.circular(25.0),
                                            color: CARD,
                                          ),
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        25.0),
                                              ),
                                            ),
                                            hint: Text(
                                              "Category",
                                            ),
                                            items: <String>[
                                              'Health & Wellness',
                                              'Photography',
                                              'Cultural',
                                              'Outdoor & Adventure',
                                              'Tech',
                                              'Sports',
                                              'Music & Arts',
                                              'Social',
                                              'Educational',
                                              'Sci-fi & Games',
                                              'Career & Business',
                                              'Others',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
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
                                        ),
                                      )))
                            ]),
                        Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                            child: Material(
                                elevation: 5,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Colors.yellow[800],
                                child: InkWell(
                                    onTap: () {
                                      addEvent();
                                    },
                                    splashColor: Colors.yellow[800],
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 150,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        color: Colors.yellow[800],
                                      ),
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: Text(
                                            widget.e == null ? "Add" : "Update",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: BACKGROUND),
                                          )),
                                    ))))
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
    print(image.toString());
  }

  Future<void> addEvent() async {
    if (widget.e == null) {
      print("e is null");
      if (_eventFormKey.currentState.validate()) {
        setState(() {
          loading = true;
        });
        final String picture1 =
            "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        FirebaseStorage storage = FirebaseStorage.instance;
        StorageUploadTask task1 = storage.ref().child(picture1).putFile(image);
        task1.onComplete.then((snapshot) async {
          String url = await snapshot.ref.getDownloadURL();
          setState(() {
            imageUrl = url;
          });
          print(url);
          print("valid");
          var data = {
            "title": title.text,
            "category": category,
            "description": desc.text,
            "start_date": startDate.toString(),
            "end_date": endDate.toString(),
            "image": imageUrl,
            "location": location.text,
            "speciality": speciality.text,
            "max_count": int.parse(maxCount.text),
            "entry_amount": int.parse(entryamount.text),
            "org_id": widget.org_id
          };
          print(data);
          Map<String, String> headers = {
            "Content-type": "application/json",
            "Accept": "application/json",
            "charset": "utf-8"
          };
          var response = await http.post(
              'https://rpk-happenings.herokuapp.com/event',
              headers: headers,
              body: json.encode(data));
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
                    builder: (context) => Home(
                          type: ORGANISATION,
                        )));
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
    } else {
      if (_eventFormKey.currentState.validate()) {
        setState(() {
          loading = true;
        });
        print("e is not null");
        if (image != null) {
          final String picture1 =
              "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          FirebaseStorage storage = FirebaseStorage.instance;
          StorageUploadTask task1 =
              storage.ref().child(picture1).putFile(image);
          task1.onComplete.then((snapshot) async {
            String url = await snapshot.ref.getDownloadURL();
            setState(() {
              imageUrl = url;
              widget.e.imageUrl = url;
            });
            print(url);
            api();
          }).catchError((e) {
            Fluttertoast.showToast(
                msg: e.toString(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM);
          });
        } else {
          api();
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please enter the rest of the details ...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM);
        return;
      }
    }
  }

  void api() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "charset": "utf-8"
    };
    widget.e.title = title.text;
    widget.e.description = desc.text;
    widget.e.location = location.text;
    widget.e.speciality = speciality.text;
    widget.e.entryamount = int.parse(entryamount.text);
    widget.e.startDate = startDate;
    widget.e.endDate = endDate;
    widget.e.category = category;
    widget.e.maxCount = int.parse(maxCount.text);
    print(widget.e.category);
    print(widget.e.description);
    print(widget.e.endDate);
    print(widget.e.speciality);
    print(widget.e.startDate);
    print(widget.e.id);
    print(widget.e.imageUrl);
    print(widget.e.location);
    print(widget.e.title);
    print(widget.e.maxCount);
    print(widget.e.currentCount);
    var data = widget.e.toJson();
    var id = data['id'];
    data.remove('id');
    data.putIfAbsent('event_id', () => id);
    var response = await http.put('https://rpk-happenings.herokuapp.com/event',
        headers: headers, body: json.encode(data));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Event updated successfully.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    type: ORGANISATION,
                  )));
    } else {
      print("not");
      Fluttertoast.showToast(
          msg: "Please try again...",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM);
    }
  }
}
