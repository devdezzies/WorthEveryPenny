import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:swappp/features/settings/services/settings_service.dart';
import 'package:swappp/features/settings/widgets/profile_button.dart';
import 'package:swappp/features/settings/widgets/profile_textfield.dart';
import 'package:swappp/constants/global_variables.dart';
import 'package:swappp/constants/utils.dart';
import 'package:swappp/features/settings/widgets/subscription/premium_subscription_field.dart';
import 'package:swappp/models/user.dart';
import 'package:swappp/providers/user_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String, String, String) onLeave;
  const SettingsScreen({super.key, required this.onLeave});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late User user;
  late String token;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final SettingsService settingsService = SettingsService();
  late WebViewController webViewController;
  String pickedImagePath = "";
  String? cachedToken = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = Provider.of<UserProvider>(context, listen: false).user;
    usernameController.text = user.displayName;
    emailController.text = user.email;
    cardNumberController.text = user.paymentNumber;
    _initializeWebView();
  }

  @override
  void dispose() {
    widget.onLeave(usernameController.text, cardNumberController.text, pickedImagePath);
    usernameController.dispose();
    emailController.dispose();
    cardNumberController.dispose();
    super.dispose();
  }

  Future<void> _initializeWebView() async {
    settingsService
        .createCannyToken(
            context: context, id: user.id, name: user.username, email: user.email)
        .then((token) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(NavigationDelegate(
          onProgress: (_) {
            const CircularProgressIndicator();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ))
        ..loadRequest(Uri.parse(
            'https://webview.canny.io?boardToken=cdb606fe-8483-7567-f363-76e7fab5ba64&ssoToken=$token'));
    });

  }

  void _showFeatureWebView(BuildContext context) {
    // Initialize the webview controller
    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    color: GlobalVariables.backgroundColor,
                    child: const Text(
                      "Report or Request Features",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: WebViewWidget(controller: webViewController),
                      ),
                    ),
                  ),
                ],
              ),
            ));
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
                                  user.profilePicture,
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
                    child: const Text(
                      "Integrations",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                    child: const Text(
                      "Subscription",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                    child: const Text(
                      "App Settings",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text(
                      "Help and Support",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const ProfileButton(
                    title: "Contact Support",
                    leadingIcon: Icon(
                      Icons.support,
                      color: Colors.redAccent,
                    ),
                  ),
                  ProfileButton(
                    title: "Request Features or Report Bugs",
                    onTap: () {
                      _showFeatureWebView(context);
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
                    child: const Text(
                      "Account Management",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const ProfileButton(
                    title: "Logout",
                    leadingIcon: Icon(
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
