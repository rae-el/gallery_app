import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/models/this_image.dart';
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
      builder: (context, model, child) => const Scaffold(
        appBar: MainAppBar(),
        body: HomePage(),
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => AppBar(
        //should make the title the username?
        title: const Text('Gallery'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: model.navigateToProfile,
            iconSize: 25,
            splashRadius: 25,
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => HomeViewModel(),
      //line below triggers a double initialistion
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => model.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  color: backgroundColour,
                ),
                //fill space of entire screen
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: model.galleryImages == null
                    ? const Center(
                        child: Text(
                            'Your gallery is empty! Start by adding some images!'),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3,
                          crossAxisSpacing: 3,
                        ),
                        itemCount: model.galleryImages!.length,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(model.galleryImages![index].path);
                              model.navigateToImageView(
                                image: model.galleryImages![index],
                              );
                            },
                            //add double tap favourite function
                            child: Hero(
                              tag: model.galleryImages![index],
                              child: Image.file(
                                File(model.galleryImages![index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
              ),
              //should this be a persisent footer button instead?
              bottomNavigationBar: const MainBottomBar(),
            ),
    );
  }
}

class MainBottomBar extends StatelessWidget implements PreferredSizeWidget {
  const MainBottomBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => SizedBox(
        height: 50,
        child: IconButton(
          onPressed: () async {
            await model.openPickerDialog(context);
          },
          icon: const Icon(Icons.add),
          iconSize: 25,
          splashRadius: 25,
        ),
      ),
    );
  }
}
