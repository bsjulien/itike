class Ticket {
  int? id;
  int? userId;
  String? date;
  String? time;
  String? startpoint;
  String? endpoint;
  int? price;

  Ticket(
      {this.id,
      this.userId,
      this.date,
      this.time,
      this.startpoint,
      this.endpoint,
      this.price});

  //function to convert json data to user model
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['name'],
      date: json['date'],
      time: json['time'],
      startpoint: json['start_point'],
      endpoint: json['end_point'],
      price: json['price'],
    );
  }
}
