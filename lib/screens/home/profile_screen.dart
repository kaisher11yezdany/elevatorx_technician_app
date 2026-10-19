import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final tech = authProvider.technician;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.primary, Color(0xFF2C5AA0)]),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            '${tech?.name?.split(' ').first.characters.first ?? 'T'}${tech?.name?.split(' ').last.characters.first ?? 'A'}',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(tech?.name ?? 'Technician', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(tech?.role ?? 'Field Technician', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoCard('Employee ID', tech?.employeeId ?? 'N/A', Icons.badge),
                      const SizedBox(height: 12),
                      _buildInfoCard('Email', tech?.email ?? 'N/A', Icons.email),
                      const SizedBox(height: 12),
                      _buildInfoCard('Phone', tech?.phone ?? 'N/A', Icons.phone),
                      const SizedBox(height: 12),
                      _buildInfoCard('Department', tech?.department ?? 'N/A', Icons.business),
                      const SizedBox(height: 12),
                      _buildInfoCard('Territory', tech?.territory ?? 'N/A', Icons.location_on),
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Logout',
                        onPressed: () {
                          authProvider.logout();
                          GoRouter.of(context).go('/login');
                        },
                        backgroundColor: AppColors.danger,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
