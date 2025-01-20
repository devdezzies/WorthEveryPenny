import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/features/settings/widgets/setting_menu.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = "/settings";
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: GlobalVariables.backgroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.white,),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SettingMenu(headIcon: Icons.attach_money, menuTitle: "Currency", onTap: () {}, previewTitle: "Rupiah",),
              const SizedBox(height: 25,),
              SettingMenu(headIcon: Icons.language, menuTitle: "Language", onTap: () {}, previewTitle: "English",),
              const SizedBox(height: 25,),
              SettingMenu(headIcon: Icons.workspace_premium, menuTitle: "Subscription", onTap: () {}, previewTitle: "Premium",),
              const SizedBox(height: 25,),
              SettingMenu(headIcon: Icons.security, menuTitle: "Privacy and Security", onTap: () {},),
              const SizedBox(height: 25,),
              SettingMenu(headIcon: Icons.feedback, menuTitle: "Feedback and Suggestions", onTap: () {},),
              const SizedBox(height: 25,),
              SettingMenu(headIcon: Icons.help, menuTitle: "Help and Support", onTap: () {},),
            ],
          ),
        ),
      ),
    );
  }
}
