import 'package:Arealarm/core/init/ads_manager/ads_manager.dart';
import 'package:Arealarm/view/map/widgets/focus_switch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../utils/provider/alarm_provider.dart';
import 'package:provider/provider.dart';
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
  late AnimationController animationController;
  late Animation<Offset> _offsetFloat;

  @override
  void initState() {
    super.initState();
    animationControllerInit();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseView<GoogleMapViewModel>(
      viewModel: GoogleMapViewModel(),
      onModelReady: (viewmodel) {
        viewmodel.setContext(context);
        viewmodel.init();
        // mapsViewModel.getCurrenPosition();
      },
      onPageBuilder: (BuildContext context, GoogleMapViewModel viewmodel) =>
          Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              height: context.height - 100,
              width: context.width,
              child: buildGoogleMap(viewmodel)),
          buildPlaceCard(context, _offsetFloat, animationController),
          buildFocusSwitch(context),
          // Positioned(
          //     top: 0,
          //     left: 0,
          //     child: AdsManager.instance.createaBannerAd(context)),
          Positioned(
              bottom: 20,
              left: 20,
              child: buildFloatingActionButton(context, viewmodel)),
        ],
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(
      BuildContext context, GoogleMapViewModel viewmodel) {
    return FloatingActionButton(
        heroTag: null,
        backgroundColor: context.theme.colorScheme.primary,
        child: IconNormal(icon: Icons.location_pin),
        onPressed: () {
          Provider.of<AlarmProvider>(context, listen: false)
              .moveBoundriesDirectly();
        });
  }

  Widget buildGoogleMap(GoogleMapViewModel viewmodel) {
    return GoogleMap(
      trafficEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers:
          Provider.of<AlarmProvider>(context, listen: false).markers.toSet(),
      circles:
          Provider.of<AlarmProvider>(context, listen: false).circles.toSet(),
      compassEnabled: true,
      gestureRecognizers: googleGestures.toSet(),
      mapType: MapType.normal,
      onTap: (LatLng pos) {
        animationController.forward();
      },
      onLongPress: (LatLng pos) {
        Provider.of<AlarmProvider>(context, listen: false)
            .addPlaceMarker(pos, context);
        Provider.of<AlarmProvider>(context, listen: false)
            .navigateToPosition(pos);
      },
      onMapCreated: (map) => Provider.of<AlarmProvider>(context, listen: false)
          .mapsInit(map, animationController),
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

  void animationControllerInit() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..repeat(reverse: true);

    _offsetFloat = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 2),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    animationController.forward();
  }

  @override
  bool get wantKeepAlive => true;
}
