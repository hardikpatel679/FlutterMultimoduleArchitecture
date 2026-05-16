import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/widgets/custom_text.dart';
import 'package:core/widgets/custom_text_field.dart';
import 'package:core/viewmodels/locale_viewmodel.dart';
import 'package:core/generated/l10n/app_localizations.dart';
import 'package:core/constants/app_constants.dart';
import 'package:login_module/login/login_page.dart';
import 'package:login_module/login/login_viewmodel.dart';
import 'package:login_module/dashboard/dashboard_viewmodel.dart';

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
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const Scaffold(
        body: Center(child: Text('Loading...')),
      );
    }

    final translations = l10n;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(translations.dashboardTitle),
        actions: [
          IconButton(
            tooltip: translations.logout,
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
            padding: const EdgeInsets.all(AppConstants.spaceLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppConstants.spaceXXLarge),
                const Icon(Icons.dashboard, size: AppConstants.iconSizeHuge, color: Colors.blueAccent),
                const SizedBox(height: AppConstants.spaceLarge),
                CustomText(
                  translations.welcomeDashboard,
                  variant: TextVariant.h2,
                ),
                const SizedBox(height: AppConstants.spaceSmall),
                
                // Battery Level Display
                if (viewModel.batteryLevel != null)
                  CustomText(
                    translations.batteryLevel(viewModel.batteryLevel!),
                    variant: TextVariant.h3,
                    color: Colors.blueGrey,
                  ),
                const SizedBox(height: AppConstants.spaceLarge),

                // New Input Textbox
                CustomTextField(
                  textFieldKey: const Key(AppConstants.keyDashboardInputField),
                  controller: viewModel.inputController,
                  labelText: translations.dashboardInputLabel,
                  hintText: translations.dashboardInputHint,
                  prefixIcon: Icons.edit_note,
                ),
                const SizedBox(height: AppConstants.spaceLarge),

                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else if (viewModel.error != null)
                  CustomText(
                    translations.errorMessage(viewModel.error!),
                    color: Colors.red,
                  )
                else
                  CustomText(
                    translations.liveUpdates(viewModel.data ?? 0),
                    variant: TextVariant.h3,
                    color: Colors.green,
                  ),
                const SizedBox(height: AppConstants.spaceExtraLarge),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => viewModel.resetDashboard(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceMedium),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
                    ),
                    child: CustomText(
                      translations.resetStream,
                      variant: TextVariant.button,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spaceMedium),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.read<LocaleViewModel>().toggleLocale(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceMedium),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
                    ),
                    child: CustomText(
                      translations.toggleLanguage,
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
