import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class SettingsSwitch extends StatefulWidget {
  final String title;
  final Icon leadingIcon;
  final bool initialValue;
  final void Function(bool)? onChanged;

  const SettingsSwitch({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.initialValue = false,
    this.onChanged,
  });

  @override
  _SettingsSwitchState createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  late bool _isSwitched;

  @override
  void initState() {
    super.initState();
    _isSwitched = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: GlobalVariables.greyBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.leadingIcon,
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Switch(
            value: _isSwitched,
            onChanged: (value) {
              setState(() {
                _isSwitched = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
