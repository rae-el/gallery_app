import 'package:flutter/material.dart';
import 'package:gallery_app/app/colors.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/fonts.dart';
import '../../../enums/basic_dialog_status.dart';

class BasicDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  //make the below line private?
  const BasicDialog({Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: _BasicDialogContent(request: request, completer: completer),
    );
  }
}

class _BasicDialogContent extends StatelessWidget {
  const _BasicDialogContent(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  final DialogRequest request;
  final Function(DialogResponse dialogResponse) completer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 32,
            left: 16,
            right: 16,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: secondaryBackgroundColour,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _getStatusColor(request.data), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                request.title ?? '',
                style: titleFont,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                request.description ?? '',
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (request.secondaryButtonTitle != null)
                    TextButton(
                      onPressed: () =>
                          completer(DialogResponse(confirmed: false)),
                      child: Text(
                        request.secondaryButtonTitle!,
                      ),
                    ),
                  TextButton(
                    onPressed: () => completer(DialogResponse(confirmed: true)),
                    child: Text(
                      request.mainButtonTitle ?? '',
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

Color _getStatusColor(dynamic data) {
  print('get colour');
  // switch not working??? returning default
  print(data);
  switch (data) {
    case BasicDialogStatus.error:
      return errorColour;
    case BasicDialogStatus.warning:
      return warningColour;
    case BasicDialogStatus.success:
      return successColour;
    default:
      return textColour;
  }
}
