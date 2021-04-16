import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../utils/provider/alarm_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/base/extension/context_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/components/icons/icon_normal.dart';
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
                    await Provider.of<AlarmProdivder>(context, listen: false)
                        .deleteAllAlarms();
                  }),
            ));
  }

  Widget buildAlarmList(AlarmsViewModel viewModel) {
    // TODO: Change with Consumer structure
    if (Provider.of<AlarmProdivder>(context, listen: true).alarmList.length >
        0) {
      return ListView.builder(
        itemCount:
            Provider.of<AlarmProdivder>(context, listen: true).alarmList.length,
        itemBuilder: (BuildContext context, int index) {
          final placeName =
              context.read<AlarmProdivder>().alarmList[index].alarmId!;

          final radius =
              context.read<AlarmProdivder>().alarmList[index].radius!.toInt();

          final address =
              context.read<AlarmProdivder>().alarmList[index].address!;
          final distance =
              context.read<AlarmProdivder>().alarmList[index].distance != null
                  ? context
                      .read<AlarmProdivder>()
                      .alarmList[index]
                      .distance!
                      .toStringAsFixed(2)
                  : -1;

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
                            "Alarm #$placeName",
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
                          child: Text(
                            "${distance.toString()} meters left",
                            style: context.textTheme.headline5,
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
                          onPressed: () {},
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      );
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
    if (Provider.of<AlarmProdivder>(context, listen: true).alarmCount > 0) {
      final nearestAlarm =
          Provider.of<AlarmProdivder>(context, listen: true).nearestAlarm;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Nearest Alarm",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ShimmerText(
            text: nearestAlarm != null
                ? "in ${nearestAlarm.distance!.toStringAsFixed(2)} meters"
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
            text: "Arealarm",
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
