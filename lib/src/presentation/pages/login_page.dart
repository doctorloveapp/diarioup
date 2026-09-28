import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_environment.dart';
import '../controllers/login_controller.dart';
import '../design_system/diarioup_tokens.dart';
import '../l10n/app_copy.dart';
import '../providers/app_providers.dart';
import '../widgets/brand_mark.dart';
import '../widgets/responsive_content.dart';

final class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _schoolCodeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _schoolCodeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return AppCopy.requiredField;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final password = _passwordController.text;
    try {
      await ref
          .read(loginControllerProvider.notifier)
          .submit(
            schoolCode: _schoolCodeController.text,
            username: _usernameController.text,
            password: password,
          );
    } finally {
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final environment = ref.watch(appEnvironmentProvider);
    return Scaffold(
      body: ResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Align(
              alignment: Alignment.centerLeft,
              child: BrandMark(compact: true),
            ),
            const SizedBox(height: DiarioUpSpacing.xl),
            Text(
              AppCopy.loginTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: DiarioUpSpacing.xs),
            Text(AppCopy.loginBody),
            if (environment.flavor == AppFlavor.demo) ...<Widget>[
              const SizedBox(height: DiarioUpSpacing.lg),
              const _DemoBanner(),
            ],
            const SizedBox(height: DiarioUpSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(DiarioUpSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        controller: _schoolCodeController,
                        enabled: !loginState.isLoading,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: AppCopy.schoolCode,
                          prefixIcon: Icon(Icons.school_outlined),
                        ),
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: DiarioUpSpacing.md),
                      TextFormField(
                        controller: _usernameController,
                        enabled: !loginState.isLoading,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: AppCopy.username,
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: _requiredValidator,
                      ),
                      const SizedBox(height: DiarioUpSpacing.md),
                      TextFormField(
                        controller: _passwordController,
                        enabled: !loginState.isLoading,
                        obscureText: _obscurePassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        autofillHints: null,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: AppCopy.password,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: _requiredValidator,
                      ),
                      if (loginState.errorMessage != null) ...<Widget>[
                        const SizedBox(height: DiarioUpSpacing.md),
                        _ErrorMessage(message: loginState.errorMessage!),
                      ],
                      const SizedBox(height: DiarioUpSpacing.lg),
                      FilledButton(
                        onPressed: loginState.isLoading ? null : _submit,
                        child: loginState.isLoading
                            ? const SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(AppCopy.login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (loginState.profiles.length > 1) ...<Widget>[
              const SizedBox(height: DiarioUpSpacing.lg),
              Text(
                AppCopy.profileSelection,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: DiarioUpSpacing.xs),
              const Text(AppCopy.profileSelectionBody),
              const SizedBox(height: DiarioUpSpacing.sm),
              ...loginState.profiles.map(
                (profile) => Padding(
                  padding: const EdgeInsets.only(bottom: DiarioUpSpacing.xs),
                  child: Card(
                    child: ListTile(
                      minVerticalPadding: DiarioUpSpacing.sm,
                      leading: const Icon(Icons.account_circle_outlined),
                      title: Text(profile.displayLabel),
                      subtitle: profile.academicYear == null
                          ? null
                          : Text(profile.academicYear!),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      onTap: () => ref
                          .read(loginControllerProvider.notifier)
                          .selectProfile(profile),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _DemoBanner extends StatelessWidget {
  const _DemoBanner();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: DiarioUpColors.indaco.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(DiarioUpSpacing.sm),
        border: Border.all(color: DiarioUpColors.indaco),
      ),
      child: const Padding(
        padding: EdgeInsets.all(DiarioUpSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.science_outlined, color: DiarioUpColors.indaco),
            SizedBox(width: DiarioUpSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppCopy.demoTitle,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: DiarioUpSpacing.xxs),
                  Text(AppCopy.demoBody),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.error_outline_rounded, color: DiarioUpColors.ambra),
          const SizedBox(width: DiarioUpSpacing.xs),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
