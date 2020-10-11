import 'package:flutter/material.dart';
import 'package:uvento/models/date_model.dart';
import 'package:uvento/models/event_type_model.dart';
import 'package:uvento/models/events_model.dart';

List<DateModel> getDates() {
  List<DateModel> dates = new List<DateModel>();
  DateTime current_date = DateTime.now();
  DateModel dateModel = new DateModel();

  //1
  dateModel.date = "10";
  dateModel.weekDay = "Sun";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "11";
  dateModel.weekDay = "Mon";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "12";
  dateModel.weekDay = "Tue";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "13";
  dateModel.weekDay = "Wed";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "14";
  dateModel.weekDay = "Thu";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "15";
  dateModel.weekDay = "Fri";
  dates.add(dateModel);

  dateModel = new DateModel();

  //1
  dateModel.date = "16";
  dateModel.weekDay = "Sat";
  dates.add(dateModel);

  dateModel = new DateModel();

  return dates;
}

List<EventTypeModel> getEventTypes() {
  List<EventTypeModel> events = new List();
  EventTypeModel eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.local_hospital,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/concert.png";
  eventModel.eventType = "Health & Wellness";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.photo,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/sports.png";
  eventModel.eventType = "Photography";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = null;
  eventModel.imgAssetPath = "assets/concert.png";
  eventModel.eventType = "Cultural";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.sports_football,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Outdoor & Adventure";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.laptop_chromebook_outlined,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Tech";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = null;
  eventModel.imgAssetPath = "assets/sports.png";
  eventModel.eventType = "Sports";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = null;
  eventModel.imgAssetPath = "assets/concert.png";
  eventModel.eventType = "Music & Arts";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.people_alt_outlined,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Social";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = null;
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Educational";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.games,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Sci-fi & Games";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.business,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Career & Business";
  events.add(eventModel);

  eventModel = new EventTypeModel();
  eventModel.icon = Icon(Icons.arrow_forward,color: Colors.yellow[800],size: 27,);
  eventModel.imgAssetPath = "assets/education.png";
  eventModel.eventType = "Others";
  events.add(eventModel);

  return events;
}

List<EventsModel> getEvents() {
  List<EventsModel> events = new List<EventsModel>();
  EventsModel eventsModel = new EventsModel();

  //1
  eventsModel.imgeAssetPath = "assets/tileimg.png";
  eventsModel.date = "Jan 12, 2019";
  eventsModel.desc = "Sports Meet in Galaxy Field";
  eventsModel.address = "Greenfields, Sector 42, Faridabad";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //2
  eventsModel.imgeAssetPath = "assets/second.png";
  eventsModel.date = "Jan 12, 2019";
  eventsModel.desc = "Art & Meet in Street Plaza";
  eventsModel.address = "Galaxyfields, Sector 22, Faridabad";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  //3
  eventsModel.imgeAssetPath = "assets/music_event.png";
  eventsModel.date = "Jan 12, 2019";
  eventsModel.address = "Galaxyfields, Sector 22, Faridabad";
  eventsModel.desc = "Youth Music in Gwalior";
  events.add(eventsModel);

  eventsModel = new EventsModel();

  return events;
}
