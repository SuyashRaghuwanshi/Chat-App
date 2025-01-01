import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Userimagepicker extends StatefulWidget {
  const Userimagepicker({super.key, required this.onPickedImage});
  final void Function(File pickedImage) onPickedImage;

  @override
  State<StatefulWidget> createState() {
    return _UserimagePickerState();
  }
}

class _UserimagePickerState extends State<Userimagepicker> {
  File? _pickedImageFile;

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: pickImage,
          label: Text(
            "Add Image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          icon: const Icon(Icons.photo),
        ),
      ],
    );
  }
}
