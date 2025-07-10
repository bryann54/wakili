import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/payment/presentation/widgets/coffee_option_card.dart';
import 'package:wakili/features/payment/presentation/widgets/custom_amount_input.dart';
import 'package:wakili/features/payment/presentation/widgets/mpesa_phone_input.dart';
import 'package:wakili/features/payment/presentation/widgets/payment_button.dart';

@RoutePage()
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _customAmountController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _customAmountFocusNode = FocusNode();

  int? _selectedAmount;
  bool _isCustomAmount = false;
  String _phoneError = '';
  String _amountError = '';

  final List<Map<String, dynamic>> _coffeeOptions = [
    {'amount': 250, 'title': 'Single', 'icon': '☕'},
    {'amount': 500, 'title': 'Double', 'icon': '☕☕'},
    {'amount': 1000, 'title': 'Iced', 'icon': '🧊☕'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _customAmountController.dispose();
    _phoneFocusNode.dispose();
    _customAmountFocusNode.dispose();
    super.dispose();
  }

  bool get _isValidPhoneNumber {
    final phone = _phoneController.text.trim();
    return phone.length == 9 &&
        (phone.startsWith('7') || phone.startsWith('1'));
  }

  String _formatPhoneNumber(String phone) {
    return '+254$phone';
  }

  void _validatePhone() {
    setState(() {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (phone.length < 9) {
        _phoneError = 'Phone number must be 9 digits';
      } else if (!phone.startsWith('7') && !phone.startsWith('1')) {
        _phoneError = 'Number must start with 7 or 1';
      } else if (phone.length != 9) {
        _phoneError = 'Phone number must be exactly 9 digits';
      } else {
        _phoneError = '';
      }
    });
  }

  bool get _isValidAmount {
    if (_isCustomAmount) {
      final customAmount = int.tryParse(_customAmountController.text.trim());
      return customAmount != null &&
          customAmount >= 50 &&
          customAmount <= 50000;
    }
    return _selectedAmount != null;
  }

  bool get _canProceed => _isValidPhoneNumber && _isValidAmount;

  void _validateCustomAmount() {
    setState(() {
      final amountText = _customAmountController.text.trim();
      if (amountText.isEmpty) {
        _amountError = '';
      } else {
        final amount = int.tryParse(amountText);
        if (amount == null) {
          _amountError = 'Enter a valid amount';
        } else if (amount < 50) {
          _amountError = 'Minimum amount is KSH 50';
        } else if (amount > 50000) {
          _amountError = 'Maximum amount is KSH 50,000';
        } else {
          _amountError = '';
        }
      }
    });
  }

  void _selectAmount(int amount) {
    setState(() {
      _selectedAmount = amount;
      _isCustomAmount = false;
      _customAmountController.clear();
      _amountError = '';
    });
  }

  void _selectCustomAmount() {
    setState(() {
      _selectedAmount = null;
      _isCustomAmount = true;
    });
    _customAmountFocusNode.requestFocus();
  }

  int get _finalAmount {
    if (_isCustomAmount) {
      return int.tryParse(_customAmountController.text.trim()) ?? 0;
    }
    return _selectedAmount ?? 0;
  }

  void _processPurchase() {
    if (!_canProceed) return;

    final formattedPhone = _formatPhoneNumber(_phoneController.text.trim());
    final amount = _finalAmount;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Payment Initiated',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'M-Pesa payment request sent!',
              style: GoogleFonts.montserrat(),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: KSH ${amount.toStringAsFixed(0)}',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
            ),
            Text(
              'Phone: $formattedPhone',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              'Check your phone for the M-Pesa prompt and enter your PIN to complete the payment.',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: GoogleFonts.montserrat(color: AppColors.brandPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Hero(
              tag: 'buy-me-coffee-hero',
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                  fromHeroContext, toHeroContext) {
                // Custom return animation
                final Widget toHero = toHeroContext.widget;

                if (flightDirection == HeroFlightDirection.pop) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: Tween<double>(begin: 1.0, end: 0.8)
                            .animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.fastOutSlowIn,
                            ))
                            .value,
                        child: Opacity(
                          opacity: Tween<double>(begin: 1.0, end: 0.0)
                              .animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ))
                              .value,
                          child: toHero,
                        ),
                      );
                    },
                  );
                } else {
                  return toHero;
                }
              },
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      'Buy Wakili Coffee',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Support helps keep WAKILI running ☕',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.coffeeBrownDark,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Choose your support',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _coffeeOptions
                  .map((option) => CoffeeOptionCard(
                        amount: option['amount'],
                        title: option['title'],
                        icon: option['icon'],
                        showSteamAnimation: true,
                        isSelected: _selectedAmount == option['amount'] &&
                            !_isCustomAmount,
                        onTap: () => _selectAmount(option['amount']),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            CustomAmountInput(
              controller: _customAmountController,
              focusNode: _customAmountFocusNode,
              isSelected: _isCustomAmount,
              errorText: _amountError,
              onTap: _selectCustomAmount,
              onChanged: (_) => _validateCustomAmount(),
            ),
            const SizedBox(height: 32),
            MpesaPhoneInput(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              errorText: _phoneError.isEmpty ? null : _phoneError,
              onChanged: (_) => _validatePhone(),
            ),
            const SizedBox(height: 40),
            PaymentButton(
              isEnabled: _canProceed,
              amount: _finalAmount,
              onPressed: _processPurchase,
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Secure payment powered by M-Pesa',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
