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
  @override
  Widget build(BuildContext context) {
    return BaseView<WelcomeViewModel>(
      viewModel: WelcomeViewModel(),
      onModelReady: (model) {
        model.setContext(context);
      },
      onPageBuilder: (BuildContext context, WelcomeViewModel value) => Scaffold(
        body: Center(
          child: Container(
              child: CircularProgressIndicator(
            valueColor:
                new AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
          )),
        ),
      ),
    );
  }
}
