class Event {
  String id;
  String title;
  String description;
  int entryamount;
  DateTime startDate;
  DateTime endDate;
  String category;
  String imageUrl;
  String location;
  String speciality;

  Event({
    this.id,
    this.category,
    this.description,
    this.startDate,
    this.endDate,
    this.entryamount,
    this.imageUrl,
    this.location,
    this.speciality,
    this.title
  });
}
