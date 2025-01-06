import 'dart:io';
import 'package:flutter/material.dart';

class PictureDialog extends StatelessWidget {
  final File imageFile;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;

  const PictureDialog(
      {Key? key,
      required this.imageFile,
      required this.onRetake,
      required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: onRetake, child: Text('재촬영')),
              TextButton(onPressed: onConfirm, child: Text('확인'))
            ],
          )
        ],
      ),
    );
  }
}
