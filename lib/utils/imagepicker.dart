import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/screens/confirmscreen.dart';

class PickImage {
  final ImagePicker _pickimage = ImagePicker();

  pickedImage(ImageSource source) async {
    XFile? file = await _pickimage.pickImage(source: source);
    if (file != null) {
      file.readAsBytes();
    }
  }

  pickVideo(ImageSource source, BuildContext context) async {
    final video = await _pickimage.pickVideo(source: source);
    return video;
  }
}
