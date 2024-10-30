class EventModel {

  // ignore: non_constant_identifier_names
  final String image_url; 
  final String title;
  final String description; 
  final String date; 
  final String time; 
  final bool pay; 
  final String type; 
  final String localgoogleurl;

  EventModel({
    // ignore: non_constant_identifier_names
    required this.image_url,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.pay,
    required this.type,
    required this.localgoogleurl,
  }); 

  factory EventModel.fromMap(Map<String, dynamic> map) {
     return EventModel(
        image_url: map['image_url'],
        title: map['title'], 
        description: map['description'],
        date: map['date'],
        time: map['time'],
        pay: map['pay'], 
        type: map['type'],        
        localgoogleurl: map['localgoogleurl'],
    );
  }

}
