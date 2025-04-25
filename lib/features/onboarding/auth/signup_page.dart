import 'package:flutter/material.dart';
import 'package:kliks/core/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      // Implement signup logic
      Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Fetch the current theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: theme.primaryColor, // Use theme's primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: theme.textTheme.bodyLarge, // Use theme's text style
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: theme.textTheme.bodyLarge, // Use theme's text style
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: theme.textTheme.bodyLarge, // Use theme's text style
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor, // Use theme's primary color
                ),
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                child: Text(
                  'Already have an account? Login',
                  style: theme.textTheme.bodyLarge, // Use theme's text style
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}