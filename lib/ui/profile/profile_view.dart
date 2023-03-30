import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/ui/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../app/fonts.dart';

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
          title: const Text(
            'Edit Profile',
            style: appBarFont,
          ),
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
          ? Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [secondaryBackgroundColour, backgroundColour])),
              //fill space of entire screen
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    valueColor: AlwaysStoppedAnimation(primaryColour),
                  ),
                ),
              ),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [secondaryBackgroundColour, backgroundColour])),
                //fill space of entire screen
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
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
                          leading: const Icon(Icons.edit),
                          title: TextFormField(
                            controller: model.nameField,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: TextFormField(
                            controller: model.descriptionField,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.mail),
                          title: Text(model.userEmail),
                        ),
                        TextButton(
                          onPressed: () async {
                            await model.requestToChangePassword();
                          },
                          child: const Text(
                            'Change Password',
                            style:
                                TextStyle(fontSize: 16, color: primaryColour),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: secondaryBackgroundColour,
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              await model.saveProfile();
                            },
                            splashColor: primaryColour,
                            hoverColor: primaryColour,
                            focusColor: primaryColour,
                            child: const Text(
                              'Save',
                              style: TextStyle(color: textColour),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
