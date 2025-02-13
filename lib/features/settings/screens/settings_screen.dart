import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:swappp/common/services/preferences_service.dart';
import 'package:swappp/features/settings/services/settings_service.dart';
import 'package:swappp/features/settings/widgets/profile_button.dart';
import 'package:swappp/features/settings/widgets/profile_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/settings/widgets/settings_switch.dart';
import 'package:swappp/features/settings/widgets/subscription/premium_subscription_field.dart';
import 'package:swappp/models/user.dart';
import 'package:swappp/providers/preferences_provider.dart';
import 'package:swappp/providers/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String, String) onLeave;
  const SettingsScreen({super.key, required this.onLeave});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService preferencesService = PreferencesService();
  late PreferencesProvider preferencesProvider;
  late User user;
  late String cannyToken;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController cardNumberController;
  final SettingsService settingsService = SettingsService();
  late WebViewController webViewController;
  String pickedImagePath = "";
  late UserProvider userProvider;

  @override
  void initState() {
    preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.user;
    usernameController = TextEditingController(text: user.displayName);
    emailController = TextEditingController(text: user.email);
    cardNumberController = TextEditingController(text: user.paymentNumber);
    _initializeToken();
  }

  @override
  void dispose() {
    // TODO: remove unstable code
    try {
      widget.onLeave(usernameController.text, cardNumberController.text);
    } catch (e) {
      debugPrint("FIX THIS");
    }
    usernameController.dispose();
    emailController.dispose();
    cardNumberController.dispose();
    super.dispose();
  }

  Future<void> _initializeToken() async {
    cannyToken = await PreferencesService().getCannyToken();
  }

  void _showConfirmationProfilePhotoScreen(
      BuildContext context, String imagePath) {
    bool isUpdating = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return SimpleDialog(
            backgroundColor:
                Colors.transparent, // Make the dialog background transparent
            elevation: 0, // Remove shadow
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Confirm Photo?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipOval(
                      child: kIsWeb
                          ? Image.network(
                              imagePath,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(imagePath),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (!isUpdating) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              isUpdating = true;
                            });
                            await settingsService.updateProfilePicture(
                                context: context,
                                profilePicture: imagePath,
                                id: user.id);
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              isUpdating = false;
                              pickedImagePath = imagePath;
                            });
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            isUpdating ? "Updating..." : "Confirm",
                            style: const TextStyle(
                                color: GlobalVariables.secondaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<String?> _showImagePickerOptions(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final imagePath = await pickImageFromGallery();
                Navigator.pop(context, imagePath);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                final imagePath = await pickImageFromCamera();
                Navigator.pop(context, imagePath);
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
        automaticallyImplyLeading: false,
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
                          ? (user.profilePicture.isEmpty
                              ? Container(
                                  width: 150,
                                  height: 150,
                                  color:
                                      GlobalVariables.darkerGreyBackgroundColor,
                                  child: const Center(
                                    child: Text(
                                      "😎",
                                      style: TextStyle(fontSize: 50),
                                    ),
                                  ),
                                )
                              : Consumer<UserProvider>(
                                  builder: (context, userProvider, child) {
                                    return CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      imageUrl:
                                          userProvider.user.profilePicture,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      width: 150.0,
                                      height: 150.0,
                                    );
                                  },
                                ))
                          : kIsWeb
                              ? Image.network(
                                  pickedImagePath,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
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
                        onTap: () async {
                          final tempImage =
                              await _showImagePickerOptions(context);
                          if (tempImage != null)
                            _showConfirmationProfilePhotoScreen(
                                context, tempImage);
                        },
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
                    child: Text(
                      "Account Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey[500]),
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
                    enableEditing: false,
                  ),
                  ProfileTextfield(
                    prefixText: "Payment Number",
                    controller: cardNumberController,
                    prefixIcon: Icons.payment,
                    keyType: TextInputType.number,
                  ),
                  const ProfileButton(
                      title: "Change Password",
                      leadingIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      )),
                ],
              ),
              // const CardList(),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Integrations",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey[500]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const ProfileButton(
                      title: "Connect to Open Finance",
                      leadingIcon: Icon(Icons.handshake))
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Subscription",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey[500]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const PremiumSubscriptionField(),
                  const ProfileButton(
                    title: "Subscription",
                    leadingIcon: Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "App Settings",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey[500]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const ProfileButton(
                    title: "Currency",
                    leadingIcon: Icon(
                      Icons.currency_exchange_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const ProfileButton(
                    title: "Notifications",
                    leadingIcon: Icon(
                      Icons.notifications,
                      color: Colors.amber,
                    ),
                  ),
                  SettingsSwitch(
                    title: "Double Chart Analytics",
                    leadingIcon: const Icon(Icons.bar_chart_rounded),
                    initialValue: preferencesProvider.chartType == "double",
                    onChanged: (change) async {
                      await preferencesService.setChart(
                          change ? "double" : "single", context);
                    },
                  ),
                  SettingsSwitch(
                    title: "Spending Pulse",
                    leadingIcon: const Icon(Icons.monitor_heart_rounded),
                    initialValue: preferencesProvider.spendingPulse,
                    onChanged: (change) async {
                      await preferencesService.setSpendingPulse(
                          change, context);
                    },
                  ),
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Help and Support",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey[500]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ProfileButton(
                    onTap: () {
                      showWebViewModalBottomSheet(
                          context: context,
                          url: "https://wortheverypenny.vercel.app/help-center",
                          title: "Hi ${user.displayName} 👋");
                    },
                    title: "Contact Support",
                    leadingIcon: const Icon(
                      Icons.support,
                      color: Colors.redAccent,
                    ),
                  ),
                  ProfileButton(
                    title: "Request Features or Report Bugs",
                    onTap: () async {
                      //_showFeatureWebView(context);
                      if (kIsWeb) {
                        final url =
                            "https://webview.canny.io?boardToken=cdb606fe-8483-7567-f363-76e7fab5ba64&ssoToken=$cannyToken";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url));
                        } else {
                          throw 'Could not launch $url';
                        }
                      } else {
                        showWebViewModalBottomSheet(
                            context: context,
                            url:
                                "https://webview.canny.io?boardToken=cdb606fe-8483-7567-f363-76e7fab5ba64&ssoToken=$cannyToken",
                            title: "Hi ${user.displayName} 👋",
                            subtitle: "Got anything to share with us?");
                      }
                    },
                    leadingIcon: const Icon(
                      Icons.how_to_vote,
                      color: GlobalVariables.secondaryColor,
                    ),
                  ),
                  const ProfileButton(
                    title: "About the App",
                    leadingIcon: Icon(
                      Icons.people,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Account Management",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey[500]),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ProfileButton(
                    onTap: () async {
                      bool isConfirmed = await showConfirmationDialog(context,
                          "Are you sure you want to logout?", "Logout");
                      if (isConfirmed) {
                        if (context.mounted) {
                          settingsService.logout(context);
                        }
                      }
                    },
                    title: "Logout",
                    leadingIcon: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                  ),
                  const ProfileButton(
                    title: "Delete Account Permanently",
                    leadingIcon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
