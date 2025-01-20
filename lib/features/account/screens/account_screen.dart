import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/account/screens/profile_edit.dart';
import 'package:swappp/features/account/widgets/card_list.dart';
import 'package:swappp/features/account/widgets/user_data_form.dart';
import 'package:swappp/features/settings/screens/setting_screen.dart';
import 'package:swappp/providers/user_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile",
            style: TextStyle(fontWeight: FontWeight.w900)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: GlobalVariables.backgroundColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SettingScreen.routeName);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: GlobalVariables.secondaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.0)),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.settings,
                    color: GlobalVariables.backgroundColor,
                  ),
                ),
              ),
            ),
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.0), shape: BoxShape.circle),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        imageUrl:
                            "https://i.pinimg.com/736x/5e/3d/8c/5e3d8c6897f627e4a194d6cfbb8d8878.jpg",
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 25),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ],
                  )),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileEdit.routeName);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: GlobalVariables.secondaryColor,
                        border: Border.all(
                            width: 3.0, color: GlobalVariables.backgroundColor),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 15.0),
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                            color: GlobalVariables.backgroundColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: const Column(
                  children: [
                    UserDataForm(headContent: "User ID", content: "10203342"),
                    SizedBox(
                      height: 16,
                    ),
                    UserDataForm(
                        headContent: "Phone Number", content: "081584907425"),
                    SizedBox(
                      height: 16,
                    ),
                    UserDataForm(
                        headContent: "Account for Payment",
                        content: "1330024432882"),
                    SizedBox(
                      height: 16,
                    ),
                    UserDataForm(headContent: "My Wallet", content: ""),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const CardList(),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 3.0, color: GlobalVariables.secondaryColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: const Text(
                    "Add Card",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: GlobalVariables.secondaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
