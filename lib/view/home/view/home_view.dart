import 'dart:math';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/init/notification/local_notification.dart';
import '../../../core/base/extension/context_extension.dart';
import '../../../core/base/view/base_view.dart';
import '../../../core/components/icons/icon_normal.dart';
import '../viewmodel/home_view_model.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> showNotification(data) async {
    print(data);
    var rand = Random();
    var hash = rand.nextInt(100);
    DateTime now = DateTime.now().toUtc().add(Duration(seconds: 1));

    LocalNotifications.instance
        .showOngoingNotification(title: "$now", body: "$now", id: hash);
  }

  @override
  Widget build(BuildContext context) {
    print("Reload?");
    return BaseView<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (viewModel) {
        viewModel.setContext(context);
        viewModel.init();
      },
      onPageBuilder: (BuildContext context, HomeViewModel viewModel) =>
          SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: IconNormal(icon: Icons.add_alert),
            onPressed: () {
              viewModel.startLocationService();
            },
          ),
          body: Observer(builder: (_) {
            return viewModel.buildPageView();
          }),
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
        buttonBackgroundColor: Colors.amber,
        key: _scaffoldyKey,
        index: viewModel.currentPageIndex,
        height: context.width * 0.15,
        color: context.colors.secondary,
        backgroundColor: Colors.transparent,
        animationDuration: context.lowDuration,
        onTap: (index) {
          viewModel.pageController.animateToPage(index,
              duration: context.lowDuration, curve: Curves.linear);
        },
        items: [
          IconNormal(icon: Icons.map),
          IconNormal(icon: Icons.home),
          IconNormal(icon: Icons.settings),
        ]);
  }
}
