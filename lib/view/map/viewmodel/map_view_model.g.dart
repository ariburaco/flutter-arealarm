// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GoogleMapViewModel on _GoogleMapViewModelBase, Store {
  final _$countAtom = Atom(name: '_GoogleMapViewModelBase.count');

  @override
  int get count {
    _$countAtom.reportRead();
    return super.count;
  }

  @override
  set count(int value) {
    _$countAtom.reportWrite(value, super.count, () {
      super.count = value;
    });
  }

  final _$pinLocationIconAtom =
      Atom(name: '_GoogleMapViewModelBase.pinLocationIcon');

  @override
  BitmapDescriptor? get pinLocationIcon {
    _$pinLocationIconAtom.reportRead();
    return super.pinLocationIcon;
  }

  @override
  set pinLocationIcon(BitmapDescriptor? value) {
    _$pinLocationIconAtom.reportWrite(value, super.pinLocationIcon, () {
      super.pinLocationIcon = value;
    });
  }

  final _$markersAtom = Atom(name: '_GoogleMapViewModelBase.markers');

  @override
  Set<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(Set<Marker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  final _$circlesAtom = Atom(name: '_GoogleMapViewModelBase.circles');

  @override
  Set<Circle> get circles {
    _$circlesAtom.reportRead();
    return super.circles;
  }

  @override
  set circles(Set<Circle> value) {
    _$circlesAtom.reportWrite(value, super.circles, () {
      super.circles = value;
    });
  }

  final _$currentPositionAtom =
      Atom(name: '_GoogleMapViewModelBase.currentPosition');

  @override
  LatLng? get currentPosition {
    _$currentPositionAtom.reportRead();
    return super.currentPosition;
  }

  @override
  set currentPosition(LatLng? value) {
    _$currentPositionAtom.reportWrite(value, super.currentPosition, () {
      super.currentPosition = value;
    });
  }

  final _$selectedPlacesAtom =
      Atom(name: '_GoogleMapViewModelBase.selectedPlaces');

  @override
  List<MapPlace> get selectedPlaces {
    _$selectedPlacesAtom.reportRead();
    return super.selectedPlaces;
  }

  @override
  set selectedPlaces(List<MapPlace> value) {
    _$selectedPlacesAtom.reportWrite(value, super.selectedPlaces, () {
      super.selectedPlaces = value;
    });
  }

  final _$selectedPlaceAtom =
      Atom(name: '_GoogleMapViewModelBase.selectedPlace');

  @override
  MapPlace? get selectedPlace {
    _$selectedPlaceAtom.reportRead();
    return super.selectedPlace;
  }

  @override
  set selectedPlace(MapPlace? value) {
    _$selectedPlaceAtom.reportWrite(value, super.selectedPlace, () {
      super.selectedPlace = value;
    });
  }

  final _$radiusAtom = Atom(name: '_GoogleMapViewModelBase.radius');

  @override
  double get radius {
    _$radiusAtom.reportRead();
    return super.radius;
  }

  @override
  set radius(double value) {
    _$radiusAtom.reportWrite(value, super.radius, () {
      super.radius = value;
    });
  }

  final _$addPlaceToDBAsyncAction =
      AsyncAction('_GoogleMapViewModelBase.addPlaceToDB');

  @override
  Future<void> addPlaceToDB() {
    return _$addPlaceToDBAsyncAction.run(() => super.addPlaceToDB());
  }

  final _$getCurrenPositionAsyncAction =
      AsyncAction('_GoogleMapViewModelBase.getCurrenPosition');

  @override
  Future<void> getCurrenPosition() {
    return _$getCurrenPositionAsyncAction.run(() => super.getCurrenPosition());
  }

  final _$_GoogleMapViewModelBaseActionController =
      ActionController(name: '_GoogleMapViewModelBase');

  @override
  void navigateToPosition(LatLng pos) {
    final _$actionInfo = _$_GoogleMapViewModelBaseActionController.startAction(
        name: '_GoogleMapViewModelBase.navigateToPosition');
    try {
      return super.navigateToPosition(pos);
    } finally {
      _$_GoogleMapViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deletePlace() {
    final _$actionInfo = _$_GoogleMapViewModelBaseActionController.startAction(
        name: '_GoogleMapViewModelBase.deletePlace');
    try {
      return super.deletePlace();
    } finally {
      _$_GoogleMapViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeRadius(Circle _circle) {
    final _$actionInfo = _$_GoogleMapViewModelBaseActionController.startAction(
        name: '_GoogleMapViewModelBase.changeRadius');
    try {
      return super.changeRadius(_circle);
    } finally {
      _$_GoogleMapViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic moveToBounderies() {
    final _$actionInfo = _$_GoogleMapViewModelBaseActionController.startAction(
        name: '_GoogleMapViewModelBase.moveToBounderies');
    try {
      return super.moveToBounderies();
    } finally {
      _$_GoogleMapViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToCurrentPosition() {
    final _$actionInfo = _$_GoogleMapViewModelBaseActionController.startAction(
        name: '_GoogleMapViewModelBase.navigateToCurrentPosition');
    try {
      return super.navigateToCurrentPosition();
    } finally {
      _$_GoogleMapViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addMapPlaces(MapPlace currentMapPlace) {
    final _$actionInfo = _$_GoogleMapViewModelBaseActionController.startAction(
        name: '_GoogleMapViewModelBase.addMapPlaces');
    try {
      return super.addMapPlaces(currentMapPlace);
    } finally {
      _$_GoogleMapViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
count: ${count},
pinLocationIcon: ${pinLocationIcon},
markers: ${markers},
circles: ${circles},
currentPosition: ${currentPosition},
selectedPlaces: ${selectedPlaces},
selectedPlace: ${selectedPlace},
radius: ${radius}
    ''';
  }
}
