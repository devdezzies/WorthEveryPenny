import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swappp/constants/global_variables.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        fontFamily: 'Satoshi',
      ),
    ),
    backgroundColor: GlobalVariables.secondaryColor,
  ));
}

Future<String?> pickImageFromCamera() async {
  try {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      return image.path;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

Future<String?> pickImageFromGallery() async {
  try {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}