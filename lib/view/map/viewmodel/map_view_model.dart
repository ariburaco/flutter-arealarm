import 'package:flutter/material.dart';
import 'package:flutter_template/view/map/model/map_place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'map_view_model.g.dart';

class GoogleMapViewModel = _GoogleMapViewModelBase with _$GoogleMapViewModel;

abstract class _GoogleMapViewModelBase with Store, BaseViewModel {
  @observable
  int count = 0;

  GoogleMapController mapController;

  @observable
  BitmapDescriptor pinLocationIcon;

  @observable
  Set<Marker> markers = {};

  @observable
  Set<Circle> circles = {};

  @observable
  LatLng currentPosition;

  @observable
  List<MapPlace> selectedPlaces = [];

  @override
  void init() {}

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @action
  void navigateToPosition(LatLng pos) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    }
  }

  LatLngBounds _bounds(Set<Marker> markers) {
    if (markers == null || markers.isEmpty) return null;
    return _createBounds(markers.map((m) => m.position).toList());
  }

  @action
  moveToBounderies() {
    mapController
        .animateCamera(CameraUpdate.newLatLngBounds(_bounds(markers), 100));
  }

  LatLngBounds _createBounds(List<LatLng> positions) {
    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);
    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  @action
  void navigateToCurrentPosition() {
    getCurrenPosition();
    if (mapController != null) {
      if (currentPosition != null) {
        mapController.animateCamera(CameraUpdate.newLatLng(currentPosition));
      }
    }
  }

  @action
  void addMapPlaces(MapPlace currentMapPlace) {
    if (pinLocationIcon != null) {
      selectedPlaces.add(currentMapPlace);
      count++;
    } else {
      print("************************************icon not found!");
    }
  }

  Future<void> mapsInit(GoogleMapController controller) async {
    this.mapController = controller;
    await setCustomMapPin();
  }

  @action
  Future<void> getCurrenPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    currentPosition = position.latlng;
  }

  Future<void> setCustomMapPin() async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    var bitmap = await BitmapDescriptor.fromAssetImage(
        imageConfiguration, 'assets/imgs/loc.png');
    pinLocationIcon = bitmap;
  }

  void addMarker() {
    if (pinLocationIcon != null) {
      markers.add(Marker(
          markerId: MarkerId("marker_$count"),
          position: currentPosition,
          zIndex: 10,
          infoWindow: InfoWindow(title: "at $currentPosition"),
          icon: pinLocationIcon));
      count++;
      print(
          "************************************ marker_$count added at $currentPosition ");
    } else {
      print("************************************icon not found!");
    }
  }

  // void addMarkerConstant(LatLng pos) {
  //   addMapPlaces("place", pos, 100);

  //   //mapController.getVisibleRegion();
  // }
}

extension ConvertToLatLng on Position {
  LatLng get latlng => new LatLng(this.latitude, this.longitude);
}
