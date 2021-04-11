import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_template/view/utils/provider/alarm_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/base/extension/context_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/components/icons/icon_normal.dart';
import '../viewmodel/alarms_view_model.dart';
import '../widgets/animated_widgets.dart';

class AlarmsView extends StatefulWidget {
  AlarmsView({Key? key}) : super(key: key);

  @override
  _AlarmsViewState createState() => _AlarmsViewState();
}

class _AlarmsViewState extends State<AlarmsView>
    with AutomaticKeepAliveClientMixin {
  //AlarmsViewModel alarmsViewModel = new AlarmsViewModel();

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
                    child: buildNextAlarm(viewModel),
                  ),
                  Expanded(
                    child: buildAlarmList(viewModel),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: context.colors.secondaryVariant,
                  child: IconNormal(icon: Icons.delete),
                  onPressed: () {
                    viewModel.deleteAllAlarms();
                  }),
            ));
  }

  Widget buildAlarmList(AlarmsViewModel viewModel) {
    if (!viewModel.hasActiveAlarm) {
      return ListView.builder(
        itemCount: context.read<AlarmProdivder>().alarmCount,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: context.paddingLow,
            child: Container(
              height: context.highValue,
              color: context.randomColor,
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
            context.read<AlarmProdivder>().getAlarmList();
            //Provider.of<AlarmProdivder>(context, listen: false).getAlarmList();
          },
        )),
      );
    }
  }

  Widget buildNextAlarm(AlarmsViewModel viewModel) {
    if (viewModel.hasActiveAlarm) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Next Alarm",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ShimmerText(
            text: "in 200 meters",
            fontSize: 20,
            duration: 3000,
          ),
        ],
      );
    } else {
      return Text("N/A");
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
