import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/widgets/custom_text_field.dart';
import 'package:core/widgets/custom_text.dart';
import 'package:core/generated/l10n/app_localizations.dart';
import '../dashboard/dashboard_page.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();
    final localString = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo and Branding
                const Icon(Icons.blur_on, size: 80, color: Colors.blueAccent),
                CustomText(
                  localString.appName,
                  variant: TextVariant.h2,
                  letterSpacing: 2,
                ),
                const SizedBox(height: 40),

                // Header Text
                CustomText(
                  localString.welcomeBack,
                  variant: TextVariant.h1,
                ),
                CustomText(
                  localString.loginSubtitle,
                  variant: TextVariant.subtitle,
                ),
                const SizedBox(height: 32),

                // Username Input
                CustomTextField(
                  key: Key(localString.username),
                  controller: loginViewModel.usernameController,
                  labelText: localString.username,
                  hintText: localString.usernameHint,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                // Password Input
                CustomTextField(
                  key: Key(localString.password),
                  controller: loginViewModel.passwordController,
                  labelText: localString.password,
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: CustomText(
                      localString.forgotPassword,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Log In Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loginViewModel.isLoading ? null : () async {
                      await loginViewModel.login();
                      
                      if (!context.mounted) return;

                      if (loginViewModel.user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const DashboardPage()),
                        );
                      } else if (loginViewModel.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: CustomText(
                                loginViewModel.errorMessage!,
                                color: Colors.white,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: loginViewModel.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : CustomText(
                            localString.login,
                            color: Colors.white,
                            variant: TextVariant.button,
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Social Login Section
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomText(
                        localString.orContinueWith,
                        variant: TextVariant.subtitle,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.g_mobiledata, size: 40, color: Colors.red),
                    const SizedBox(width: 24),
                    const Icon(Icons.apple, size: 40, color: Colors.black),
                  ],
                ),
                const SizedBox(height: 40),

                // Sign Up Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(localString.dontHaveAccount),
                    GestureDetector(
                      onTap: () {},
                      child: CustomText(
                        localString.signUp,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
