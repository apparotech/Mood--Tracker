import 'package:flutter/material.dart';

class Validators {
  static String? notEmpty(String? v, {String field = 'This field'}) {
    if (v == null || v.trim().isEmpty)
      return '$field is required';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final r = RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!r.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Min 6 characters required';
    return null;
  }

  static String? confirmPassword(String? v, String original) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != original) return 'Passwords do not match';
    return null;
  }
}

/// Show a consistent, nice snackbar across the app.
void showAppSnack(
    BuildContext context, {
      required String message,
      bool success = false,
      Duration duration = const Duration(seconds: 3),
    }) {
  final theme = Theme.of(context);
  final bg = success
      ? theme.colorScheme.secondaryContainer
      : theme.colorScheme.errorContainer;
  final fg = success
      ? theme.colorScheme.onSecondaryContainer
      : theme.colorScheme.onErrorContainer;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: bg,
        content: Row(
          children: [
            Icon(success ? Icons.check_circle : Icons.error_outline, color: fg),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(color: fg))),
          ],
        ),
        duration: duration,
      ),
    );
}
