import 'package:Arealarm/core/init/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/base/extension/context_extension.dart';
import '../../utils/provider/alarm_provider.dart';

Widget buildPlaceCard(
  BuildContext context,
  Animation<Offset> _offsetFloat,
  AnimationController animationController,
) {
  return SlideTransition(
    position: _offsetFloat,
    child: GestureDetector(
      // onTapDown: (TapDownDetails details) => _onTapDown(details),
      //onVerticalDragDown: (DragDownDetails details) => _onTapDown(details),
      child: Padding(
        padding: EdgeInsets.only(top: 400.0),
        child: Container(
          height: 180,
          width: 320,
          // color: context.colors.background,
          decoration: buildBoxDecoration(context),

          child: Padding(
            padding: context.paddingLow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${LocaleKeys.configureAlarm.tr()} #${Provider.of<AlarmProvider>(context, listen: false).selectedPlace != null ? Provider.of<AlarmProvider>(context, listen: false).selectedPlace!.id : ""}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () {
                          Provider.of<AlarmProvider>(context, listen: false)
                              .deletePlace();

                          animationController.forward();
                        },
                        icon: Icon(Icons.close)),
                  ],
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomSlider(context),
                    Container(
                        child: Text(
                            Provider.of<AlarmProvider>(context, listen: false)
                                    .radius
                                    .toStringAsFixed(0) +
                                " ${LocaleKeys.meters.tr()}")),
                  ],
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildRemovePlaceButton(context, animationController),
                    buildAddPlaceButton(context),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

ElevatedButton buildAddPlaceButton(BuildContext context) {
  if ((Provider.of<AlarmProvider>(context, listen: false)
          .isSelectedPlaceAlive ==
      false)) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<AlarmProvider>(context, listen: false).addPlaceToDB();
      },
      child: Text(LocaleKeys.addAlarm.tr()),
    );
  } else {
    return ElevatedButton(
      onPressed: () {
        Provider.of<AlarmProvider>(context, listen: false)
            .updateSelectedAlarm();
      },
      child: Text(LocaleKeys.updateAlarm.tr()),
    );
  }
}

Widget buildRemovePlaceButton(
    BuildContext context, AnimationController _controller) {
  if (Provider.of<AlarmProvider>(context, listen: false).isSelectedPlaceAlive ==
      true) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<AlarmProvider>(context, listen: false)
            .removeAlarmAndPlace();
        _controller.forward();
      },
      child: Text(LocaleKeys.removeAlarm.tr()),
    );
  } else {
    return Text("");
  }
}

SliderTheme buildCustomSlider(BuildContext context) {
  return SliderTheme(
      data: buildSliderThemeData(context),
      child: Slider(
        value: Provider.of<AlarmProvider>(context, listen: false).radius,
        min: 50,
        max: 1000,
        divisions: 19,
        label: Provider.of<AlarmProvider>(context, listen: false)
                .radius
                .round()
                .toString() +
            " ${LocaleKeys.meters.tr()}",
        activeColor: context.colors.secondary,
        onChanged: (double value) {
          changeSelectedPlaceRadius(value, context);
        },
      ));
}

void changeSelectedPlaceRadius(double value, BuildContext context) {
  Provider.of<AlarmProvider>(context, listen: false).radius = value;
  Provider.of<AlarmProvider>(context, listen: false).selectedPlace!.radius =
      Provider.of<AlarmProvider>(context, listen: false).radius;
  Circle newCircle = Circle(
    circleId: Provider.of<AlarmProvider>(context, listen: false)
        .selectedPlace!
        .circle
        .circleId,
    radius: Provider.of<AlarmProvider>(context, listen: false)
        .selectedPlace!
        .radius,
    center: Provider.of<AlarmProvider>(context, listen: false)
        .selectedPlace!
        .position,
    strokeWidth: 4,
    fillColor: context.colors.onPrimary.withOpacity(0.2),
    strokeColor: context.colors.secondaryVariant,
  );
  Provider.of<AlarmProvider>(context, listen: false).changeRadius(newCircle);
}

BoxDecoration buildBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: context.colors.background,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.8),
        spreadRadius: 2,
        blurRadius: 2,
        offset: Offset(1, 2), // changes position of shadow
      ),
    ],
  );
}

SliderThemeData buildSliderThemeData(BuildContext context) {
  return SliderTheme.of(context).copyWith(
    valueIndicatorColor: Colors.blue, // This is what you are asking for
    inactiveTrackColor: Color(0xFF8D8E98), // Custom Gray Color
    activeTrackColor: Colors.white,
    thumbColor: Colors.red,
    overlayColor: Color(0x29EB1555), // Custom Thumb overlay Color
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
  );
}
