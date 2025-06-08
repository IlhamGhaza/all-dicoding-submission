import 'package:flutter/material.dart';

class SnackbarUtils {
  final String text;
  final Color backgroundColor;

  final IconData? icon;

  SnackbarUtils({required this.text, required this.backgroundColor, this.icon});

  void _showSnackBar(
    BuildContext context, {
    required IconData defaultIcon,
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final IconData displayIcon = icon ?? defaultIcon;

    final SnackBarAction? snackBarAction =
        (actionLabel != null && onActionPressed != null)
            ? SnackBarAction(label: actionLabel, onPressed: onActionPressed)
            : null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(displayIcon, color: Colors.white),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 4),
        action: snackBarAction,
      ),
    );
  }

  void showSuccessSnackBar(
    BuildContext context, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showSnackBar(
      context,
      defaultIcon: Icons.check_circle,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  void showErrorSnackBar(
    BuildContext context, {
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    _showSnackBar(
      context,
      defaultIcon: Icons.error,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }
}


// SnackbarUtils(
//   text: 'Failed to load data.',
//   backgroundColor: Colors.red,
//   icon: Icons.cloud_off, // Optional icon override
// ).showErrorSnackBar(
//   context,
//   actionLabel: 'RETRY',
//   onActionPressed: () {
//     print('Retry button pressed!');
//     // Add your retry logic here
//   },
// );

// // Success snackbar with an "UNDO" action
// SnackbarUtils(
//   text: 'Item deleted.',
//   backgroundColor: Colors.blue, // Or another appropriate color
// ).showSuccessSnackBar(
//   context,
//   actionLabel: 'UNDO',
//   onActionPressed: () {
//     print('Undo button pressed!');
//     // Add your undo logic here
//   },
// );