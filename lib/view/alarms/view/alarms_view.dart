import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/base/extension/context_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/components/icons/icon_normal.dart';
import '../../utils/provider/alarm_provider.dart';
import '../viewmodel/alarms_view_model.dart';
import '../widgets/shimmer_text.dart';

class AlarmsView extends StatefulWidget {
  AlarmsView({Key? key}) : super(key: key);

  @override
  _AlarmsViewState createState() => _AlarmsViewState();
}

class _AlarmsViewState extends State<AlarmsView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView<AlarmsViewModel>(
        viewModel: AlarmsViewModel(),
        onModelReady: (viewModel) {
          viewModel.setContext(context);
          viewModel.init();
        },
        onPageBuilder: (BuildContext context, AlarmsViewModel viewModel) =>
            Scaffold(
              //appBar: buildAppBar(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: context.paddingLow,
                    child: buildNextAlarmIndicator(viewModel),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: buildAlarmList(viewModel),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: context.colors.secondaryVariant,
                  child: IconNormal(icon: Icons.delete),
                  onPressed: () async {
                    await Provider.of<AlarmProvider>(context, listen: false)
                        .deleteAllAlarms();
                  }),
            ));
  }

  Widget buildAlarmList(AlarmsViewModel viewModel) {
    if (Provider.of<AlarmProvider>(context, listen: true).alarmList!.length >
        0) {
      return Consumer<AlarmProvider>(
          builder: (_, data, __) => ListView.builder(
                itemCount: data.alarmList!.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentAlarm = data.alarmList![index];

                  final placeName = currentAlarm.alarmId!;
                  // final radius = currentAlarm.radius!.toInt();
                  final address = currentAlarm.address!;
                  final distance = currentAlarm.distance!.toStringAsFixed(2);

                  return Padding(
                    padding: context.paddingLowest,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      decoration: buildBorderRadiusDecoration(context, 10),
                      height: context.highestValue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.location_pin,
                                size: 50,
                                color: context.randomColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    LocaleKeys.alarm.tr() + " #$placeName",
                                    maxLines: 1,
                                    minFontSize: 18,
                                    style: context.textTheme.subtitle2,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    address.toString(),
                                    style: context.textTheme.subtitle1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ShimmerText(
                                    text: distance == "-1.00"
                                        ? "..."
                                        : "${distance.toString()} " +
                                            LocaleKeys.leftMeters.tr(),
                                    duration: 3000,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: context.theme.hintColor,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    data.deleteSelectedAlarm(currentAlarm);
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
    } else {
      return Center(
        child: Container(
            child: IconButton(
          icon: Icon(Icons.add),
          iconSize: context.highValue,
          onPressed: () {
            //context.read<AlarmProdivder>().getAlarmList();
            //Provider.of<AlarmProdivder>(context, listen: false).getAlarmList();
          },
        )),
      );
    }
  }

  BoxDecoration buildBorderRadiusDecoration(
      BuildContext context, double radius) {
    return BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(1, 2), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [context.colors.onPrimary, context.colors.onError],
        ));
  }

  Widget buildNextAlarmIndicator(AlarmsViewModel viewModel) {
    if (Provider.of<AlarmProvider>(context, listen: true).count > 0) {
      final nearestAlarm =
          Provider.of<AlarmProvider>(context, listen: true).nearestAlarm;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.nearestAlarm.tr(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ShimmerText(
            text: nearestAlarm != null
                ? "${nearestAlarm.distance!.toStringAsFixed(2)} " +
                    LocaleKeys.meters.tr()
                : "?",
            fontSize: 20,
            duration: 3000,
          ),
        ],
      );
    } else {
      return Center(
        child: ShimmerText(
          text: "text",
          duration: 2000,
          fontSize: 50,
        ),
      );
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: context.colors.secondary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShimmerText(
            text: LocaleKeys.alarm.tr(),
            fontSize: 30,
            duration: 4000,
          ),
          IconButton(icon: Icon(Icons.help), onPressed: () {}),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
