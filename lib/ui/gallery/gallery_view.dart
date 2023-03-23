import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/models/this_image.dart';
import 'package:gallery_app/ui/gallery/gallery_view_model.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:reorderables/reorderables.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});
  // home view after authentication
  // should be the main gallery
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GalleryViewModel>.reactive(
      viewModelBuilder: () => GalleryViewModel(),
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
    return ViewModelBuilder<GalleryViewModel>.reactive(
      viewModelBuilder: () => GalleryViewModel(),
      builder: (context, model, child) => AppBar(
        //should make the title the username?
        title: Text(model.username),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
    return ViewModelBuilder<GalleryViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => GalleryViewModel(),
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
              body: Container(
                decoration: const BoxDecoration(
                  color: backgroundColour,
                ),
                //fill space of entire screen
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: model.galleryImages == null
                    ? const Center(
                        child: Text('Start by adding some images!'),
                      )
                    : ReorderableWrap(
                        maxMainAxisCount: 3,
                        minMainAxisCount: 3,
                        spacing: 3,
                        runSpacing: 3,
                        enableReorder: model.draggableReordering,
                        padding: const EdgeInsets.all(1),
                        children: List.generate(
                            model.galleryImagesShown!.length, (index) {
                          //_items = model.galleryImages!;
                          return SizedBox(
                            width: 135,
                            height: 135,
                            child: GestureDetector(
                              key: Key('$index'),
                              onTap: () {
                                print(model.galleryImagesShown![index].path);
                                model.navigateToImageView(
                                  image: model.galleryImagesShown![index],
                                );
                              },
                              onDoubleTap: () {
                                print('doubled tapped');
                                model.toggleFavourite(
                                    image: model.galleryImagesShown![index]);
                              },
                              //add double tap favourite function
                              child: Hero(
                                tag: model.galleryImagesShown![index],
                                child: Stack(
                                  fit: StackFit.passthrough,
                                  children: [
                                    Image.file(
                                      File(model
                                          .galleryImagesShown![index].path),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    model.galleryImagesShown![index].favourite
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
              //should this be a persisent footer button instead?
              bottomNavigationBar: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await model.reorderAcendingDecending();
                      },
                      icon: const Icon(Icons.swap_vert),
                      iconSize: 20,
                      splashRadius: 18,
                      tooltip: 'Order By Date',
                    ),
                    IconButton(
                      onPressed: () {
                        model.toggleDraggableReordering();
                      },
                      icon: model.draggableReordering
                          ? const Icon(Icons.grid_view)
                          : const Icon(Icons.move_down),
                      iconSize: 20,
                      splashRadius: 18,
                      tooltip: 'Enable Draggable Reordering',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4.9,
                    ),
                    IconButton(
                      onPressed: () async {
                        await model.openPickerDialog(context);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 35,
                      splashRadius: 25,
                      tooltip: 'Add New',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.2,
                    ),
                    IconButton(
                      onPressed: () async {
                        await model.filterFavourites();
                      },
                      icon: model.galleryImagesShown!.length ==
                              model.favouriteGalleryImagesShown.length
                          ? const Icon(Icons.favorite_border)
                          : const Icon(Icons.favorite),
                      iconSize: 20,
                      splashRadius: 18,
                      tooltip: 'View Favourites',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
