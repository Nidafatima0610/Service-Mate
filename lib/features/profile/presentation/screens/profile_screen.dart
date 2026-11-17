import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_constants.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/core/errors/app_exception.dart';
import 'package:service_mate/core/utils/input_validators.dart';
import 'package:service_mate/features/profile/presentation/providers/profile_providers.dart';
import 'package:service_mate/shared/widgets/app_button.dart';
import 'package:service_mate/shared/widgets/app_text_field.dart';
import 'package:service_mate/shared/widgets/error_state_view.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isSaving = false;
  bool _hasLoadedInitial = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _populateForm(String name, String email, String phone, String address) {
    if (!_hasLoadedInitial) {
      _nameController.text = name;
      _emailController.text = email;
      _phoneController.text = phone;
      _addressController.text = address;
      _hasLoadedInitial = true;
    }
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(profileNotifierProvider.notifier).updateProfile(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            address: _addressController.text.trim(),
          );

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated and saved successfully!'),
            backgroundColor: AppColors.midnightNavy,
          ),
        );
      }
    } on AppException catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload Profile',
            onPressed: () {
              setState(() => _hasLoadedInitial = false);
              ref.read(profileNotifierProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          _populateForm(
            profile.fullName,
            profile.email,
            profile.phoneNumber,
            profile.address,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Avatar & Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.midnightNavy,
                          child: Text(
                            profile.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.fullName,
                          style: AppTypography.displayMedium.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.tealSubtle,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Arrowstack Internship Demo Account',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.tealDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Fields
                  AppTextField(
                    controller: _nameController,
                    label: 'Display Name',
                    hint: 'Your full name',
                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                    validator: InputValidators.validateName,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'Your email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    validator: InputValidators.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'Your mobile phone',
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                    validator: InputValidators.validatePhone,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _addressController,
                    label: 'Default Service Address',
                    hint: 'Street, City, State',
                    prefixIcon: const Icon(Icons.home_outlined, size: 20),
                    validator: InputValidators.validateAddress,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 28),

                  // Save Button
                  AppButton(
                    label: 'Save Profile Changes',
                    isLoading: _isSaving,
                    onPressed: _handleSave,
                    variant: AppButtonVariant.primary,
                  ),
                  const SizedBox(height: 32),

                  // App Information Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App & Project Details',
                          style: AppTypography.label.copyWith(
                            color: AppColors.midnightNavy,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildInfoLine('Application', AppConstants.appName),
                        const SizedBox(height: 6),
                        _buildInfoLine('Build Version', AppConstants.appVersion),
                        const SizedBox(height: 6),
                        _buildInfoLine('Architecture', 'Riverpod + Repository Pattern'),
                        const SizedBox(height: 6),
                        _buildInfoLine('Storage Engine', 'SharedPreferences (Local Persistence)'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.midnightNavy),
        ),
        error: (err, _) => ErrorStateView(
          message: 'Failed to load profile: $err',
          onRetry: () => ref.read(profileNotifierProvider.notifier).refresh(),
        ),
      ),
    );
  }

  Widget _buildInfoLine(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.midnightNavy,
          ),
        ),
      ],
    );
  }
}
