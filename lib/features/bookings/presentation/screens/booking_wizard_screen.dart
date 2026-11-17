import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_mate/core/constants/app_colors.dart';
import 'package:service_mate/core/constants/app_typography.dart';
import 'package:service_mate/core/errors/app_exception.dart';
import 'package:service_mate/core/utils/currency_formatter.dart';
import 'package:service_mate/core/utils/date_formatter.dart';
import 'package:service_mate/core/utils/input_validators.dart';
import 'package:service_mate/features/bookings/presentation/providers/booking_providers.dart';
import 'package:service_mate/features/bookings/presentation/widgets/date_selector_strip.dart';
import 'package:service_mate/features/bookings/presentation/widgets/time_slot_selector.dart';
import 'package:service_mate/features/profile/presentation/providers/profile_providers.dart';
import 'package:service_mate/features/services/models/service_model.dart';
import 'package:service_mate/features/services/presentation/providers/service_providers.dart';
import 'package:service_mate/shared/widgets/app_button.dart';
import 'package:service_mate/shared/widgets/app_text_field.dart';

class BookingWizardScreen extends ConsumerStatefulWidget {
  final ServiceModel service;

  const BookingWizardScreen({super.key, required this.service});

  @override
  ConsumerState<BookingWizardScreen> createState() => _BookingWizardScreenState();
}

class _BookingWizardScreenState extends ConsumerState<BookingWizardScreen> {
  int _currentStep = 0; // 0: DateTime, 1: Details, 2: Review

  // Step 1: Date & Time
  late DateTime _selectedDate;
  String? _selectedTimeSlot;

  // Step 2: Form & Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day + 1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(profileNotifierProvider).value;
      if (profile != null) {
        if (_nameController.text.isEmpty) _nameController.text = profile.fullName;
        if (_emailController.text.isEmpty) _emailController.text = profile.email;
        if (_phoneController.text.isEmpty) _phoneController.text = profile.phoneNumber;
        if (_addressController.text.isEmpty) _addressController.text = profile.address;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_selectedTimeSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an available appointment time slot to continue.'),
            backgroundColor: AppColors.midnightNavy,
          ),
        );
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _currentStep = 2);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _errorMessage = null;
        _currentStep--;
      });
    } else {
      context.pop();
    }
  }

  Future<void> _handleConfirmBooking() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final booking = await ref.read(bookingsNotifierProvider.notifier).createBooking(
            serviceId: widget.service.id,
            serviceName: widget.service.name,
            serviceCategory: widget.service.categoryName,
            providerName: widget.service.providerName,
            date: _selectedDate,
            timeSlot: _selectedTimeSlot!,
            customerName: _nameController.text.trim(),
            customerEmail: _emailController.text.trim(),
            customerPhone: _phoneController.text.trim(),
            customerAddress: _addressController.text.trim(),
            specialInstructions: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            basePrice: widget.service.price,
          );

      if (mounted) {
        context.go('/booking-confirmation', extra: booking);
      }
    } on BookingDuplicateException catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.message;
      });
    } on AppException catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'An unexpected error occurred while saving your booking. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _previousStep,
        ),
      ),
      body: Column(
        children: [
          _buildStepHeader(),

          if (_errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.statusErrorBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.statusError.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, color: AppColors.statusError, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.statusError,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentStepContent(),
            ),
          ),

          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildStepHeader() {
    final steps = ['Date & Time', 'Your Details', 'Confirm'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index == _currentStep;
          final isPast = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isPast
                        ? AppColors.tealAccent
                        : isActive
                            ? AppColors.midnightNavy
                            : AppColors.surfaceMuted,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive || isPast ? Colors.transparent : AppColors.borderLight,
                    ),
                  ),
                  child: Center(
                    child: isPast
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isActive ? Colors.white : AppColors.textMuted,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? AppColors.midnightNavy
                          : (isPast ? AppColors.textPrimary : AppColors.textMuted),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 14,
                    height: 1.5,
                    color: isPast ? AppColors.tealAccent : AppColors.borderLight,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDateTimeStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDateTimeStep() {
    final slotRequest = SlotRequest(
      serviceId: widget.service.id,
      date: _selectedDate,
    );
    final slotsAsync = ref.watch(availableSlotsProvider(slotRequest));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.tealSubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.home_repair_service_rounded, color: AppColors.tealAccent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.service.name,
                      style: AppTypography.title.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${widget.service.providerName} • ${widget.service.durationString}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Select Date',
          style: AppTypography.label.copyWith(color: AppColors.midnightNavy, fontSize: 14),
        ),
        const SizedBox(height: 10),
        DateSelectorStrip(
          selectedDate: _selectedDate,
          onDateSelected: (newDate) {
            setState(() {
              _selectedDate = newDate;
              _selectedTimeSlot = null;
            });
          },
        ),
        const SizedBox(height: 24),

        Text(
          'Select Time Slot',
          style: AppTypography.label.copyWith(color: AppColors.midnightNavy, fontSize: 14),
        ),
        const SizedBox(height: 10),

        slotsAsync.when(
          data: (slots) => TimeSlotSelector(
            slots: slots,
            selectedSlot: _selectedTimeSlot,
            onSlotSelected: (slot) => setState(() => _selectedTimeSlot = slot),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.midnightNavy),
            ),
          ),
          error: (err, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Error loading slots: $err',
              style: const TextStyle(color: AppColors.statusError),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact & Service Address',
            style: AppTypography.title.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Provider will arrive at the address below on your scheduled time.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 18),

          AppTextField(
            controller: _nameController,
            label: 'Full Name *',
            hint: 'e.g. John Doe',
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
            validator: InputValidators.validateName,
          ),
          const SizedBox(height: 14),

          AppTextField(
            controller: _phoneController,
            label: 'Phone Number *',
            hint: '+1 (555) 000-0000',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
            validator: InputValidators.validatePhone,
          ),
          const SizedBox(height: 14),

          AppTextField(
            controller: _emailController,
            label: 'Email Address *',
            hint: 'john.doe@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: InputValidators.validateEmail,
          ),
          const SizedBox(height: 14),

          AppTextField(
            controller: _addressController,
            label: 'Service Address *',
            hint: 'Street, Apt/Suite, City, State, ZIP',
            prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
            validator: InputValidators.validateAddress,
            maxLines: 2,
          ),
          const SizedBox(height: 14),

          AppTextField(
            controller: _notesController,
            label: 'Special Instructions (Optional)',
            hint: 'Gate code, parking instructions, specific requests...',
            prefixIcon: const Icon(Icons.note_alt_outlined, size: 20),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    final basePrice = widget.service.price;
    final serviceFee = double.parse((basePrice * 0.05).toStringAsFixed(2));
    final tax = double.parse(((basePrice + serviceFee) * 0.08).toStringAsFixed(2));
    final total = double.parse((basePrice + serviceFee + tax).toStringAsFixed(2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                'Appointment Summary',
                style: AppTypography.title.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 12),
              _buildReviewRow(Icons.business_center_rounded, 'Service', widget.service.name),
              const SizedBox(height: 8),
              _buildReviewRow(Icons.storefront_rounded, 'Provider', widget.service.providerName),
              const SizedBox(height: 8),
              _buildReviewRow(
                Icons.calendar_month_rounded,
                'Date',
                DateFormatter.formatFullDate(_selectedDate),
              ),
              const SizedBox(height: 8),
              _buildReviewRow(
                Icons.schedule_rounded,
                'Time Slot',
                '$_selectedTimeSlot (${widget.service.durationString})',
              ),
              const SizedBox(height: 8),
              _buildReviewRow(
                Icons.location_on_outlined,
                'Location',
                _addressController.text.trim(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Information', style: AppTypography.title.copyWith(fontSize: 15)),
              const SizedBox(height: 10),
              _buildReviewRow(Icons.person_outline, 'Name', _nameController.text.trim()),
              const SizedBox(height: 6),
              _buildReviewRow(Icons.phone_outlined, 'Phone', _phoneController.text.trim()),
              const SizedBox(height: 6),
              _buildReviewRow(Icons.email_outlined, 'Email', _emailController.text.trim()),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pricing & Payment', style: AppTypography.title.copyWith(fontSize: 15)),
              const SizedBox(height: 12),
              _buildPriceLine('Base Price', basePrice),
              const SizedBox(height: 6),
              _buildPriceLine('Service Fee (5%)', serviceFee),
              const SizedBox(height: 6),
              _buildPriceLine('Estimated Tax (8%)', tax),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: AppTypography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.midnightNavy,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatWithDecimals(total),
                    style: AppTypography.headline.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.midnightNavy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warmAmberLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.warmAmber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Simulated Booking: No real payment method is charged. Confirmed appointments are stored locally on your device.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmAmber,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 8),
        SizedBox(
          width: 75,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceLine(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
        Text(
          CurrencyFormatter.formatWithDecimals(amount),
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final isLastStep = _currentStep == 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : _previousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: AppButton(
                label: isLastStep ? 'Confirm & Book' : 'Continue',
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : (isLastStep ? _handleConfirmBooking : _nextStep),
                variant: isLastStep ? AppButtonVariant.secondary : AppButtonVariant.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
