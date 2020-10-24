import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvento/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AttendeeList extends StatefulWidget {
  String event_id;
  DateTime startDate;
  DateTime endDate;
  AttendeeList({Key key, this.startDate, this.endDate, this.event_id})
      : super(key: key);

  @override
  _AttendeeListState createState() => _AttendeeListState();
}

class _AttendeeListState extends State<AttendeeList> {
  List<String> urls;
  List names = [];
  List encodings = [];
  DateTime d;
  bool loading = false;
  File image;
  String imageUrl;
  List status = [];
  String name = '';
  bool recognising = false;

  getAttendees() async {
    setState(() {
      loading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int event_id = int.parse(widget.event_id);
    var registers = await http.get(
        'https://rpk-happenings.herokuapp.com/validate_attendee/${event_id}',
        headers: {"Authorization": sharedPreferences.getString("token")});
    if (registers.statusCode == 200) {
      var data = json.decode(registers.body);
      setState(() {
        names = data['names'];
        status = data['status'];
      });
      print(names);
      print(status);
    } else {}
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    d = DateTime.now();
    getAttendees();
    //status = new List<bool>.filled(names.length,false, growable: false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          backgroundColor: BACKGROUND,
          // appBar: AppBar(
          //   title: Text("Attendees"),
          //   backgroundColor: BACKGROUND,
          // ),
          body: loading == true
              ? Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Loading Attendees",
                          style: GoogleFonts.raleway(
                              color: Colors.white, fontSize: 20)),
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator()
                    ],
                  ))
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
                                Text(
                                  "Attendee List",
                                  style: GoogleFonts.raleway(
                                      color: Colors.yellow[800],
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 500,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 100,
                              // physics: FixedExtentScrollPhysics(),
                              childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: names.length,
                                  builder: (context, index) {
                                    return Container(
                                        width: screenWidth,
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),
                                        child: Material(
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          color: CARD,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                  color: CARD),
                                              child: Center(
                                                child: ListTile(
                                                  title: Text(names[index],
                                                      style:
                                                          GoogleFonts.raleway(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16)),
                                                  trailing: InkWell(
                                                    //   onTap: () {
                                                    //     print("hello");
                                                    //     _pickImage(ImageSource.camera);
                                                    // setState(() {
                                                    //   showName = true;
                                                    // });
                                                    //   },
                                                    child: status[index]
                                                        ? Icon(
                                                            Icons.check_circle,
                                                            size: 30,
                                                            color: Colors.green)
                                                        : Container(
                                                            height: 0,
                                                            width: 0),
                                                  ),
                                                  leading: Icon(Icons.person,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ));
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
          floatingActionButton:
              d.isAfter(widget.startDate) && d.isBefore(widget.endDate)
                  ?
              FloatingActionButton.extended(
                  backgroundColor: YELLOW,
                  onPressed: () {
                    validate();
                  },
                  label: Text("Validate"))
          : Container(),
          ),
    );
  }

  Future<void> validate() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = selected;
      recognising = true;
    });
    print(recognising);
    if (image != null) {
      final String picture1 =
          "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageUploadTask task1 = storage.ref().child(picture1).putFile(image);
      task1.onComplete.then((snapshot) async {
        String url = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = url;
        });
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        Map<String, String> headers = {
          "Content-type": "application/json",
          "Accept": "application/json",
          "charset": "utf-8",
          "Authorization": sharedPreferences.getString("token")
        };
        Map data = {"url": imageUrl};

        var validate = await http.post(
            'https://rpk-happenings.herokuapp.com/validate_attendee/${int.parse(widget.event_id)}',
            headers: headers,
            body: json.encode(data));
        if (validate.statusCode == 200) {
          var data = json.decode(validate.body);
          setState(() {
            name = data['name'];
          });
          for (int i = 0; i < names.length; i++) {
            if (names[i].toString().toLowerCase() == name.toLowerCase()) {
              setState(() {
                status[i] = true;
              });
            }
          }
          Fluttertoast.showToast(
              msg: "Successfully recognised the Attendee as\n${name}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM);
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => AttendeeList(event_id : widget.event_id, startDate: widget.startDate,endDate: widget.endDate,)));
        } else {
          Fluttertoast.showToast(msg: validate.body);
        }
      });
    }
    setState(() {
      recognising = false;
    });
    print(recognising);
  }
}
