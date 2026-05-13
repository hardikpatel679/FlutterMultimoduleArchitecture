import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/widgets/custom_text.dart';
import 'package:core/viewmodels/locale_viewmodel.dart';
import 'package:core/generated/l10n/app_localizations.dart';
import '../login/login_page.dart';
import '../login/login_viewmodel.dart';
import 'dashboard_viewmodel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<DashboardViewModel>();
      viewModel.connect();
      viewModel.fetchBatteryLevel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final loginViewModel = context.read<LoginViewModel>();
    final localString = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(localString.dashboardTitle),
        actions: [
          IconButton(
            tooltip: localString.logout,
            onPressed: () {
              viewModel.disconnect();
              loginViewModel.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.dashboard, size: 100, color: Colors.blueAccent),
                const SizedBox(height: 20),
                CustomText(
                  localString.welcomeDashboard,
                  variant: TextVariant.h2,
                ),
                const SizedBox(height: 10),
                
                // Battery Level Display
                if (viewModel.batteryLevel != null)
                  CustomText(
                    localString.batteryLevel(viewModel.batteryLevel!),
                    variant: TextVariant.h3,
                    color: Colors.blueGrey,
                  ),
                const SizedBox(height: 20),

                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else if (viewModel.error != null)
                  CustomText(
                    localString.errorMessage(viewModel.error!),
                    color: Colors.red,
                  )
                else
                  CustomText(
                    localString.liveUpdates(viewModel.data ?? 0),
                    variant: TextVariant.h3,
                    color: Colors.green,
                  ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => viewModel.resetDashboard(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: CustomText(
                      localString.resetStream,
                      variant: TextVariant.button,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<LocaleViewModel>().toggleLocale(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: CustomText(
                      localString.toggleLanguage,
                      variant: TextVariant.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
