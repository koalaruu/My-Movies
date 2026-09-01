import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.kSurface,
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Keluar dari akun demo sekarang?',
            style: TextStyle(color: AppColors.kOnSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('username');

    if (!context.mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Logout',
      icon: const Icon(Icons.logout),
      onPressed: () => _showLogoutDialog(context),
    );
  }
}
