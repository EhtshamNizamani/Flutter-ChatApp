// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Photos extends StatefulWidget {
  const Photos(this.getImage, {Key? key}) : super(key: key);
  final void Function(File image) getImage;
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  File? image;
  void imagem() async {
    PickedFile? picked = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    setState(() {
      image = File(picked!.path);
    });
    if (image == null) {
      return null;
    }
    widget.getImage(image!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).backgroundColor,
          radius: 40,
          backgroundImage: image != null ? FileImage(image!) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: imagem,
          label: const Text("Take image"),
          icon: const Icon(Icons.image),
        ),
      ],
    );
  }
}
