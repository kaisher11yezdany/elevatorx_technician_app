import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const Text('elevatorX', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
                const SizedBox(height: 8),
                const Text('Technician Portal', style: AppTextStyles.body2),
                const SizedBox(height: 48),
                const Text('Login', style: AppTextStyles.h2),
                const SizedBox(height: 32),
                AppTextField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Phone is required';
                    if (!RegExp(r'^\d{10}$').hasMatch(value!)) return 'Enter valid 10-digit number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator: (value) => value?.isEmpty ?? true ? 'Password is required' : null,
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return AppButton(
                      label: 'Login',
                      isLoading: authProvider.isLoading,
                      onPressed: (_formKey.currentState?.validate() ?? false)
                          ? () {
                              authProvider.loginWithPhone(
                                _phoneController.text,
                                _passwordController.text,
                              );
                            }
                          : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (context.watch<AuthProvider>().error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.danger),
                    ),
                    child: Text(
                      context.read<AuthProvider>().error ?? '',
                      style: TextStyle(color: AppColors.danger),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
