import 'package:flutter/material.dart';

Widget buildGoogleSignInButton({
  required bool configured,
  required bool enabled,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      label: const Text('Continue with Google'),
    ),
  );
}
