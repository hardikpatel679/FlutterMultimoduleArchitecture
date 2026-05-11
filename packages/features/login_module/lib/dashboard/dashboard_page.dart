import 'package:flutter/material.dart';
import 'package:core/constants/app_strings.dart';
import 'package:core/widgets/custom_text.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(AppStrings.dashboardTitle),
        actions: [
          IconButton(
            onPressed: () {
              // Handle logout logic later
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 100, color: Colors.blueAccent),
            SizedBox(height: 20),
            CustomText(
              AppStrings.welcomeDashboard,
              variant: TextVariant.h2,
            ),
            SizedBox(height: 10),
            CustomText(
              AppStrings.loginSuccessSubtitle,
              variant: TextVariant.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
