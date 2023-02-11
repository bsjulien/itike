class Destination {
  int? id;
  String? startPoint;
  String? endPoint;
  String? startTime;
  String? endTime;
  int? price;
  Null? createdAt;
  Null? updatedAt;

  Destination(
      {this.id,
      this.startPoint,
      this.endPoint,
      this.startTime,
      this.endTime,
      this.price,
      this.createdAt,
      this.updatedAt});

  // map json to destination model

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
        id: json['id'],
        startPoint: json['start_point'],
        endPoint: json['end_point'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        price: json['price'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
}
