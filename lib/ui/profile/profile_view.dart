import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/ui/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

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
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ProfileViewModel(),
      //onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: model.signOut,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => ProfileViewModel().isBusy
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Profile Picture'),
                    ),
                    const SizedBox(height: 30),
                    const ListTile(
                        tileColor: backgroundColour,
                        leading: Icon(Icons.person),
                        title: Text('Username')),
                    ListTile(
                      tileColor: backgroundColour,
                      leading: const Icon(Icons.mail),
                      title: Text(model.showUserEmail as String),
                    ),
                    ListTile(
                      tileColor: backgroundColour,
                      leading: const Icon(Icons.edit),
                      title: TextFormField(
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Gallery Description'),
                        maxLines: null,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
