import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
    with AutomaticKeepAliveClientMixin {
  GoogleMapViewModel mapsViewModel = GoogleMapViewModel();

  @override
  void initState() {
    super.initState();
    mapsViewModel.setContext(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView<GoogleMapViewModel>(
        viewModel: GoogleMapViewModel(),
        onModelReady: (viewmodel) {
          // viewmodel.setContext(context);
          // viewmodel.init();
          mapsViewModel.getCurrenPosition();
        },
        onPageBuilder: (BuildContext context, GoogleMapViewModel viewmodel) =>
            Scaffold(
              body: Stack(
                children: <Widget>[
                  buildGoogleMap(),
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
      compassEnabled: true,
      gestureRecognizers: googleGestures.toSet(),
      mapType: MapType.normal,
      onLongPress: (LatLng pos) {
        // mapsViewModel.addMarkerConstant(pos);
        setState(() {
          mapsViewModel.addMarkerConstant(pos);
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

  Set<Marker> getMarkers() {
    return mapsViewModel.markers;
  }

  @override
  bool get wantKeepAlive => true;
}
