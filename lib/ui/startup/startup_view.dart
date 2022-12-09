import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import 'startup_view_model.dart';

class StartupView extends StatelessWidget {
  const StartupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      viewModelBuilder: () => StartupViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/gallery_logo.png'),
              ),
              const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(primaryColour)),
            ],
          ),
        ),
      ),
    );
  }
}
