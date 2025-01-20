import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class ProfileEdit extends StatefulWidget {
  static const String routeName = "/profile-edit";
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
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
                      child: CachedNetworkImage(
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
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    left: 10,
                    child: Text(
                      "📸",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 40,
                          color: GlobalVariables.secondaryColor),
                    ),
                  ),
                ]),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
