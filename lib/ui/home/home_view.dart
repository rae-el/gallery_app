import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:gallery_app/ui/home/home_view_model.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:reorderables/reorderables.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  // home view after authentication
  // should be the main gallery
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
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
        title: Text(model.username),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            await model.saveOrder();
          },
          icon: const Icon(Icons.save),
          iconSize: 20,
          splashRadius: 18,
          tooltip: 'Save current order',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: model.navigateToProfile,
            iconSize: 25,
            splashRadius: 25,
            tooltip: 'Head to profile',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => HomeViewModel(),
      //line below triggers a double initialistion
      onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => model.isBusy
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: const LinearProgressIndicator(
                  color: secondaryBackgroundColour,
                ),
              ),
            )
          : Scaffold(
              body: Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await model.reorderDecending();
                          },
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 20,
                          splashRadius: 18,
                          tooltip: 'Order by decending date',
                        ),
                        IconButton(
                          onPressed: () async {
                            await model.reorderAcending();
                          },
                          icon: const Icon(Icons.arrow_upward),
                          iconSize: 20,
                          splashRadius: 18,
                          tooltip: 'Order by acending date',
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.height / 4,
                        ),
                        IconButton(
                          onPressed: () async {
                            await model.reorderByNonFavourite();
                          },
                          icon: const Icon(Icons.favorite_border),
                          iconSize: 20,
                          splashRadius: 18,
                          tooltip: 'Order by non-favourite',
                        ),
                        IconButton(
                          onPressed: () async {
                            await model.reorderByFavourite();
                          },
                          icon: const Icon(Icons.favorite),
                          iconSize: 20,
                          splashRadius: 18,
                          tooltip: 'Order by favourite',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: backgroundColour,
                    ),
                    //fill space of entire screen
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 196,
                    child: model.galleryImages == null
                        ? const Center(
                            child: Text('Start by adding some images!'),
                          )
                        : ReorderableWrap(
                            maxMainAxisCount: 3,
                            minMainAxisCount: 3,
                            spacing: 3,
                            runSpacing: 3,
                            padding: const EdgeInsets.all(1),
                            children: List.generate(model.galleryImages!.length,
                                (index) {
                              //_items = model.galleryImages!;
                              return SizedBox(
                                width: 135,
                                height: 135,
                                child: GestureDetector(
                                  key: Key('$index'),
                                  onTap: () {
                                    print(model.galleryImages![index].path);
                                    model.navigateToImageView(
                                      image: model.galleryImages![index],
                                    );
                                  },
                                  //add double tap favourite function
                                  child: Hero(
                                    tag: model.galleryImages![index],
                                    child: Stack(
                                      fit: StackFit.passthrough,
                                      children: [
                                        Image.file(
                                          File(
                                              model.galleryImages![index].path),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                        model.galleryImages![index].favourite
                                            ? const PositionedDirectional(
                                                end: 0,
                                                bottom: 0,
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 20,
                                                ),
                                              )
                                            : const PositionedDirectional(
                                                end: 0,
                                                bottom: 0,
                                                child: Icon(
                                                  Icons.favorite_outline,
                                                  size: 20,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            onReorder: (int oldIndex, int newIndex) {
                              model.onReorder(
                                  oldIndex: oldIndex, newIndex: newIndex);
                            },
                          ),
                  ),
                ],
              ),
              //should this be a persisent footer button instead?
              bottomNavigationBar: SizedBox(
                height: 50,
                child: IconButton(
                  onPressed: () async {
                    await model.openPickerDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  iconSize: 25,
                  splashRadius: 25,
                  tooltip: 'Add new image',
                ),
              ),
            ),
    );
  }
}
