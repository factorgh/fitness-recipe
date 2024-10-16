import 'package:flutter/material.dart';

class NativeAlerts {
  void showSuccessAlert(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAnimatedAlert(context, 'Success', message, true);
    });
  }

  void showErrorAlert(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAnimatedAlert(context, 'Error', message, false);
    });
  }

  void _showAnimatedAlert(
      BuildContext context, String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnimatedNativeAlert(
          title: title,
          message: message,
          isSuccess: isSuccess,
          onDismiss: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
        );
      },
    );
  }
}

class AnimatedNativeAlert extends StatefulWidget {
  final String title;
  final String message;
  final bool isSuccess;
  final VoidCallback onDismiss;

  const AnimatedNativeAlert({
    super.key,
    required this.title,
    required this.message,
    required this.isSuccess,
    required this.onDismiss,
  });

  @override
  _AnimatedNativeAlertState createState() => _AnimatedNativeAlertState();
}

class _AnimatedNativeAlertState extends State<AnimatedNativeAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: NativeAlert(
        title: widget.title,
        message: widget.message,
        isSuccess: widget.isSuccess,
        onDismiss: widget.onDismiss,
      ),
    );
  }
}

// The NativeAlert widget
class NativeAlert extends StatelessWidget {
  final String title;
  final String message;
  final bool isSuccess;
  final VoidCallback onDismiss;

  const NativeAlert({
    super.key,
    required this.title,
    required this.message,
    this.isSuccess = true,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isSuccess ? Icons.check_circle_outline : Icons.error_outline,
              color: isSuccess ? Colors.green : Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: isSuccess ? Colors.green : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
