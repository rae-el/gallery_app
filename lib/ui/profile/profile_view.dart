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
    //put a height here because throwing error when trying to enter description
    return SafeArea(
      child: Center(
        child: Column(
          children: const [
            SizedBox(height: 30),
            Avatar(),
            ChangeAvatarButton(),
            SizedBox(height: 30),
            UsernameTile(),
            EmailTile(),
            DescriptionTile(),
            SaveProfileButton(),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 50,
      child: Icon(Icons.person),
    );
  }
}

class ChangeAvatarButton extends StatelessWidget {
  const ChangeAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Change Profile Picture'),
    );
  }
}

class UsernameTile extends StatelessWidget {
  const UsernameTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      tileColor: backgroundColour,
      leading: Icon(Icons.person),
      title: Text('Username'),
    );
  }
}

class EmailTile extends StatelessWidget {
  const EmailTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      tileColor: backgroundColour,
      leading: Icon(Icons.mail),
      title: Text('Email'),
    );
  }
}

class DescriptionTile extends StatelessWidget {
  const DescriptionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: backgroundColour,
      leading: const Icon(Icons.edit),
      title: TextFormField(
        decoration:
            const InputDecoration.collapsed(hintText: 'Gallery Description'),
        maxLines: null,
      ),
    );
  }
}

class SaveProfileButton extends StatelessWidget {
  const SaveProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Save'),
    );
  }
}
