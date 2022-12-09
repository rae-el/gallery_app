import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Add View"),
    );
  }
}
