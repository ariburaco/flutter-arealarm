class Alarm {
  int? alarmId;
  int? isAlarmActive;
  String? placeName;
  double? lat;
  double? long;
  double? radius;
  String? address;
  double? distance = -1;

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
    distance = json['distance'];
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
    data['distance'] = this.distance;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Alarm &&
        other.alarmId == alarmId &&
        other.isAlarmActive == isAlarmActive &&
        other.placeName == placeName &&
        other.lat == lat &&
        other.long == long &&
        other.radius == radius &&
        other.address == address &&
        other.distance == distance;
  }

  @override
  int get hashCode {
    return alarmId.hashCode ^
        isAlarmActive.hashCode ^
        placeName.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        radius.hashCode ^
        address.hashCode ^
        distance.hashCode;
  }
}
