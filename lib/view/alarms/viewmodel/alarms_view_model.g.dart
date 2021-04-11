// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarms_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AlarmsViewModel on _AlarmsViewModelBase, Store {
  Computed<bool>? _$hasActiveAlarmComputed;

  @override
  bool get hasActiveAlarm =>
      (_$hasActiveAlarmComputed ??= Computed<bool>(() => super.hasActiveAlarm,
              name: '_AlarmsViewModelBase.hasActiveAlarm'))
          .value;
  Computed<int>? _$alarmCountComputed;

  @override
  int get alarmCount =>
      (_$alarmCountComputed ??= Computed<int>(() => super.alarmCount,
              name: '_AlarmsViewModelBase.alarmCount'))
          .value;

  final _$isLoadingAtom = Atom(name: '_AlarmsViewModelBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$alarmListAtom = Atom(name: '_AlarmsViewModelBase.alarmList');

  @override
  List<Alarm> get alarmList {
    _$alarmListAtom.reportRead();
    return super.alarmList;
  }

  @override
  set alarmList(List<Alarm> value) {
    _$alarmListAtom.reportWrite(value, super.alarmList, () {
      super.alarmList = value;
    });
  }

  final _$getAlarmListAsyncAction =
      AsyncAction('_AlarmsViewModelBase.getAlarmList');

  @override
  Future<void> getAlarmList() {
    return _$getAlarmListAsyncAction.run(() => super.getAlarmList());
  }

  final _$deleteAllAlarmsAsyncAction =
      AsyncAction('_AlarmsViewModelBase.deleteAllAlarms');

  @override
  Future<void> deleteAllAlarms() {
    return _$deleteAllAlarmsAsyncAction.run(() => super.deleteAllAlarms());
  }

  final _$_AlarmsViewModelBaseActionController =
      ActionController(name: '_AlarmsViewModelBase');

  @override
  void changeLoading() {
    final _$actionInfo = _$_AlarmsViewModelBaseActionController.startAction(
        name: '_AlarmsViewModelBase.changeLoading');
    try {
      return super.changeLoading();
    } finally {
      _$_AlarmsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
alarmList: ${alarmList},
hasActiveAlarm: ${hasActiveAlarm},
alarmCount: ${alarmCount}
    ''';
  }
}
