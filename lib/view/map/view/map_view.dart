import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../model/map_place_model.dart';
import '../../../core/base/extension/context_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/components/icons/icon_normal.dart';
import '../viewmodel/map_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();

    animationControllerInit();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Build Map Context");
    super.build(context);
    return BaseView<GoogleMapViewModel>(
        viewModel: GoogleMapViewModel(),
        onModelReady: (viewmodel) {
          viewmodel.setContext(context);
          viewmodel.init();
          // mapsViewModel.getCurrenPosition();
        },
        onPageBuilder: (BuildContext context, GoogleMapViewModel viewmodel) =>
            Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  buildGoogleMap(viewmodel),
                  buildAlarmCard(context, viewmodel),
                ],
              ),
              floatingActionButton: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: FloatingActionButton(
                          backgroundColor: context.colors.secondaryVariant,
                          child: IconNormal(icon: Icons.location_pin),
                          onPressed: () {
                            if (viewmodel.selectedPlaces.length > 1) {
                              viewmodel.moveToBounderies();
                            } else {
                              viewmodel.navigateToCurrentPosition();
                            }
                          })),
                ],
              ),
            ));
  }

  // _onTapDown(DragDownDetails details) {
  //   _controller.forward();
  //   var x = details.globalPosition.dx;
  //   var y = details.globalPosition.dy;
  //   // or user the local position method to get the offset
  //   print(details.localPosition);
  //   print("tap down " + x.toString() + ", " + y.toString());
  // }

  Widget buildAlarmCard(BuildContext context, GoogleMapViewModel viewmodel) {
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
                          "Configure Alarm #${viewmodel.selectedPlace != null ? viewmodel.selectedPlace!.id : ""}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {
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
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          viewmodel.deletePlace();
                          _controller.forward();
                        },
                        child: Text("Remove Place"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          viewmodel.addPlaceToDB();
                        },
                        child: Text("Add Alarm"),
                      ),
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

  SliderTheme buildCustomSlider(
      BuildContext context, GoogleMapViewModel viewmodel) {
    return SliderTheme(
        data: buildSliderThemeData(),
        child: Observer(builder: (_) {
          return Slider(
            value: viewmodel.radius,
            min: 50,
            max: 1000,
            divisions: 19,
            label: viewmodel.radius.round().toString() + " meters",
            activeColor: context.colors.secondary,
            onChanged: (double value) {
              changeSelectedPlaceRadius(value, viewmodel);
            },
          );
        }));
  }

  void changeSelectedPlaceRadius(double value, GoogleMapViewModel viewmodel) {
    viewmodel.radius = value;
    viewmodel.selectedPlace!.radius = viewmodel.radius;
    Circle newCircle = Circle(
      circleId: viewmodel.selectedPlace!.circle.circleId,
      radius: viewmodel.selectedPlace!.radius,
      center: viewmodel.selectedPlace!.position,
      strokeWidth: 5,
      strokeColor: context.colors.secondaryVariant,
    );
    viewmodel.changeRadius(newCircle);
  }

  Widget buildGoogleMap(GoogleMapViewModel viewmodel) {
    return Observer(builder: (_) {
      return GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: viewmodel.markers.toSet(),
        circles: viewmodel.circles.toSet(),
        compassEnabled: true,
        gestureRecognizers: googleGestures.toSet(),
        mapType: MapType.normal,
        onTap: (LatLng pos) {
          _controller.forward();
        },
        onLongPress: (LatLng pos) {
          viewmodel.addPlace(pos, context, _controller);
        },
        onMapCreated: (map) => viewmodel.mapsInit(map),
        initialCameraPosition: CameraPosition(
          target: LatLng(41.029291, 28.887751),
          zoom: 15,
        ),
      );
    });
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

  SliderThemeData buildSliderThemeData() {
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

  List<Factory<OneSequenceGestureRecognizer>> get googleGestures {
    return <Factory<OneSequenceGestureRecognizer>>[
      new Factory<OneSequenceGestureRecognizer>(
        () => new EagerGestureRecognizer(),
      ),
    ];
  }

  void animationControllerInit() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _offsetFloat = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
    _offsetFloat.addListener(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
