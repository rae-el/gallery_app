import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorMessageSnackBar extends StatelessWidget {
  const ErrorMessageSnackBar({
    Key? key,
    required this.eMessage,
  }) : super(key: key);
  final String eMessage;

  @override
  Widget build(BuildContext context) {
    return Stack();
  }
}
