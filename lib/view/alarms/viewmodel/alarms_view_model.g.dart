// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarms_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AlarmsViewModel on _AlarmsViewModelBase, Store {
  final _$hasActiveAlarmAtom =
      Atom(name: '_AlarmsViewModelBase.hasActiveAlarm');

  @override
  bool get hasActiveAlarm {
    _$hasActiveAlarmAtom.reportRead();
    return super.hasActiveAlarm;
  }

  @override
  set hasActiveAlarm(bool value) {
    _$hasActiveAlarmAtom.reportWrite(value, super.hasActiveAlarm, () {
      super.hasActiveAlarm = value;
    });
  }

  final _$alarmCountAtom = Atom(name: '_AlarmsViewModelBase.alarmCount');

  @override
  int get alarmCount {
    _$alarmCountAtom.reportRead();
    return super.alarmCount;
  }

  @override
  set alarmCount(int value) {
    _$alarmCountAtom.reportWrite(value, super.alarmCount, () {
      super.alarmCount = value;
    });
  }

  final _$alarmListAtom = Atom(name: '_AlarmsViewModelBase.alarmList');

  @override
  List<String> get alarmList {
    _$alarmListAtom.reportRead();
    return super.alarmList;
  }

  @override
  set alarmList(List<String> value) {
    _$alarmListAtom.reportWrite(value, super.alarmList, () {
      super.alarmList = value;
    });
  }

  final _$_AlarmsViewModelBaseActionController =
      ActionController(name: '_AlarmsViewModelBase');

  @override
  void addNewAlarm() {
    final _$actionInfo = _$_AlarmsViewModelBaseActionController.startAction(
        name: '_AlarmsViewModelBase.addNewAlarm');
    try {
      return super.addNewAlarm();
    } finally {
      _$_AlarmsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hasActiveAlarm: ${hasActiveAlarm},
alarmCount: ${alarmCount},
alarmList: ${alarmList}
    ''';
  }
}
