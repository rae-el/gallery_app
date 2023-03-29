import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

import 'startup_view_model.dart';

class StartupView extends StatelessWidget {
  const StartupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => StartupViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 300,
                  height: 100,
                  child: Image.asset(model.logoLocation),
                ),
              ),
              const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation(primaryColour),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
