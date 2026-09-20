import 'package:flutter/material.dart';
import 'package:nyetam/app.dart';
import 'package:nyetam/presentation/auth_controller.dart';
import 'package:nyetam/presentation/google_sign_in_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.controller});

  final AuthController controller;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _registering = false;
  bool _obscurePassword = true;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleAuthentication);
    widget.controller.initializeGoogle();
  }

  void _handleAuthentication() {
    if (_completed ||
        widget.controller.status != AuthStatus.authenticated ||
        !mounted) {
      return;
    }
    _completed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.pop(context, true);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleAuthentication);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_registering) {
      await widget.controller.register(
        fullName: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      await widget.controller.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) => Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: AppColors.forest,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.terrain, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _registering ? 'Create your account' : 'Welcome back',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _registering
                        ? 'Save places and build journeys across Cameroon.'
                        : 'Continue planning your Cameroon journey.',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 26),
                  SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(value: false, label: Text('Sign in')),
                      ButtonSegment(value: true, label: Text('Create account')),
                    ],
                    selected: {_registering},
                    onSelectionChanged: widget.controller.isBusy
                        ? null
                        : (selection) => setState(() {
                            _registering = selection.first;
                            widget.controller.clearError();
                          }),
                  ),
                  const SizedBox(height: 22),
                  if (_registering) ...[
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => (value?.trim().length ?? 0) < 2
                          ? 'Enter your full name'
                          : null,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      return email.contains('@') && email.contains('.')
                          ? null
                          : 'Enter a valid email address';
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    autofillHints: _registering
                        ? const [AutofillHints.newPassword]
                        : const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: _registering
                          ? '8+ characters with uppercase, lowercase and a number'
                          : null,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) => _validatePassword(
                      value ?? '',
                      requireStrongPassword: _registering,
                    ),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  if (widget.controller.error != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.controller.error!,
                        style: const TextStyle(
                          color: AppColors.clay,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: widget.controller.isBusy ? null : _submit,
                      child: Text(
                        widget.controller.isBusy
                            ? 'Please wait'
                            : _registering
                            ? 'Create account'
                            : 'Sign in',
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  buildGoogleSignInButton(
                    configured: widget.controller.googleConfigured,
                    enabled: !widget.controller.isBusy,
                    onPressed: widget.controller.signInWithGoogle,
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 17,
                        color: AppColors.forest,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your password and access token are stored securely.',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? _validatePassword(
  String password, {
  required bool requireStrongPassword,
}) {
  if (password.length < 8) return 'Use at least 8 characters';
  if (!requireStrongPassword) return null;
  if (!password.contains(RegExp('[A-Z]'))) {
    return 'Add at least one uppercase letter';
  }
  if (!password.contains(RegExp('[a-z]'))) {
    return 'Add at least one lowercase letter';
  }
  if (!password.contains(RegExp('[0-9]'))) {
    return 'Add at least one number';
  }
  return null;
}
