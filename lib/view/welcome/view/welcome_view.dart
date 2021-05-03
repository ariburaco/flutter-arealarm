import 'package:Arealarm/core/base/extension/context_extension.dart';
import 'package:Arealarm/core/base/view/base_view.dart';
import 'package:Arealarm/view/welcome/view_model/welcome_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class WelcomeView extends StatefulWidget {
  WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  WelcomeViewModel? welcomeViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<WelcomeViewModel>(
      viewModel: WelcomeViewModel(),
      onModelReady: (model) {
        welcomeViewModel = model;
        welcomeViewModel!.setContext(context);
        welcomeViewModel!.init();
      },
      onPageBuilder: (BuildContext context, WelcomeViewModel viewModel) =>
          Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.normalValue,
                ),
                Container(
                    height: context.height * 0.6,
                    child: Observer(builder: (_) {
                      return PageView(
                          controller: welcomeViewModel!.pageController,
                          onPageChanged: (index) {
                            // welcomeViewModel!.getLocationPermissions();
                          },
                          children: [
                            buildLocationPermission(context),
                            Container(
                              color: context.theme.colorScheme.onBackground,
                              child: Padding(
                                padding: context.paddingLowVertical,
                                child: Container(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        welcomeViewModel!.getStarted();
                                      },
                                      child: Text(
                                        "Get Started",
                                        style: context.textTheme.button,
                                      )),
                                ),
                              ),
                            ),
                            Container(
                                color: context.theme.colorScheme.onBackground,
                                child: Text("Third"))
                          ]);
                    })),
                SizedBox(
                  height: context.highValue,
                ),
                buildProgressBar(context),
                SizedBox(
                  height: context.lowestValue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildLocationPermission(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.onBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 200,
            height: 150,
          ),
          Padding(
            padding: context.paddingLowVertical,
            child: Container(
              child: ElevatedButton(
                  onPressed: () {
                    welcomeViewModel!.getLocationPermissions();
                    welcomeViewModel!.changePage(1);
                  },
                  child: Text(
                    "Get Location Permissions",
                    style: context.textTheme.button,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Container buildProgressBar(BuildContext context) {
    return Container(
        width: context.normalValue,
        height: context.normalValue,
        child: CircularProgressIndicator(
          strokeWidth: context.lowestValue,
          backgroundColor: context.theme.colorScheme.primary,
          color: context.theme.colorScheme.secondary,
        ));
  }
}
