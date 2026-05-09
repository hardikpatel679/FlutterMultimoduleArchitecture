import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/constants/app_strings.dart';
import 'package:core/widgets/custom_text_field.dart';
import 'package:core/widgets/custom_text.dart';
import '../dashboard/dashboard_page.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();

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
                const CustomText(
                  AppStrings.appName,
                  variant: TextVariant.h2,
                  letterSpacing: 2,
                ),
                const SizedBox(height: 40),

                // Header Text
                const CustomText(
                  AppStrings.welcomeBack,
                  variant: TextVariant.h1,
                ),
                const CustomText(
                  AppStrings.loginSubtitle,
                  variant: TextVariant.subtitle,
                ),
                const SizedBox(height: 32),

                // Username Input
                CustomTextField(
                  key: const Key(AppStrings.username),
                  controller: loginViewModel.usernameController,
                  labelText: AppStrings.username,
                  hintText: AppStrings.usernameHint,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                // Password Input
                CustomTextField(
                  key: const Key(AppStrings.password),
                  controller: loginViewModel.passwordController,
                  labelText: AppStrings.password,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const CustomText(
                      AppStrings.forgotPassword,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: CustomText(
                                  '${AppStrings.loginSuccessful}${loginViewModel.user!.firstName}',
                                  color: Colors.white,
                              )),
                        );
                        // successful login navigate to dashboard
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
                        : const CustomText(
                            AppStrings.login,
                            color: Colors.white,
                            variant: TextVariant.button,
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Social Login Section
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomText(
                        AppStrings.orContinueWith,
                        variant: TextVariant.subtitle,
                      ),
                    ),
                    Expanded(child: Divider()),
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
                    const CustomText(AppStrings.dontHaveAccount),
                    GestureDetector(
                      onTap: () {},
                      child: const CustomText(
                        AppStrings.signUp,
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
