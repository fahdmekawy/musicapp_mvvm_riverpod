import 'package:client/core/extensions/context_extension.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../view_model/auth_view_model.dart';
import '../widgets/auth_gradient_button.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authViewModelProvider.select((value) => value?.isLoading == true));

    ref.listen(authViewModelProvider, (previous, next) {
      next?.when(
        data: (data) {
          // TO DO Navigate to home page
          showSnackBack(context, 'Login successfully');
        },
        error: (error, stack) {
          showSnackBack(context, error.toString(), isError: true);
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body: isLoading == true
          ? const Loader()
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign In.',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: 'Email',
                        textEditingController: _emailController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: 'Password',
                        obscureText: true,
                        textEditingController: _passwordController,
                      ),
                      const SizedBox(height: 15),
                      AuthGradientButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .loginUser(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim());
                          } else {
                            showSnackBack(
                              context,
                              'Missing Fields!',
                              isError: true,
                            );
                          }
                        },
                        buttonText: 'Sign In',
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => context.navigateTo(const SignupPage()),
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.gradient2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ],
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
