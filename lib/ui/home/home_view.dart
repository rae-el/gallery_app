import 'package:flutter/material.dart';
import 'package:gallery_app/ui/home/home_view_model.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  // home view after authentication
  // should be the main gallery
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: const MainAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            color: backgroundColour,
          ),
          //fill space of entire screen
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //fill with images
          child: Center(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.addImage,
          child: const Icon(
            Icons.add,
            color: textColour,
          ),
        ),
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: model.navigateToProfile,
          ),
        ],
      ),
    );
  }
}
