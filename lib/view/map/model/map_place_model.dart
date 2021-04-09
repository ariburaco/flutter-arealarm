import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPlace {
  final String name;
  int id;
  LatLng position;
  Circle circle;
  Marker marker;
  double radius;
  String address;

  MapPlace(this.id, this.name, this.position, this.circle, this.marker,
      this.radius, this.address);
}

class MarkerInfoBox {
  final int placeId;
  final MapPlace place;
  final String placeInfo;

  MarkerInfoBox(this.placeId, this.place, this.placeInfo);
}
