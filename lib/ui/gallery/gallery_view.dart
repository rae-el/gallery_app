import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_app/app/fonts.dart';
import 'package:gallery_app/ui/gallery/gallery_view_model.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:reorderables/reorderables.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
        title: Text(
          model.username,
          style: appBarFont,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        shadowColor: secondaryBackgroundColour,

        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 50,
              child: model.userIcon == ""
                  ? const Icon(Icons.person)
                  : ClipOval(
                      child: Image.file(
                        File(model.userIcon),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
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
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => model.isBusy
          ? Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [secondaryBackgroundColour, backgroundColour])),
              //fill space of entire screen
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
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
            )
          : Scaffold(
              extendBody: true,
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [secondaryBackgroundColour, backgroundColour])),
                //fill space of entire screen
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: model.galleryImagesShown.isEmpty
                    ? const Center(
                        child: Text('Start by adding some images!'),
                      )
                    : AnimationLimiter(
                        child: ReorderableWrap(
                          maxMainAxisCount: 3,
                          minMainAxisCount: 3,
                          spacing: 3,
                          runSpacing: 3,
                          enableReorder: model.draggableReordering,
                          padding: const EdgeInsets.all(1),
                          children: List.generate(
                              model.galleryImagesShown.length, (index) {
                            //_items = model.galleryImages!;
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 377),
                              child: SlideAnimation(
                                verticalOffset: 20,
                                child: FadeInAnimation(
                                  child: SizedBox(
                                    width: 135,
                                    height: 135,
                                    child: GestureDetector(
                                      key: Key('$index'),
                                      onTap: () {
                                        model.navigateToImageView(
                                          image:
                                              model.galleryImagesShown[index],
                                        );
                                      },
                                      onDoubleTap: () {
                                        model.toggleFavourite(
                                            image: model
                                                .galleryImagesShown[index]);
                                      },
                                      //add double tap favourite function
                                      child: Hero(
                                        tag: model.galleryImagesShown[index],
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Stack(
                                            fit: StackFit.passthrough,
                                            children: [
                                              Image.file(
                                                File(model
                                                    .galleryImagesShown[index]
                                                    .path),
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              model.galleryImagesShown[index]
                                                      .favourite
                                                  ? const PositionedDirectional(
                                                      end: 0,
                                                      bottom: 0,
                                                      child: Icon(
                                                        Icons.favorite,
                                                        size: 25,
                                                      ),
                                                    )
                                                  : const PositionedDirectional(
                                                      end: 0,
                                                      bottom: 0,
                                                      child: Icon(
                                                        Icons.favorite_outline,
                                                        size: 25,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
              ),
              //should this be a persisent footer button instead?
              bottomNavigationBar: DecoratedBox(
                decoration: const BoxDecoration(color: transparentColour),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                  child: ClipPath(
                    clipper: const ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40)))),
                    child: SizedBox(
                      height: 50,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                            color: secondaryBackgroundColour),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await model.reorderAcendingDecending();
                              },
                              icon: const Icon(Icons.swap_vert),
                              iconSize: 25,
                              splashRadius: 18,
                              tooltip: 'Order By Date',
                              color: primaryColour,
                              alignment: AlignmentDirectional.bottomStart,
                            ),
                            IconButton(
                              onPressed: () {
                                model.toggleDraggableReordering();
                              },
                              icon: model.draggableReordering
                                  ? const Icon(Icons.grid_view)
                                  : const Icon(Icons.move_down),
                              iconSize: 25,
                              splashRadius: 18,
                              tooltip: 'Enable Draggable Reordering',
                              color: primaryColour,
                              alignment: AlignmentDirectional.bottomStart,
                            ),
                            IconButton(
                              onPressed: () async {
                                await model.openPickerDialog(context);
                              },
                              icon: const Icon(Icons.add_circle),
                              iconSize: 45,
                              splashRadius: 30,
                              tooltip: 'Add New',
                              color: textColour,
                              alignment: AlignmentDirectional.topCenter,
                              padding:
                                  const EdgeInsets.only(left: 40.0, right: 70),
                            ),
                            IconButton(
                              onPressed: () async {
                                await model.filterFavourites();
                              },
                              icon: model.galleryImagesShown.length ==
                                      model.favouriteGalleryImagesShown.length
                                  ? const Icon(Icons.favorite_border)
                                  : const Icon(Icons.favorite),
                              iconSize: 25,
                              splashRadius: 18,
                              tooltip: 'View Favourites',
                              color: primaryColour,
                              alignment: AlignmentDirectional.bottomEnd,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
