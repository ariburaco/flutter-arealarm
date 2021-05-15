import 'package:Arealarm/core/base/extension/context_extension.dart';
import 'package:Arealarm/core/base/view/base_view.dart';
import 'package:Arealarm/core/constants/application/app_constants.dart';
import 'package:Arealarm/core/init/lang/locale_keys.g.dart';
import 'package:Arealarm/view/welcome/view_model/welcome_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

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
                    height: context.height * 0.5,
                    child: Observer(builder: (_) {
                      return PageView(
                          controller: welcomeViewModel!.pageController,
                          onPageChanged: (index) {
                            // welcomeViewModel!.getLocationPermissions();
                          },
                          children: [
                            buildLocationPermission(context),
                            buildGetStarted(context),
                          ]);
                    })),
                SizedBox(
                  height: context.highValue,
                ),
                buildProgressBar(context),
                SizedBox(
                  height: context.lowestValue,
                ),
                SizedBox(
                  height: context.lowValue,
                ),
                Container(child: Observer(builder: (_) {
                  return Text(
                    welcomeViewModel!.permissionText,
                    style: context.textTheme.headline5,
                  );
                }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildGetStarted(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              height: context.height * 0.3,
              child: SvgPicture.asset(ApplicationConstants.GET_STARTED_SVG,
                  semanticsLabel: 'Get Started')),
          Padding(
            padding: context.paddingLowVertical,
            child: Container(
              child: ElevatedButton(
                  onPressed: () {
                    welcomeViewModel!.getStarted();
                  },
                  child: Text(
                    LocaleKeys.getStarted.tr(),
                    style: context.textTheme.button,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Container buildLocationPermission(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              height: context.height * 0.3,
              child: SvgPicture.asset(ApplicationConstants.LOCATION_SVG_1,
                  semanticsLabel: 'Location Permission')),
          Padding(
            padding: context.paddingLowVertical,
            child: Container(
              child: ElevatedButton(
                  onPressed: () {
                    welcomeViewModel!.getLocationPermissions();
                  },
                  child: Text(
                    LocaleKeys.getLocationPermissions.tr(),
                    style: context.textTheme.button,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Observer buildProgressBar(BuildContext context) {
    return Observer(builder: (_) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        width: context.highValue,
        height: context.highValue,
        child: welcomeViewModel!.isGranted == false
            ? CircularProgressIndicator(
                strokeWidth: context.lowestValue,
                backgroundColor: context.theme.colorScheme.primary,
                color: context.theme.colorScheme.secondary,
              )
            : Icon(
                Icons.check,
                size: context.highValue,
                color: Colors.green,
              ),
      );
    });
  }
}
