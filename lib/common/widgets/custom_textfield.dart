import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldType {
  text,
  email,
  password,
  number,
  phone,
  currency,
  username
}

class CustomTextField extends StatefulWidget {
  final String label;
  final bool required;
  final String? hint;
  final TextFieldType type;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.label,
    this.required = false,
    this.hint,
    this.type = TextFieldType.text,
    required this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  late FocusNode _focusNode;
  String? _errorText;
  bool _isDirty = false;

  final _errorColor = const Color(0xFFFF5733);
  final _backgroundColor = const Color(0xFF1A1A1A);
  final _borderRadius = 12.0;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    
    // Add listener for real-time validation
    widget.controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    widget.controller.removeListener(_validateInput);
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus && !_isDirty) {
      setState(() => _isDirty = true);
      _validateInput();
    }
  }

  void _validateInput() {
    if (!_isDirty && widget.controller.text.isEmpty) return;

    setState(() {
      _errorText = _getValidatorFunction(widget.controller.text);
    });
  }

  String? _getValidatorFunction(String? value) {
    if (widget.validator != null) return widget.validator!(value);

    if (widget.required && (value == null || value.isEmpty)) {
      return '${widget.label} is required';
    }

    if (value == null || value.isEmpty) return null;

    switch (widget.type) {
      case TextFieldType.email:
        return _emailValidator(value);
      case TextFieldType.username:
        return _usernameValidator(value);
      case TextFieldType.password:
        return _passwordValidator(value);
      case TextFieldType.phone:
        return _phoneValidator(value);
      case TextFieldType.number:
        return _numberValidator(value);
      default:
        return null;
    }
  }

  String? _emailValidator(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value) ? null : 'Invalid email format';
  }

  String? _usernameValidator(String value) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (value.length < 8 || value.length > 20) {
      return 'Username must be between 8 and 20 characters';
    }
    return usernameRegex.hasMatch(value) 
        ? null 
        : 'Username can only contain letters, numbers, underscores, and dashes';
  }

  String? _passwordValidator(String value) {
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _phoneValidator(String value) {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(value) ? null : 'Invalid phone number format';
  }

  String? _numberValidator(String value) {
    final numberRegex = RegExp(r'^\d+$');
    return numberRegex.hasMatch(value) ? null : 'Invalid number format';
  }

  String _formatCurrency(String value) {
    final number = int.tryParse(value.replaceAll(RegExp(r'\D'), '')) ?? 0;
    return 'Rp ${number.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: hasError ? _errorColor : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.required)
                  Text(
                    '*',
                    style: TextStyle(
                      color: hasError ? _errorColor : Colors.white,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

        // TextField
        Container(
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: hasError ? _errorColor : Colors.transparent,
              width: 1,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.type == TextFieldType.password && _obscureText,
            enabled: widget.enabled,
            onChanged: (value) {
              _isDirty = true;
              if (widget.type == TextFieldType.currency) {
          final formattedValue = _formatCurrency(value);
          widget.controller.value = TextEditingValue(
            text: formattedValue,
            selection: TextSelection.collapsed(offset: formattedValue.length),
          );
          final numericValue = double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
          widget.onChanged?.call(numericValue.toString());
              } else {
          widget.onChanged?.call(value);
              }
            },
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            keyboardType: widget.type == TextFieldType.number || widget.type == TextFieldType.currency
          ? TextInputType.number
          : TextInputType.text,
            inputFormatters: widget.type == TextFieldType.number || widget.type == TextFieldType.currency
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
              ),
              contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
              ),
              border: InputBorder.none,
              suffixIcon: widget.type == TextFieldType.password
            ? IconButton(
                icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
                ),
                onPressed: () {
            setState(() => _obscureText = !_obscureText);
                },
              )
            : null,
            ),
          ),
        ),

        // Error Text
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: _errorColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}