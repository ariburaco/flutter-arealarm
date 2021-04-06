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
  BitmapDescriptor get pinLocationIcon {
    _$pinLocationIconAtom.reportRead();
    return super.pinLocationIcon;
  }

  @override
  set pinLocationIcon(BitmapDescriptor value) {
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

  final _$currentPositionAtom =
      Atom(name: '_GoogleMapViewModelBase.currentPosition');

  @override
  LatLng get currentPosition {
    _$currentPositionAtom.reportRead();
    return super.currentPosition;
  }

  @override
  set currentPosition(LatLng value) {
    _$currentPositionAtom.reportWrite(value, super.currentPosition, () {
      super.currentPosition = value;
    });
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
  String toString() {
    return '''
count: ${count},
pinLocationIcon: ${pinLocationIcon},
markers: ${markers},
currentPosition: ${currentPosition}
    ''';
  }
}
