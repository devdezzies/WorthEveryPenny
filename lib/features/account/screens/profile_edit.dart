import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swappp/common/widgets/profile_button.dart';
import 'package:swappp/common/widgets/profile_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';

class ProfileEdit extends StatefulWidget {
  static const String routeName = "/profile-edit";
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _usernameController =
      TextEditingController(text: "taraanka");
  final TextEditingController _emailController =
      TextEditingController(text: "taraanka@gmail.com");
  final TextEditingController _cardController = TextEditingController();
  String pickedImagePath = "";

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _cardController.dispose();
    super.dispose();
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        centerTitle: true,
        title: const Text("Edit Profile",
            style: TextStyle(fontWeight: FontWeight.w900)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 15,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Stack(children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100,
                    child: ClipOval(
                      child: pickedImagePath == ""
                          ? CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                strokeWidth: 10,
                                strokeCap: StrokeCap.round,
                              ),
                              imageUrl:
                                  "https://i.pinimg.com/736x/36/03/b1/3603b13d403c5b7a3c89e91f92782418.jpg",
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            )
                          : Image.file(
                              File(pickedImagePath),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
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
                            fontSize: 40,
                            color: GlobalVariables.secondaryColor),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 50,
                ),
                ProfileTextfield(
                  controller: _usernameController,
                  prefixIcon: Icons.person,
                ),
                ProfileTextfield(
                  controller: _emailController,
                  prefixIcon: Icons.mail,
                ),
                ProfileTextfield(
                  controller: _cardController,
                  prefixIcon: Icons.credit_card,
                  hintText: "Your Card Number for Payment",
                  keyType: TextInputType.number,
                ),
                ProfileButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: "Save Changes 🌳",
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
