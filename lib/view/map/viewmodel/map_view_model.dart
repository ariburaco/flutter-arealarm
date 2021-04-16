import 'package:flutter/material.dart';
import '../../../core/base/extension/context_extension.dart';
import '../../utils/provider/alarm_provider.dart';
import 'package:provider/provider.dart';
import '../../alarms/model/alarms_model.dart';
import '../model/map_place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/base/model/base_view_model.dart';
import 'package:mobx/mobx.dart';
part 'map_view_model.g.dart';

class GoogleMapViewModel = _GoogleMapViewModelBase with _$GoogleMapViewModel;

abstract class _GoogleMapViewModelBase with Store, BaseViewModel {
  @observable
  int count = 1;

  GoogleMapController? mapController;

  BitmapDescriptor? pinLocationIcon;

  @observable
  ObservableSet<Marker> markers = ObservableSet();

  @observable
  ObservableSet<Circle> circles = ObservableSet();

  @observable
  LatLng? currentPosition;

  List<MapPlace> selectedPlaces = [];

  @observable
  MapPlace? selectedPlace;

  @observable
  bool isSelectedPlaceAlive = false;

  @observable
  double radius = 50;

  @override
  void init() {
    askLocationPermissions();
    getCurrentPosition();
  }

  Future<void> getAlarmCount() async {
    count = await Provider.of<AlarmProdivder>(context, listen: false)
        .getAlarmCount();
    print("Total Alarm Count! $count ");
  }

  Future<void> establishExistentAlarms(AnimationController _controller) async {
    final existentAlarms =
        await Provider.of<AlarmProdivder>(context, listen: false)
            .getAlarmList();
    await Provider.of<AlarmProdivder>(context, listen: false)
        .addActiveAlarmsToBGService();

    for (var alarm in existentAlarms) {
      int id = alarm.alarmId!;
      String name = "place_$id";
      LatLng position = new LatLng(alarm.lat!, alarm.long!);
      double radius = alarm.radius!;
      String address = alarm.address!;

      Marker marker = new Marker(
          markerId: MarkerId(name),
          position: position,
          zIndex: 14,
          //TODO add GeoCode API to InfoWindow
          //infoWindow: InfoWindow(title: "at $position"),
          onTap: () {
            _controller.reverse();
            onMarkerTapped(MarkerId(name));
            //print(markers[0].markerId);
          },
          icon: pinLocationIcon!);
      Circle circle = new Circle(
          circleId: CircleId(name),
          center: position,
          radius: radius,
          strokeWidth: 4,
          fillColor: context.colors.onPrimary.withOpacity(0.2),
          strokeColor: context.colors.secondaryVariant);

      markers.add(marker);
      circles.add(circle);

      final alarmToMapPlace =
          MapPlace(id, name, position, circle, marker, radius, address);

      selectedPlaces.add(alarmToMapPlace);
    }
  }

  @action
  Future<void> addPlaceToDB() async {
    var isExsist = await checkSelectedIsPlaceAddedToDB();
    if (isExsist == null) {
      Alarm newAlarm = new Alarm(
          alarmId: selectedPlace?.id,
          placeName: selectedPlace?.name,
          isAlarmActive: 1,
          radius: selectedPlace?.radius,
          lat: selectedPlace?.position.latitude,
          long: selectedPlace?.position.longitude,
          address: selectedPlace?.address);

      Provider.of<AlarmProdivder>(context, listen: false)
          .addAlarmToDB(newAlarm);
    } else {
      // TODO Show Snackbar Alarm Added or Not!
    }
    checkSelectedIsPlaceAddedToDB();
  }

  @action
  Future<void> updateSelectedAlarm() async {
    if (isSelectedPlaceAlive) {
      Alarm newAlarm = new Alarm(
          alarmId: selectedPlace?.id,
          placeName: selectedPlace?.name,
          isAlarmActive: 1,
          radius: selectedPlace?.radius,
          lat: selectedPlace?.position.latitude,
          long: selectedPlace?.position.longitude,
          address: selectedPlace?.address);

      Provider.of<AlarmProdivder>(context, listen: false)
          .updateAlarm(selectedPlace!.id, newAlarm);
    } else {
      // TODO Show Snackbar Alarm Updated or Not!
    }
    checkSelectedIsPlaceAddedToDB();
  }

  @action
  Future<Alarm?> checkSelectedIsPlaceAddedToDB() async {
    var currentList = await Provider.of<AlarmProdivder>(context, listen: false)
        .getAlarmList();

    if (selectedPlace == null) return null;

    var isExist =
        currentList.where((element) => element.alarmId == selectedPlace!.id);

    if (isExist.isEmpty) {
      isSelectedPlaceAlive = false;
      return null;
    } else {
      isSelectedPlaceAlive = true;
      return isExist.first;
    }
  }

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  void navigateToPosition(LatLng pos) {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(pos));
    }
  }

  @action
  Future<void> addPlaceMarker(LatLng position, BuildContext context,
      AnimationController _controller) async {
    _controller.reverse();
    navigateToPosition(position);
    String placeId = "place_${count}";
    Marker marker = new Marker(
        markerId: MarkerId(placeId),
        position: position,
        zIndex: 14,
        //TODO add GeoCode API to InfoWindow
        //infoWindow: InfoWindow(title: "at $position"),
        onTap: () {
          _controller.reverse();
          onMarkerTapped(MarkerId(placeId));
          //print(markers[0].markerId);
        },
        icon: pinLocationIcon!);
    Circle circle = new Circle(
        circleId: CircleId(placeId),
        center: position,
        radius: radius,
        strokeWidth: 4,
        fillColor: context.colors.onPrimary.withOpacity(0.2),
        strokeColor: context.colors.secondaryVariant);

    markers.add(marker);
    circles.add(circle);

    MapPlace currentMapPlace =
        new MapPlace(count, placeId, position, circle, marker, radius, "N/A");

    selectedPlace = currentMapPlace;
    addMapPlaces(currentMapPlace);
    await checkSelectedIsPlaceAddedToDB();
    if (selectedPlaces.length > 1) {
      moveToBounderies();
    }
  }

  @action
  void onMarkerTapped(MarkerId markerId) {
    //List<Marker> markers = getMarkers().toList();

    var matchedPlace = selectedPlaces
        .where((element) => (element.marker.markerId.value == markerId.value));

    if (matchedPlace.length > 0) {
      selectedPlace = matchedPlace.first;
      radius = selectedPlace!.radius;
      print("selected place radius: ${radius}");
    } else {
      print("No Match for marker");
    }
    checkSelectedIsPlaceAddedToDB();
  }

  @action
  void removeAlarmAndPlace() {
    if (selectedPlace != null) {
      var matchedCircle = circles.where((element) =>
          (element.circleId.value == selectedPlace!.circle.circleId.value));
      var matchedMarker = markers.where((element) =>
          (element.markerId.value == selectedPlace!.marker.markerId.value));

      if (matchedMarker.length > 0 && matchedCircle.length > 0) {
        circles.remove(matchedCircle.first);
        markers.remove(matchedMarker.first);
        Provider.of<AlarmProdivder>(context, listen: false)
            .deleteSelectedAlarm(selectedPlace!.id.toInt());
        selectedPlaces.remove(selectedPlace);
      }
    }

    checkSelectedIsPlaceAddedToDB();
  }

  @action
  void deletePlace() {
    if (selectedPlace != null) {
      var matchedCircle = circles.where((element) =>
          (element.circleId.value == selectedPlace!.circle.circleId.value));
      var matchedMarker = markers.where((element) =>
          (element.markerId.value == selectedPlace!.marker.markerId.value));

      if (matchedMarker.length > 0 && matchedCircle.length > 0) {
        circles.remove(matchedCircle.first);
        markers.remove(matchedMarker.first);
      }
    }

    checkSelectedIsPlaceAddedToDB();
  }

  @action
  void changeRadius(Circle _circle) {
    if (selectedPlace != null) {
      var matchedCircle = circles.where((element) =>
          (element.circleId.value == selectedPlace!.circle.circleId.value));

      if (matchedCircle.length > 0) {
        circles.remove(matchedCircle.first);
        circles.add(_circle);
      } else {
        print("No Match circle");
      }
    }
  }

  LatLngBounds _bounds(ObservableSet<Marker> markers) {
    var markerPositions = markers.map((m) => m.position).toList();

    getCurrentPosition();
    if (currentPosition != null) markerPositions.add(currentPosition!);
    return _createBounds(markerPositions);
  }

  moveToBounderies() {
    mapController!
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

  void navigateToCurrentPosition() {
    getCurrentPosition();
    if (mapController != null) {
      if (currentPosition != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(currentPosition!));
      }
    }
  }

  void addMapPlaces(MapPlace currentMapPlace) {
    if (pinLocationIcon != null) {
      selectedPlaces.add(currentMapPlace);
      count++;
    } else {
      print("icon not found!");
    }
  }

  Future<void> mapsInit(
      GoogleMapController controller, AnimationController _controller) async {
    this.mapController = controller;

    await setCustomMapPin();
    await establishExistentAlarms(_controller);
    await getAlarmCount();

    if (count > 1) moveToBounderies();
  }

  Future<LatLng> getCurrentPosition() async {
    askLocationPermissions();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    currentPosition = position.latlng;
    return currentPosition!;
  }

  Future<void> setCustomMapPin() async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context);
    var bitmap = await BitmapDescriptor.fromAssetImage(
        imageConfiguration, 'assets/imgs/loc.png');
    pinLocationIcon = bitmap;
  }

  Future<void> askLocationPermissions() async {
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
  }
}

extension ConvertToLatLng on Position {
  LatLng get latlng => new LatLng(this.latitude, this.longitude);
}
