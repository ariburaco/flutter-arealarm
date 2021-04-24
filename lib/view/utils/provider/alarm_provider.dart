import 'dart:async';
import '../../../core/base/extension/context_extension.dart';
import 'package:flutter/cupertino.dart';
import '../../map/model/map_place_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../alarms/model/alarms_model.dart';
import '../database/database_manager.dart';

class AlarmProvider extends ChangeNotifier {
  List<Alarm>? alarmList = [];
  Alarm? nearestAlarm;
  bool hasActiveAlarm = false;
  bool addMarkerProcces = false;
  Position? currentPosition;
  bool focusPlaces = false;
  StreamSubscription<Position>? positionStream;

//
  int count = 0;
  List<Marker> markers = [];
  List<Circle> circles = [];
  BuildContext? context;
  List<MapPlace> selectedPlaces = [];
  GoogleMapController? mapController;
  BitmapDescriptor? pinLocationIcon;
  MapPlace? selectedPlace;
  bool isSelectedPlaceAlive = false;
  double radius = 50;

  AnimationController? animationController;

  void changeFocus(bool val) {
    focusPlaces = val;
    notifyListeners();
  }

  Future<List<Alarm>> getAlarmList() async {
    alarmList = await DatabaseManager.instance.getAlarmList();
    alarmList =
        alarmList!.where((element) => element.isAlarmActive == 1).toList();

    if (currentPosition != null)
      calculateDistanceToAlarmPlaces(currentPosition);
    else
      getCurrentPosition();

    count = await getAlarmCount();
    if (count > 0) {
      hasActiveAlarm = true;
    } else
      hasActiveAlarm = false;

    updateMarkersFromDB();
    notifyListeners();
    return alarmList!;
  }

  Future<void> deleteSelectedAlarm(Alarm selectedAlarm) async {
    var alarmPlaceMatches = selectedPlaces
        .where((element) => (selectedAlarm.alarmId == element.id));

    if (alarmPlaceMatches.isNotEmpty) {
      var alarmPlaceMatch = alarmPlaceMatches.first;

      selectedAlarm.isAlarmActive = 0;
      await updateAlarm(selectedAlarm.alarmId!, selectedAlarm);

      var matchedCircle = circles.where((element) =>
          (element.circleId.value == alarmPlaceMatch.circle.circleId.value));
      var matchedMarker = markers.where((element) =>
          (element.markerId.value == alarmPlaceMatch.marker.markerId.value));

      if (matchedMarker.length > 0 && matchedCircle.length > 0) {
        circles.remove(matchedCircle.first);
        markers.remove(matchedMarker.first);
        deleteSelectedMapPlace(alarmPlaceMatch.id);
        selectedPlaces.remove(alarmPlaceMatch);
      }
    } else {
      selectedAlarm.isAlarmActive = 0;
      await updateAlarm(selectedAlarm.alarmId!, selectedAlarm);
    }

    checkSelectedIsPlaceAddedToDB();
    animationController!.forward();
    notifyListeners();
  }

  void updateMarkersFromDB() {
    if (addMarkerProcces == false) {
      Marker? missingMarker;
      for (var marker in markers) {
        var matchedAlarm = alarmList!.where(
            (element) => marker.markerId.value == "place_${element.alarmId}");

        if (matchedAlarm.length == 0) {
          missingMarker = marker;
        }
      }

      if (missingMarker != null) {
        markers.remove(missingMarker);
        print("Deleted Alarmplace Marker is: ${missingMarker.markerId}");
      }

      Circle? missingCircle;
      for (var circle in circles) {
        var matchedAlarm = alarmList!.where(
            (element) => circle.circleId.value == "place_${element.alarmId}");

        if (matchedAlarm.length == 0) {
          missingCircle = circle;
        }
      }

      if (missingCircle != null) {
        circles.remove(missingCircle);
        print("Deleted Alarmplace Circle is: ${missingCircle.circleId}");
      }

      // for (var circle in circles) {
      //   var matchedAlarm = alarmList!.where(
      //       (element) => circle.circleId.value == "place_${element.alarmId}");

      //   if (matchedAlarm.length == 0) {
      //     circles.remove(circle);
      //     print("Deleted Alarmplace Circle is: ${circle.circleId}");
      //   }
      // }
    }
    notifyListeners();
  }

  Future<void> deleteAllAlarms() async {
    if (alarmList != null) {
      for (var alarms in alarmList!) {
        deleteSelectedAlarm(alarms);
      }
      markers.clear();
      circles.clear();
      animationController!.forward();
      stopLocationStream();
      // await BackgroundServiceManager.instance.stopAllAlarmServices();
      notifyListeners();
    }
  }

  Future<int> getAlarmCount() async {
    return await DatabaseManager.instance.getAlarmCount();
  }

  Future<void> deleteSelectedMapPlace(int alarmId) async {
    Alarm alarm = (await DatabaseManager.instance.getAlarm(alarmId))!;
    // BackgroundServiceManager.instance.removeAlarmFromBGService(alarm);
    alarm.isAlarmActive = 0;
    await updateAlarm(alarmId, alarm);
    // await DatabaseManager.instance.deleteAlarm(alarmId);
    await moveToBounderies();
    await getAlarmList();
  }

  Future<void> addAlarmToDB(Alarm newAlarm) async {
    await DatabaseManager.instance.addAlarm(newAlarm);
    //await addAlarmAddedToBG(newAlarm);
    await getAlarmList();
    resumeLocationStreamStatus();

    // await addActiveAlarmsToBGService();
    //addAlarmAddedToBG(newAlarm);
  }

  Future<void> updateAlarm(int id, Alarm newAlarm) async {
    final result = await DatabaseManager.instance.updateAlarm(id, newAlarm);
    if (result) await getAlarmList();
  }

  Future<void> addAlarmAddedToBG(Alarm newAlarm) async {
    //  await BackgroundServiceManager.instance.addAlarmToBGService(newAlarm);
  }

  // Future<void> addActiveAlarmsToBGService() async {
  //   if (alarmList != null) if (alarmList!.isNotEmpty)
  //     await BackgroundServiceManager.instance.checkExistensAlarms(alarmList!);
  // }

  void resumeLocationStreamStatus() {
    if (positionStream != null) {
      if (positionStream!.isPaused) {
        positionStream!.resume();
        print("RESUME THE STREAM");
      }
    } else {
      startLocationStream();
    }
    notifyListeners();
  }

  void startLocationStream() {
    if (alarmList!.length > 0) {
      if (positionStream == null) {
        positionStream = Geolocator.getPositionStream(
                desiredAccuracy: LocationAccuracy.bestForNavigation,
                distanceFilter: 0,
                intervalDuration: Duration(seconds: 5))
            .listen((Position? position) {
          if (position != null) {
            currentPosition = position;

            getAlarmList();
            //establishExistentAlarms();
            moveToBounderies();
          }
        });
      } else {
        positionStream!.resume();
      }
    } else {
      stopLocationStream();
    }
  }

  Future<void> stopLocationStream() async {
    if (positionStream != null) {
      await positionStream!.cancel();
      positionStream = null;
      print("CANCEL THE STREAM");
    }
  }

  Future<void> calculateDistanceToAlarmPlaces(Position? currentPosition) async {
    if (currentPosition == null) {
      currentPosition = (await Geolocator.getLastKnownPosition())!;
    }
    for (var alarms in alarmList!) {
      alarms.distance = Geolocator.distanceBetween(alarms.lat!, alarms.long!,
          currentPosition.latitude, currentPosition.longitude);
    }
    if (alarmList!.isNotEmpty) {
      alarmList!.sort((a, b) => a.distance!.compareTo(b.distance!));
      nearestAlarm = alarmList!.first;
    }
    notifyListeners();
  }

  /////////////////////////////////// Map View Provider ///////////////////////////////////
  ///

  Future<void> establishExistentAlarms() async {
    final existentAlarms = await getAlarmList();
    // await addActiveAlarmsToBGService();

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
            animationController!.reverse();
            onMarkerTapped(MarkerId(name));
            //print(markers[0].markerId);
          },
          icon: pinLocationIcon!);
      Circle circle = new Circle(
          circleId: CircleId(name),
          center: position,
          radius: radius,
          strokeWidth: 4,
          fillColor: context!.colors.onPrimary.withOpacity(0.2),
          strokeColor: context!.colors.secondaryVariant);

      markers.add(marker);
      circles.add(circle);

      final alarmToMapPlace =
          MapPlace(id, name, position, circle, marker, radius, address);

      selectedPlaces.add(alarmToMapPlace);
      notifyListeners();
    }
  }

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

      addAlarmToDB(newAlarm);
    } else {
      // TODO Show Snackbar Alarm Added or Not!
    }
    addMarkerProcces = false;
    checkSelectedIsPlaceAddedToDB();
    notifyListeners();
  }

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

      // BackgroundServiceManager.instance.updateAlarmFromBGService(newAlarm);
      updateAlarm(selectedPlace!.id, newAlarm);
    } else {
      // TODO Show Snackbar Alarm Updated or Not!
    }
    checkSelectedIsPlaceAddedToDB();
    notifyListeners();
  }

  Future<Alarm?> checkSelectedIsPlaceAddedToDB() async {
    var currentList = await getAlarmList();

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

  void navigateToPosition(LatLng pos) {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(pos));
    }
  }

  Future<void> addPlaceMarker(LatLng position, BuildContext context) async {
    addMarkerProcces = true;
    animationController!.reverse();
    count++;
    String placeId = "place_$count";
    Marker marker = new Marker(
        markerId: MarkerId(placeId),
        position: position,
        zIndex: 14,
        //TODO add GeoCode API to InfoWindow
        //infoWindow: InfoWindow(title: "at $position"),
        onTap: () {
          animationController!.reverse();
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
    moveToBounderies();

    notifyListeners();
  }

  void onMarkerTapped(MarkerId markerId) {
    //List<Marker> markers = getMarkers().toList();

    var matchedPlace = selectedPlaces
        .where((element) => (element.marker.markerId.value == markerId.value));

    if (matchedPlace.length > 0) {
      selectedPlace = matchedPlace.first;
      radius = selectedPlace!.radius;
      print("selected place radius: $radius");
    } else {
      print("No Match for marker");
    }
    checkSelectedIsPlaceAddedToDB();

    notifyListeners();
  }

  void removeAlarmAndPlace() {
    if (selectedPlace != null) {
      var matchedCircle = circles.where((element) =>
          (element.circleId.value == selectedPlace!.circle.circleId.value));
      var matchedMarker = markers.where((element) =>
          (element.markerId.value == selectedPlace!.marker.markerId.value));

      if (matchedMarker.length > 0 && matchedCircle.length > 0) {
        circles.remove(matchedCircle.first);
        markers.remove(matchedMarker.first);
        deleteSelectedMapPlace(selectedPlace!.id);
        selectedPlaces.remove(selectedPlace);
      }
    }

    checkSelectedIsPlaceAddedToDB();
  }

  Future<void> deletePlace() async {
    if (selectedPlace != null) {
      var isMatch = await checkSelectedIsPlaceAddedToDB();
      //print("isMatch" + isMatch!.placeName!);
      if (isMatch == null) {
        var matchedCircle = circles.where((element) =>
            (element.circleId.value == selectedPlace!.circle.circleId.value));
        var matchedMarker = markers.where((element) =>
            (element.markerId.value == selectedPlace!.marker.markerId.value));

        if (matchedMarker.length > 0 && matchedCircle.length > 0) {
          circles.remove(matchedCircle.first);
          markers.remove(matchedMarker.first);
        }
        count--;
      }
    }
    checkSelectedIsPlaceAddedToDB();
  }

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
    notifyListeners();
  }

  Future<LatLngBounds> _bounds(Set<Marker> markers) async {
    var markerPositions = markers.map((m) => m.position).toList();
    if (positionStream != null) {
      if (positionStream!.isPaused) {
        await getCurrentPosition();
      }
    }
    if (currentPosition != null) markerPositions.add(currentPosition!.latlng);

    return _createBounds(markerPositions);
  }

  Future<void> moveToBounderies() async {
    if (focusPlaces) {
      if (markers.isNotEmpty) {
        var bounds = await _bounds(markers.toSet());
        double padding = markers.length == 0 ? 200 : 100;
        await mapController!
            .animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
      } else {
        navigateToCurrentPosition();
      }
    }
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

  Future<void> navigateToCurrentPosition() async {
    await getCurrentPosition();
    if (mapController != null) {
      if (currentPosition != null) {
        mapController!
            .animateCamera(CameraUpdate.newLatLng(currentPosition!.latlng));
      }
    }
  }

  void addMapPlaces(MapPlace currentMapPlace) {
    if (pinLocationIcon != null) {
      selectedPlaces.add(currentMapPlace);
    } else {
      print("icon not found!");
    }
    notifyListeners();
  }

  Future<void> mapsInit(GoogleMapController mapController,
      AnimationController _animationController) async {
    this.mapController = mapController;
    animationController = _animationController;
    await setCustomMapPin();
    await establishExistentAlarms();
    await getAlarmCount();
    if (count > 0) startLocationStream();
    await moveToBounderies();
    notifyListeners();
  }

  Future<LatLng> getCurrentPosition() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    notifyListeners();
    return currentPosition!.latlng;
  }

  Future<void> setCustomMapPin() async {
    final ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context!);
    var bitmap = await BitmapDescriptor.fromAssetImage(
        imageConfiguration, 'assets/imgs/loc.png');
    pinLocationIcon = bitmap;
    notifyListeners();
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
