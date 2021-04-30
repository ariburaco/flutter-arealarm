import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/base/model/base_view_model.dart';
import '../../utils/provider/alarm_provider.dart';

part 'map_view_model.g.dart';

class GoogleMapViewModel = _GoogleMapViewModelBase with _$GoogleMapViewModel;

abstract class _GoogleMapViewModelBase with Store, BaseViewModel {
  @override
  void init() {}

  @override
  void setContext(BuildContext context) {
    this.context = context;
    Provider.of<AlarmProvider>(context, listen: true).context = context;
  }
}
