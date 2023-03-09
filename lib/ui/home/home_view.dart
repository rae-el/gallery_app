import 'dart:io';

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
      onModelReady: (viewModel) => viewModel.initialise(),
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
                child: GestureDetector(
                  //return list
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    children: model.createImages(),
                  ),
                  //stream builder method only returning 1 image?
                  /*child: StreamBuilder<String>(
                    stream: model.getMyStream(),
                    initialData: "",
                    builder: ((BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        } else if (snapshot.hasData) {
                          return GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            children: [
                              Image.file(
                                File(snapshot.data ?? ""),
                              ),
                            ],
                          );
                        } else {
                          return const Text("Empty");
                        }
                      }
                      return const Center(
                        //pass the error here
                        child: Text('Error'),
                      );
                    }),
                  ),*/
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await model.openPickerDialog(context);
                },
                child: const Icon(
                  Icons.add,
                  color: textColour,
                ),
              ),
            ),
    );
  }
}
