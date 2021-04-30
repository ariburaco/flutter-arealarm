import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/base/extension/context_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/components/icons/icon_normal.dart';
import '../../utils/provider/alarm_provider.dart';
import '../viewmodel/home_view_model.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;

  final GlobalKey<ScaffoldState> _scaffoldyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    _lastLifecycleState = state;
    if (_lastLifecycleState == AppLifecycleState.paused) {
      await Provider.of<AlarmProvider>(context, listen: false)
          .stopLocationStream();
    } else if (_lastLifecycleState == AppLifecycleState.resumed) {
      Provider.of<AlarmProvider>(context, listen: false).startLocationStream();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (viewModel) {
        viewModel.setContext(context);
        viewModel.init();
      },
      onPageBuilder: (BuildContext context, HomeViewModel viewModel) =>
          SafeArea(
        child: Scaffold(
          body: viewModel.buildPageView(),
          bottomNavigationBar: Observer(builder: (_) {
            return buildCurvedNaviationBar(context, viewModel);
          }),
        ),
      ),
    );
  }

  CurvedNavigationBar buildCurvedNaviationBar(
      BuildContext context, HomeViewModel viewModel) {
    return CurvedNavigationBar(
        buttonBackgroundColor: context.theme.colorScheme.secondary,
        key: _scaffoldyKey,
        index: viewModel.currentPageIndex,
        height: context.width * 0.15,
        color: context.theme.colorScheme.primary,
        backgroundColor: Colors.transparent,
        animationDuration: context.lowDuration,
        onTap: (index) {
          viewModel.pageController!.animateToPage(index,
              duration: context.lowDuration, curve: Curves.linear);
        },
        items: [
          IconNormal(icon: Icons.map),
          IconNormal(icon: Icons.home),
          IconNormal(icon: Icons.settings),
        ]);
  }
}
