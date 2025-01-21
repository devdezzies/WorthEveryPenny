import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:swappp/features/account/widgets/profile_button.dart';
import 'package:swappp/features/account/widgets/profile_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/providers/user_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String pickedImagePath = "";

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final imagePath = await pickImageFromGallery();
                setState(() {
                  pickedImagePath = imagePath ?? pickedImagePath;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                final imagePath = await pickImageFromCamera();
                setState(() {
                  pickedImagePath = imagePath ?? pickedImagePath;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final TextEditingController usernameController =
        TextEditingController(text: user.name);
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController cardNumberController =
        TextEditingController(text: "1330024432882");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: GlobalVariables.backgroundColor,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.0), shape: BoxShape.circle),
                child: Stack(
                  children: [
                    ClipOval(
                      child: pickedImagePath == ""
                          ? CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              imageUrl:
                                  "https://i.pinimg.com/736x/5e/3d/8c/5e3d8c6897f627e4a194d6cfbb8d8878.jpg",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              width: 150.0,
                              height: 150.0,
                            )
                          : Image.file(
                              File(pickedImagePath),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => _showImagePickerOptions(context),
                        child: const Text(
                          "📸",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              color: GlobalVariables.secondaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Account Settings",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ProfileTextfield(
                    prefixText: "Name",
                    controller: usernameController,
                    prefixIcon: Icons.person,
                  ),
                  ProfileTextfield(
                    prefixText: "Email",
                    controller: emailController,
                    prefixIcon: Icons.mail,
                  ),
                  const ProfileButton(
                      title: "Change Password",
                      leadingIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      )),
                  ProfileTextfield(
                    prefixText: "Payment Number",
                    controller: cardNumberController,
                    prefixIcon: Icons.payment,
                    keyType: TextInputType.number,
                  ),
                  
                ],
              ),
              // const CardList(),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Integrations",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const ProfileButton(
                      title: "Connected Cards", leadingIcon: Icon(Icons.sync))
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Subscription",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const ProfileButton(
                      title: "Freemium Mode",
                      leadingIcon: Icon(
                        Icons.workspace_premium,
                        color: Colors.green,
                      )),
                  const ProfileButton(
                      title: "Subscription",
                      leadingIcon: Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
