import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/models/this_user.dart';
import 'package:gallery_app/ui/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColour,
      appBar: MyAppBar(),
      body: ProfilePage(),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ProfileViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          //how do you change the leading splash radius
          leadingWidth: 30,
          //automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: model.signOut,
              iconSize: 25,
              splashRadius: 25,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ProfileViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => model.isBusy
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 50,
                        child: model.userImagePath == ""
                            ? const Icon(Icons.person)
                            : ClipOval(
                                child: Image.file(
                                  File(model.userImagePath),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await model.openPickerDialog(context);
                        },
                        child: const Text('Change Image'),
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        tileColor: backgroundColour,
                        leading: const Icon(Icons.edit),
                        title: TextFormField(
                          controller: model.nameField,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                        ),
                      ),
                      ListTile(
                        tileColor: backgroundColour,
                        leading: const Icon(Icons.edit),
                        title: TextFormField(
                          controller: model.descriptionField,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                      ),
                      ListTile(
                        tileColor: backgroundColour,
                        leading: const Icon(Icons.mail),
                        title: Text(model.userEmail),
                      ),
                      TextButton(
                        onPressed: () async {
                          await model.requestToChangePassword();
                        },
                        child: const Text('Change Password'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await model.saveProfile();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
