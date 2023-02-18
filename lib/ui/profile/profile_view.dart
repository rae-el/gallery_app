import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:gallery_app/models/this_user.dart';
import 'package:gallery_app/ui/profile/profile_view_model.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: const MyAppBar(),
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
  ProfilePage({super.key});

  final TextEditingController _nameField = TextEditingController();
  final TextEditingController _descriptionField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      //this is where I put the view structure
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, model, child) => model.isBusy
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
                    ListTile(
                      tileColor: backgroundColour,
                      leading: const Icon(Icons.edit),
                      title: TextFormField(
                        controller: _nameField,
                        decoration: InputDecoration(
                          labelText: model.userName,
                        ),
                      ),
                    ),
                    ListTile(
                      tileColor: backgroundColour,
                      leading: const Icon(Icons.edit),
                      title: TextFormField(
                        controller: _descriptionField,
                        decoration: InputDecoration(
                          labelText: model.userDescription,
                        ),
                      ),
                    ),
                    ListTile(
                      tileColor: backgroundColour,
                      leading: const Icon(Icons.mail),
                      title: Text(model.userEmail),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Password'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        ThisUser thisUser = ThisUser(
                            id: model.uid,
                            email: model.userEmail,
                            username: _nameField.text.trim(),
                            description: _descriptionField.text.trim(),
                            avatar: model.userAvatar);
                        await model.saveProfile(user: thisUser);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
