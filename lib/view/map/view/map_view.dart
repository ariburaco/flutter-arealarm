import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_template/view/map/model/map_place_model.dart';
import '../../../core/base/extension/context_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/components/icons/icon_normal.dart';
// import 'package:flutter_template/view/map/model/map_place_model.dart';
import 'package:flutter_template/view/map/viewmodel/map_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  double widthSlide;

  GoogleMapViewModel mapsViewModel = GoogleMapViewModel();

  @override
  void initState() {
    super.initState();
    mapsViewModel.setContext(context);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _offsetFloat = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.8),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    _controller.forward();
    _offsetFloat.addListener(() {});
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
                  SlideTransition(
                    position: _offsetFloat,
                    child: GestureDetector(
                      onTap: () {
                        _controller.forward();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 180.0),
                        child: Container(
                          height: 150,
                          width: 320,
                          // color: context.colors.background,
                          decoration: BoxDecoration(
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
                                offset:
                                    Offset(1, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Text("asdasdas"),
                        ),
                      ),
                    ),
                  ),
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
                              mapsViewModel.navigateToCurrentPosition();
                            });
                          })),
                ],
              ),
            ));
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
        // mapsViewModel.addMarkerConstant(pos);
        setState(() {
          mapsViewModel.navigateToPosition(pos);

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

  List<Factory<OneSequenceGestureRecognizer>> get googleGestures {
    return <Factory<OneSequenceGestureRecognizer>>[
      new Factory<OneSequenceGestureRecognizer>(
        () => new EagerGestureRecognizer(),
      ),
    ];
  }

  void addPlace(LatLng position) {
    _controller.reverse();
    Marker marker = new Marker(
        markerId: MarkerId("marker_${mapsViewModel.count}"),
        position: position,
        zIndex: 10,
        infoWindow: InfoWindow(),
        onTap: () {
          _controller.reverse();
          List<Marker> markers = getMarkers().toList();
          print(markers[0].markerId);
        },
        icon: mapsViewModel.pinLocationIcon);
    Circle circle = new Circle(
        circleId: CircleId("circle_${mapsViewModel.count}"),
        center: position,
        radius: 500,
        strokeWidth: 5,
        strokeColor: context.colors.secondaryVariant);

    mapsViewModel.markers.add(marker);
    mapsViewModel.circles.add(circle);

    MapPlace currentMapPlace =
        new MapPlace("${mapsViewModel.count}", position, circle, marker);
    mapsViewModel.addMapPlaces(currentMapPlace);
    if (mapsViewModel.selectedPlaces.length > 1) {
      mapsViewModel.moveToBounderies();
    }
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
