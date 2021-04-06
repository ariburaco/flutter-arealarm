import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPlace {
  final String place;
  final LatLng position;

  MapPlace(this.place, this.position);
}

class MarkerInfoBox {
  final int placeId;
  final MapPlace place;
  final String placeInfo;

  MarkerInfoBox(this.placeId, this.place, this.placeInfo);
}
