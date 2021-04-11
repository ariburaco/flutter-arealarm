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
  GoogleMapViewModel mapsViewModel = GoogleMapViewModel();

  @override
  void initState() {
    super.initState();
    mapsViewModel.setContext(context);
    mapsViewModel.init();
    animationControllerInit();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView<GoogleMapViewModel>(
        viewModel: GoogleMapViewModel(),
        onModelReady: (viewmodel) {
          // viewmodel.setContext(context);
          // viewmodel.init();
          // mapsViewModel.getCurrenPosition();
        },
        onPageBuilder: (BuildContext context, GoogleMapViewModel viewmodel) =>
            Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  buildGoogleMap(),
                  buildAlarmCard(context),
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
                            setState(() {
                              if (mapsViewModel.selectedPlaces.length > 1) {
                                mapsViewModel.moveToBounderies();
                              } else {
                                mapsViewModel.navigateToCurrentPosition();
                              }
                            });
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

  Widget buildAlarmCard(BuildContext context) {
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
                            "Configure Alarm #${mapsViewModel.selectedPlace != null ? mapsViewModel.selectedPlace!.id : ""}",
                            style: TextStyle(fontWeight: FontWeight.bold));
                      }),
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
                      buildCustomSlider(context),
                      Container(child: Observer(builder: (_) {
                        return Text(mapsViewModel.radius.toStringAsFixed(0) +
                            " meters");
                      })),
                    ],
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            mapsViewModel.deletePlace();
                            _controller.forward();
                          });
                        },
                        child: Text("Remove Place"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          mapsViewModel.addPlaceToDB();
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

  SliderTheme buildCustomSlider(BuildContext context) {
    return SliderTheme(
        data: buildSliderThemeData(),
        child: Observer(builder: (_) {
          return Slider(
            value: mapsViewModel.radius,
            min: 50,
            max: 1000,
            divisions: 19,
            label: mapsViewModel.radius.round().toString() + " meters",
            activeColor: context.colors.secondary,
            onChanged: (double value) {
              setState(() {
                changeSelectedPlaceRadius(value);
              });
            },
          );
        }));
  }

  void changeSelectedPlaceRadius(double value) {
    mapsViewModel.radius = value;
    mapsViewModel.selectedPlace!.radius = mapsViewModel.radius;
    Circle newCircle = Circle(
      circleId: mapsViewModel.selectedPlace!.circle.circleId,
      radius: mapsViewModel.selectedPlace!.radius,
      center: mapsViewModel.selectedPlace!.position,
      strokeWidth: 5,
      strokeColor: context.colors.secondaryVariant,
    );
    mapsViewModel.changeRadius(newCircle);
  }

  Widget buildGoogleMap() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: getMarkers(),
      circles: getCircles(),
      compassEnabled: true,
      gestureRecognizers: googleGestures.toSet(),
      mapType: MapType.normal,
      onTap: (LatLng pos) {
        _controller.forward();
      },
      onLongPress: (LatLng pos) {
        setState(() {
          addPlace(pos);
        });
      },
      onMapCreated: (map) => mapsViewModel.mapsInit(map),
      initialCameraPosition: CameraPosition(
        target: LatLng(41.029291, 28.887751),
        zoom: 15,
      ),
    );
  }

  void addPlace(LatLng position) {
    _controller.reverse();
    mapsViewModel.navigateToPosition(position);
    String placeId = "place_${mapsViewModel.count}";
    Marker marker = new Marker(
        markerId: MarkerId(placeId),
        position: position,
        zIndex: 14,
        //TODO add GeoCode API to InfoWindow
        //infoWindow: InfoWindow(title: "at $position"),
        onTap: () {
          _controller.reverse();
          onMarkerTapped(MarkerId(placeId));
          //print(markers[0].markerId);
        },
        icon: mapsViewModel.pinLocationIcon!);
    Circle circle = new Circle(
        circleId: CircleId(placeId),
        center: position,
        radius: mapsViewModel.radius,
        strokeWidth: 5,
        strokeColor: context.colors.secondaryVariant);

    mapsViewModel.markers.add(marker);
    mapsViewModel.circles.add(circle);

    MapPlace currentMapPlace = new MapPlace(mapsViewModel.count, placeId,
        position, circle, marker, mapsViewModel.radius, "N/A");

    mapsViewModel.selectedPlace = currentMapPlace;
    mapsViewModel.addMapPlaces(currentMapPlace);

    if (mapsViewModel.selectedPlaces.length > 1) {
      mapsViewModel.moveToBounderies();
    }
  }

  void onMarkerTapped(MarkerId markerId) {
    //List<Marker> markers = getMarkers().toList();

    var matchedPlace = mapsViewModel.selectedPlaces
        .where((element) => (element.marker.markerId.value == markerId.value));

    if (matchedPlace.length > 0) {
      mapsViewModel.selectedPlace = matchedPlace.first;
      mapsViewModel.radius = mapsViewModel.selectedPlace!.radius;
      print("selected place radius: ${mapsViewModel.radius}");
    } else {
      print("No Match for marker");
    }
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

  Set<Marker> getMarkers() {
    return mapsViewModel.markers;
  }

  Set<Circle> getCircles() {
    return mapsViewModel.circles;
  }

  @override
  bool get wantKeepAlive => true;
}
