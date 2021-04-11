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

  final _$markersAtom = Atom(name: '_GoogleMapViewModelBase.markers');

  @override
  ObservableSet<Marker> get markers {
    _$markersAtom.reportRead();
    return super.markers;
  }

  @override
  set markers(ObservableSet<Marker> value) {
    _$markersAtom.reportWrite(value, super.markers, () {
      super.markers = value;
    });
  }

  final _$circlesAtom = Atom(name: '_GoogleMapViewModelBase.circles');

  @override
  ObservableSet<Circle> get circles {
    _$circlesAtom.reportRead();
    return super.circles;
  }

  @override
  set circles(ObservableSet<Circle> value) {
    _$circlesAtom.reportWrite(value, super.circles, () {
      super.circles = value;
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

  final _$addPlaceAsyncAction = AsyncAction('_GoogleMapViewModelBase.addPlace');

  @override
  Future<void> addPlace(
      LatLng position, BuildContext context, AnimationController _controller) {
    return _$addPlaceAsyncAction
        .run(() => super.addPlace(position, context, _controller));
  }

  final _$_GoogleMapViewModelBaseActionController =
      ActionController(name: '_GoogleMapViewModelBase');

  @override
  void onMarkerTapped(MarkerId markerId) {
    final _$actionInfo = _$_GoogleMapViewModelBaseActionController.startAction(
        name: '_GoogleMapViewModelBase.onMarkerTapped');
    try {
      return super.onMarkerTapped(markerId);
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
  String toString() {
    return '''
count: ${count},
markers: ${markers},
circles: ${circles},
radius: ${radius}
    ''';
  }
}
