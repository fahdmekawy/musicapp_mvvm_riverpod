import 'package:client/core/extensions/context_extension.dart';
import 'package:client/core/utils/show_snack_bar.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loader.dart';
import '../widgets/auth_gradient_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
          showSnackBack(context, 'Account created successfully! Please login.');
          context.navigateAndReplace(const LoginPage());
        },
        error: (error, stack) {
          showSnackBack(context, error.toString(), isError: true);
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
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
                        'Sign Up.',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                          hintText: 'Name',
                          textEditingController: _nameController),
                      const SizedBox(height: 15),
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
                                .signupUser(
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                          } else {
                            showSnackBack(
                              context,
                              'Missing fields',
                              isError: true,
                            );
                          }
                        },
                        buttonText: 'Sign Up',
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account?  ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Sign In',
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
