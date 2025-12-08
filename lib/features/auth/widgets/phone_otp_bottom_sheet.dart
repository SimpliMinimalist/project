
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class PhoneAndOtpBottomSheet extends StatefulWidget {
  const PhoneAndOtpBottomSheet({super.key});

  @override
  State<PhoneAndOtpBottomSheet> createState() => _PhoneAndOtpBottomSheetState();
}

class _PhoneAndOtpBottomSheetState extends State<PhoneAndOtpBottomSheet> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _showOtp = false;
  bool _isPhoneValid = false;
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _isPhoneValid = _phoneController.text.length == 10;
      });
    });
  }

  void _switchToOtp() {
    setState(() {
      _showOtp = true;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: _showOtp ? _buildOtpView(context) : _buildPhoneView(context),
    );
  }

  Widget _buildPhoneView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Phone Number',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8.0),
        Text(
          'We\'ll send a code to verify your phone',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24.0),
        TextField(
          controller: _phoneController,
          autofocus: true,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          decoration: const InputDecoration(
            prefixText: '+91 - ',
            counterText: "",
          ),
        ),
        const SizedBox(height: 24.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isPhoneValid ? _switchToOtp : null,
            child: const Text('Send OTP'),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Widget _buildOtpView(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: const Color.fromRGBO(30, 60, 87, 1),
    );

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: textStyle,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: Theme.of(context).primaryColor),
        color: Theme.of(context).primaryColor.withAlpha(26),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter OTP',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8.0),
        Text(
          '6-digit code sent to +91 ${_phoneController.text}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24.0),
        Pinput(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          controller: _otpController,
          length: 6,
          autofocus: true,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          onChanged: (value) {
            setState(() {
              _isOtpValid = value.length == 6;
            });
          },
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Didn\'t receive a code? ',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Resend in 0:59'),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isOtpValid
                ? () {
                    Navigator.pop(context);
                    context.go('/store-setup');
                  }
                : null,
            child: const Text('Verify OTP'),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
