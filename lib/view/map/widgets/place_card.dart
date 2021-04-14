import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../viewmodel/map_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/base/extension/context_extension.dart';

Widget buildPlaceCard(
  BuildContext context,
  GoogleMapViewModel viewmodel,
  Animation<Offset> _offsetFloat,
  AnimationController _controller,
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
                    Observer(builder: (_) {
                      return Text(
                          "Configure Alarm #${viewmodel.selectedPlace != null ? viewmodel.selectedPlace!.id : ""}",
                          style: TextStyle(fontWeight: FontWeight.bold));
                    }),
                    IconButton(
                        onPressed: () {
                          //viewmodel.deletePlace();

                          _controller.forward();
                        },
                        icon: Icon(Icons.close)),
                  ],
                )),
                // Observer(builder: (_) {
                //   return Container(
                //     child: Text(mapsViewModel.selectedPlace == null
                //         ? mapsViewModel.selectedPlace.address
                //         : "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA"),
                //   );
                // }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCustomSlider(context, viewmodel),
                    Container(child: Observer(builder: (_) {
                      return Text(
                          viewmodel.radius.toStringAsFixed(0) + " meters");
                    })),
                  ],
                ),
                Container(child: Observer(builder: (_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildRemovePlaceButton(viewmodel, _controller),
                      buildAddPlaceButton(viewmodel),
                    ],
                  );
                })),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

ElevatedButton buildAddPlaceButton(GoogleMapViewModel viewmodel) {
  if ((viewmodel.isSelectedPlaceAlive == false)) {
    return ElevatedButton(
      onPressed: () {
        viewmodel.addPlaceToDB();
      },
      child: Text("Add Alarm"),
    );
  } else {
    return ElevatedButton(
      onPressed: () {
        viewmodel.updateSelectedAlarm();
      },
      child: Text("Update Alarm"),
    );
  }
}

Widget buildRemovePlaceButton(
    GoogleMapViewModel viewmodel, AnimationController _controller) {
  if (viewmodel.isSelectedPlaceAlive == true) {
    return ElevatedButton(
      onPressed: () {
        viewmodel.removeAlarmAndPlace();
        _controller.forward();
      },
      child: Text("Remove Alarm"),
    );
  } else {
    return Text("");
  }
}

SliderTheme buildCustomSlider(
    BuildContext context, GoogleMapViewModel viewmodel) {
  return SliderTheme(
      data: buildSliderThemeData(context),
      child: Observer(builder: (_) {
        return Slider(
          value: viewmodel.radius,
          min: 50,
          max: 1000,
          divisions: 19,
          label: viewmodel.radius.round().toString() + " meters",
          activeColor: context.colors.secondary,
          onChanged: (double value) {
            changeSelectedPlaceRadius(value, viewmodel, context);
          },
        );
      }));
}

void changeSelectedPlaceRadius(
    double value, GoogleMapViewModel viewmodel, BuildContext context) {
  viewmodel.radius = value;
  viewmodel.selectedPlace!.radius = viewmodel.radius;
  Circle newCircle = Circle(
    circleId: viewmodel.selectedPlace!.circle.circleId,
    radius: viewmodel.selectedPlace!.radius,
    center: viewmodel.selectedPlace!.position,
    strokeWidth: 4,
    fillColor: context.colors.onPrimary.withOpacity(0.2),
    strokeColor: context.colors.secondaryVariant,
  );
  viewmodel.changeRadius(newCircle);
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
