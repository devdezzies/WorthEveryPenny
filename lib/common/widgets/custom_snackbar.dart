import 'package:flutter/material.dart';

enum SnackBarType { success, warning, error }

class CustomSnackBar extends StatelessWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback? onDismissed;

  const CustomSnackBar({
    super.key,
    required this.message,
    this.type = SnackBarType.success,
    this.duration = const Duration(seconds: 4),
    this.onDismissed,
  });

  Color get backgroundColor {
    switch (type) {
      case SnackBarType.success:
        return const Color(0xFF4CAF50);
      case SnackBarType.warning:
        return const Color(0xFFFFA000);
      case SnackBarType.error:
        return const Color(0xFFE53935);
    }
  }

  IconData get icon {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_rounded;
      case SnackBarType.error:
        return Icons.error_outline;
    }
  }

  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.success,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onDismissed,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBarOverlay(
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          overlayEntry.remove();
          onDismissed?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSnackBarOverlay extends StatefulWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const CustomSnackBarOverlay({
    Key? key,
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<CustomSnackBarOverlay> createState() => _CustomSnackBarOverlayState();
}

class _CustomSnackBarOverlayState extends State<CustomSnackBarOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismissed());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(_animation),
            child: Center(
              child: CustomSnackBar(
                message: widget.message,
                type: widget.type,
              ),
            ),
          ),
        ),
      ),
    );
  }
}