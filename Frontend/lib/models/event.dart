class Event {
  String id;
  String title;
  String description;
  int entryamount; //rangeslider
  DateTime startDate; //datetile
  DateTime endDate; //datetile
  String category; //checkbox
  String imageUrl;
  String location;
  String speciality;
  int maxCount;
  int currentCount;
  String organiser_id;

  Event(
      {this.id,
      this.category,
      this.description,
      this.startDate,
      this.endDate,
      this.entryamount,
      this.imageUrl,
      this.location,
      this.speciality,
      this.maxCount,
      this.currentCount,
      this.title,
      this.organiser_id});

  factory Event.fromMap(Map doc) {
    return Event(
        id: doc['id'],
        title: doc['title'],
        imageUrl: doc['image'],
        category: doc['category'],
        location: doc['location'],
        description: doc['description'],
        startDate: DateTime.parse(doc['start_date']),
        endDate: DateTime.parse(doc['end_date']),
        speciality: doc['speciality'],
        maxCount: int.parse(doc['max_count']),
        currentCount: int.parse(doc['current_count']),
        entryamount: int.parse(doc['entry_amount']),
        organiser_id: doc['organiser_id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate.toString();
    data['end_date'] = this.endDate.toString();
    data['location'] = this.location;
    data['entry_amount'] = this.entryamount;
    data['speciality'] = this.speciality;
    data['image'] = this.imageUrl;
    data['category'] = this.category;
    data['max_count'] = this.maxCount;
    data['current_count'] = this.currentCount;
    data['organiser_id'] = this.organiser_id;
    return data;
  }
}
