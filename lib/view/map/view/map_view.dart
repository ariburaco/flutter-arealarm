import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../widgets/place_card.dart';
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
                  buildPlaceCard(context, viewmodel, _offsetFloat, _controller),
                ],
              ),
              floatingActionButton: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: buildFloatingActionButton(context, viewmodel)),
                ],
              ),
            ));
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, GoogleMapViewModel viewmodel) {
    return FloatingActionButton(
        backgroundColor: context.colors.secondaryVariant,
        child: IconNormal(icon: Icons.location_pin),
        onPressed: () {
          if (viewmodel.selectedPlaces.length > 1) {
            viewmodel.moveToBounderies();
          } else {
            viewmodel.navigateToCurrentPosition();
          }
        });
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
          viewmodel.addPlaceMarker(pos, context, _controller);
        },
        onMapCreated: (map) => viewmodel.mapsInit(map, _controller),
        initialCameraPosition: CameraPosition(
          target: LatLng(41.029291, 28.887751),
          zoom: 15,
        ),
      );
    });
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
