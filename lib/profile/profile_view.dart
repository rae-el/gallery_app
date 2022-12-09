import 'package:flutter/material.dart';
import 'package:gallery_app/utlis/colors.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColour,
      appBar: MyAppBar(),
      body: _profilePage(),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Profile'),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {},
        ),
      ],
    );
  }
}

Widget _profilePage() {
  return SafeArea(
    child: Center(
      child: Column(
        children: [
          SizedBox(height: 30),
          _avatar(),
          _changeAvatarButton(),
          SizedBox(height: 30),
          _usernameTile(),
          _emailTile(),
          _descriptionTile(),
          _saveProfileButton(),
        ],
      ),
    ),
  );
}

Widget _avatar() {
  return CircleAvatar(
    radius: 50,
    child: Icon(Icons.person),
  );
}

Widget _changeAvatarButton() {
  return TextButton(
    onPressed: () {},
    child: Text('Change Profile Picture'),
  );
}

Widget _usernameTile() {
  return ListTile(
    tileColor: backgroundColour,
    leading: Icon(Icons.person),
    title: Text('Username'),
  );
}

Widget _emailTile() {
  return ListTile(
    tileColor: backgroundColour,
    leading: Icon(Icons.mail),
    title: Text('Email'),
  );
}

Widget _descriptionTile() {
  return ListTile(
    tileColor: backgroundColour,
    leading: Icon(Icons.edit),
    title: TextFormField(
      decoration: InputDecoration.collapsed(hintText: 'Gallery Description'),
      maxLines: 10,
    ),
  );
}

Widget _saveProfileButton() {
  return ElevatedButton(
    onPressed: () {},
    child: Text('Save'),
  );
}
