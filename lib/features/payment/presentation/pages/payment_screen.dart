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
    {'amount': 250, 'title': 'esspresso', 'icon': '☕'},
    {'amount': 500, 'title': 'mocha', 'icon': '☕'},
    {'amount': 1000, 'title': 'latte', 'icon': '☕'},
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Payment Initiated',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'M-Pesa payment request sent!',
              style: GoogleFonts.montserrat(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: KSH ${amount.toStringAsFixed(0)}',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              'Phone: $formattedPhone',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Check your phone for the M-Pesa prompt and enter your PIN to complete the payment.',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'buy-me-coffee-hero',
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Text(
                  'Support Wakili',
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Buy me a coffee to keep WAKILI brewing',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor:
            isDarkMode ? Colors.grey[900] : AppColors.coffeeBrownDark,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Coffee options with improved layout
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _coffeeOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) => CoffeeOptionCard(
                  amount: _coffeeOptions[index]['amount'],
                  title: _coffeeOptions[index]['title'],
                  icon: _coffeeOptions[index]['icon'],
                  // description: _coffeeOptions[index]['desc'],
                  showSteamAnimation: true,
                  isSelected:
                      _selectedAmount == _coffeeOptions[index]['amount'] &&
                          !_isCustomAmount,
                  onTap: () => _selectAmount(_coffeeOptions[index]['amount']),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Custom amount input
            CustomAmountInput(
              controller: _customAmountController,
              focusNode: _customAmountFocusNode,
              isSelected: _isCustomAmount,
              errorText: _amountError,
              onTap: _selectCustomAmount,
              onChanged: (_) => _validateCustomAmount(),
            ),

            const SizedBox(height: 12),

            // Payment section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Details',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.brown[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete your purchase with M-Pesa',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MpesaPhoneInput(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    errorText: _phoneError.isEmpty ? null : _phoneError,
                    onChanged: (_) => _validatePhone(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Payment button with improved design
            PaymentButton(
              isEnabled: _canProceed,
              amount: _finalAmount,
              onPressed: _processPurchase,
            ),

            const SizedBox(height: 14),

            // Footer with security info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  size: 16,
                  color: isDarkMode ? Colors.green[300] : Colors.green[700],
                ),
                const SizedBox(width: 8),
                Text(
                  'Secure payment powered by M-Pesa',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
