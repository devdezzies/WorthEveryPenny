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
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
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
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}

String rupiahFormatCurrency(int value) {
  return "Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}.00";
}

String countTimeAgo(DateTime dateTime) {
  final Duration diff = DateTime.now().difference(dateTime);
  if (diff.inDays > 0) {
    return "${diff.inDays} days ago";
  } else if (diff.inHours > 0) {
    return "${diff.inHours} hours ago";
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes} minutes ago";
  } else {
    return "${diff.inSeconds} seconds ago";
  }
}

String getGrowthPercentage(int totalBalance, int previousTotalBalance) {
  final double growth =
      (totalBalance - previousTotalBalance) / previousTotalBalance * 100;
  return "${growth.toStringAsFixed(2)}%";
}

Future<bool> showConfirmationDialog(
    BuildContext context, String title, String content) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

String monthName(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    case 12:
      return "December";
    default:
      return "";
  }
}
