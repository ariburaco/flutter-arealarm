class Alarm {
  String? alarmId;
  int? isAlarmActive;
  String? placeName;
  double? lat;
  double? long;
  double? radius;
  String? address;

  Alarm(
      {this.alarmId,
      this.isAlarmActive,
      this.placeName,
      this.lat,
      this.long,
      this.radius,
      this.address});

  Alarm.fromJson(Map<String, dynamic> json) {
    alarmId = json['alarmId'];
    isAlarmActive = json['isAlarmActive'];
    placeName = json['placeName'];
    lat = json['latitude'];
    long = json['longitude'];
    radius = json['radius'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alarmId'] = this.alarmId;
    data['isAlarmActive'] = this.isAlarmActive;
    data['placeName'] = this.placeName;
    data['latitude'] = this.lat;
    data['longitude'] = this.long;
    data['radius'] = this.radius;
    data['address'] = this.address;
    return data;
  }
}
