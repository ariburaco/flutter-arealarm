import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPlace {
  final String name;
  final LatLng position;
  final Circle circle;
  final Marker marker;
  MapPlace(this.name, this.position, this.circle, this.marker);
}

class MarkerInfoBox {
  final int placeId;
  final MapPlace place;
  final String placeInfo;

  MarkerInfoBox(this.placeId, this.place, this.placeInfo);
}
