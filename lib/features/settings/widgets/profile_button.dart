import 'package:flutter/material.dart';
import 'package:swappp/constants/global_variables.dart';

class ProfileButton extends StatefulWidget {
  final void Function()? onPressed;
  final String title;
  final Icon leadingIcon;
  final void Function()? onTap;
  
  const ProfileButton({
    super.key, 
    this.onPressed, 
    required this.title, 
    required this.leadingIcon, 
    this.onTap
  });

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        _animationController.reverse();
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: _isPressed ? 0.9 : 1.0,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: GlobalVariables.greyBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: _isPressed 
                    ? [] 
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Color.fromARGB(255, 73, 70, 70),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

