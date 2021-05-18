import 'package:Arealarm/core/init/lang/locale_keys.g.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
                  createaBannerAd(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: buildAlarmList(viewModel),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: context.theme.colorScheme.secondary,
                  child: IconNormal(icon: Icons.delete),
                  onPressed: () async {
                    await Provider.of<AlarmProvider>(context, listen: false)
                        .deleteAllAlarms();
                  }),
            ));
  }

  Container createaBannerAd() {
    final BannerAd myBanner = BannerAd(
      adUnitId: 'ca-app-pub-9331991014591087/5000831383',
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(),
    );

    final AdSize adSize = AdSize(width: 300, height: 50);

    final AdListener listener = AdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an ad is in the process of leaving the application.
      onApplicationExit: (Ad ad) => print('Left application.'),
    );

    myBanner.load();
    final AdWidget adWidget = AdWidget(ad: myBanner);

    final Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    return adContainer;
  }

  Widget buildAlarmList(AlarmsViewModel viewModel) {
    if (Provider.of<AlarmProvider>(context, listen: true).count > 0) {
      return Consumer<AlarmProvider>(
          builder: (_, data, __) => ListView.builder(
                itemCount: data.alarmList!.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentAlarm = data.alarmList![index];
                  final placeName = currentAlarm.alarmId!;
                  final radius = currentAlarm.radius!.toInt();
                  final address = currentAlarm.address!;
                  var distance = (currentAlarm.distance! - radius);
                  if (distance <= 0) distance = 0;

                  var distanceStr = distance.toStringAsFixed(1);
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
                              padding: context.paddingLowest,
                              child: Icon(
                                Icons.location_pin,
                                size: 50,
                                color: context.theme.colorScheme.primary,
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
                                  padding: context.paddingLowest,
                                  child: AutoSizeText(
                                    LocaleKeys.alarm.tr() + " #$placeName",
                                    maxLines: 1,
                                    minFontSize: 30,
                                    style: TextStyle(
                                        color: context
                                            .theme.colorScheme.primaryVariant),
                                  ),
                                ),
                                Padding(
                                  padding: context.paddingLowest,
                                  child: AutoSizeText(
                                    address.toString(),
                                    maxLines: 1,
                                    minFontSize: 18,
                                    style: context.textTheme.subtitle2!
                                        .copyWith(
                                            color: context.theme.colorScheme
                                                .primaryVariant),
                                  ),
                                ),
                                Padding(
                                  padding: context.paddingLowest,
                                  child: AutoSizeText(
                                    "${distanceStr.toString()} " +
                                        LocaleKeys.leftMeters.tr(),
                                    style: TextStyle(
                                        color: context
                                            .theme.colorScheme.onPrimary),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: context.paddingLowest,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: context.theme.colorScheme.secondary,
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
        child: Container(),
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
          colors: [
            context.theme.colorScheme.secondary,
            context.theme.colorScheme.primary
          ],
        ));
  }

  Widget buildNextAlarmIndicator(AlarmsViewModel viewModel) {
    if (Provider.of<AlarmProvider>(context, listen: true).count > 0) {
      final nearestAlarm =
          Provider.of<AlarmProvider>(context, listen: true).nearestAlarm;

      if (nearestAlarm != null) {
        final radius = nearestAlarm.radius!.toInt();
        var distance = (nearestAlarm.distance! - radius);
        if (distance <= 0) distance = 0;

        var distanceStr = distance.toStringAsFixed(1);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.nearestAlarm.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ShimmerText(
              color: context.theme.colorScheme.onPrimary,
              text: "$distanceStr " + LocaleKeys.meters.tr(),
              fontSize: 20,
              duration: 3000,
            ),
          ],
        );
      } else {
        return Center(
          child: Container(),
        );
      }
    } else {
      return Center(
        child: Container(),
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
            color: context.theme.colorScheme.onPrimary,
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
