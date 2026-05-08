import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/constants/app_strings.dart';
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
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                const SizedBox(height: 40),

                // Header Text
                const Text(
                  AppStrings.welcomeBack,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  AppStrings.loginSubtitle,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // Username Input
                TextField(
                  key: const Key(AppStrings.username),
                  controller: loginViewModel.usernameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline),
                    labelText: AppStrings.username,
                    hintText: AppStrings.usernameHint,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Input
                TextField(
                  controller: loginViewModel.passwordController,
                  obscureText: true,
                  key: const Key(AppStrings.password),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: const Icon(Icons.visibility_off_outlined),
                    labelText: AppStrings.password,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.forgotPassword,
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                const SizedBox(height: 16),

                // Log In Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loginViewModel.isLoading ? null: () async {
                            await loginViewModel.login();
                            
                            if (!context.mounted) return;

                            if (loginViewModel.user != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${AppStrings.loginSuccessful}${loginViewModel.user!.firstName}')),
                              );
                              // successful login navigate to dashboard
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardPage()),
                              );
                            } else if (loginViewModel.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(loginViewModel.errorMessage!),
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
                        : const Text(AppStrings.login,
                            style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 24),

                // Social Login Section
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(AppStrings.orContinueWith,
                          style: TextStyle(color: Colors.grey)),
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
                    const Text(AppStrings.dontHaveAccount),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(AppStrings.signUp,
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
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
