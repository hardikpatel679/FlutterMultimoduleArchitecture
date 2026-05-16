import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/widgets/custom_text_field.dart';
import 'package:core/widgets/custom_text.dart';
import 'package:core/generated/l10n/app_localizations.dart';
import 'package:core/constants/app_constants.dart';
import '../dashboard/dashboard_page.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();
    
    // Use a local helper to avoid null errors without blocking the test runner
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spaceLarge,
              vertical: AppConstants.spaceHuge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.blur_on, size: AppConstants.iconSizeLarge, color: Colors.blueAccent),
                
                // appName
                CustomText(l10n?.appName ?? 'CONNECT', variant: TextVariant.h2, letterSpacing: 2),
                const SizedBox(height: AppConstants.spaceXXLarge),

                // welcomeBack
                CustomText(l10n?.welcomeBack ?? 'Welcome Back', variant: TextVariant.h1),
                
                // loginSubtitle
                CustomText(l10n?.loginSubtitle ?? 'Log in to continue.', variant: TextVariant.subtitle),
                const SizedBox(height: AppConstants.spaceExtraLarge),

                // Username Input
                CustomTextField(
                  textFieldKey: const Key(AppConstants.keyUsernameField),
                  controller: loginViewModel.usernameController,
                  labelText: l10n?.username ?? 'Username',
                  hintText: l10n?.usernameHint ?? 'emilys',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: AppConstants.spaceMedium),

                // Password Input
                CustomTextField(
                  textFieldKey: const Key(AppConstants.keyPasswordField),
                  controller: loginViewModel.passwordController,
                  labelText: l10n?.password ?? 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: !loginViewModel.isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      loginViewModel.isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: loginViewModel.togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: AppConstants.spaceMedium),

                // Log In Button
                SizedBox(
                  width: double.infinity,
                  height: AppConstants.buttonHeight,
                  child: ElevatedButton(
                    key: const Key(AppConstants.keyLoginButton),
                    onPressed: loginViewModel.isLoading ? null : () async {
                      await loginViewModel.login();
                      if (!context.mounted) return;
                      if (loginViewModel.user != null) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
                    ),
                    child: loginViewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : CustomText(l10n?.login ?? 'Log In', color: Colors.white, variant: TextVariant.button),
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
