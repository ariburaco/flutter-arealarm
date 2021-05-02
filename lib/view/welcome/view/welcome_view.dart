import 'package:Arealarm/core/base/extension/context_extension.dart';
import 'package:Arealarm/core/base/view/base_view.dart';
import 'package:Arealarm/view/welcome/view_model/welcome_view_model.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  PageController? pageController;
  int currentPageIndex = 0;
  void changePage(int index) {
    currentPageIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<WelcomeViewModel>(
      viewModel: WelcomeViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, WelcomeViewModel value) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.normalValue,
                ),
                Container(
                    height: context.height / 2,
                    child: PageView(
                        controller: pageController,
                        onPageChanged: (index) {
                          changePage(index);
                        },
                        children: [
                          Container(
                              color: context.theme.colorScheme.onBackground,
                              child: Text("First")),
                          Container(
                              color: context.theme.colorScheme.onBackground,
                              child: Text("Second")),
                          Container(
                              color: context.theme.colorScheme.onBackground,
                              child: Text("Third"))
                        ])),
                Padding(
                  padding: context.paddingHighVertical,
                  child: Container(
                    child: ElevatedButton(
                        onPressed: () {}, child: Text("Get Access")),
                  ),
                ),
                SizedBox(
                  height: context.lowestValue,
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
