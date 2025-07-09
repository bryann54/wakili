import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';

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
    final kenyanPhoneRegex = RegExp(r'^(\+?254|0)?[17]\d{8}$');
    return kenyanPhoneRegex.hasMatch(phone);
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

  bool get _canProceed {
    return _isValidPhoneNumber && _isValidAmount;
  }

  String _formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (phone.startsWith('0')) {
      phone = '+254${phone.substring(1)}';
    } else if (phone.startsWith('254')) {
      phone = '+$phone';
    } else if (!phone.startsWith('+254')) {
      phone = '+254$phone';
    }
    return phone;
  }

  void _validatePhone() {
    setState(() {
      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (!_isValidPhoneNumber) {
        _phoneError = 'Enter a valid Kenyan phone number';
      } else {
        _phoneError = '';
      }
    });
  }

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
              style:
                  GoogleFonts.montserrat(fontSize: 12, color: Colors.grey[600]),
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
            Text(
              'Buy Me a Coffee',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              'Support helps keep this app running ☕',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w400,
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

            // Coffee options section
            Text(
              'Choose your support',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 16),

            // Coffee amount options in a row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ..._coffeeOptions.map((option) => _buildCoffeeOptionSquare(
                      amount: option['amount'],
                      title: option['title'],
                      icon: option['icon'],
                    )),
              ],
            ),

            const SizedBox(height: 16),

            // Custom amount option
            _buildCustomAmountOption(),

            const SizedBox(height: 32),

            // Phone number input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'M-Pesa Phone Number',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s()]')),
                    LengthLimitingTextInputFormatter(15),
                  ],
                  onChanged: (_) => _validatePhone(),
                  decoration: InputDecoration(
                    hintText: '0712345678 or +254712345678',
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/M-PESA.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.green, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    errorText: _phoneError.isEmpty ? null : _phoneError,
                  ),
                  style: GoogleFonts.montserrat(),
                ),

                const SizedBox(height: 8),

                // M-Pesa info
                Row(
                  children: [
                    Icon(Icons.security, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text(
                      'Secure M-Pesa payment',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Buy button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _canProceed ? _processPurchase : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _canProceed ? Colors.green : Colors.grey[300],
                  foregroundColor: Colors.white,
                  elevation: _canProceed ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/M-PESA.png',
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _canProceed
                          ? 'Pay KSH ${_finalAmount.toStringAsFixed(0)}'
                          : 'Select amount and enter phone',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _canProceed ? Colors.white : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Footer info
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

  Widget _buildCoffeeOptionSquare({
    required int amount,
    required String title,
    required String icon,
  }) {
    final isSelected = _selectedAmount == amount && !_isCustomAmount;

    return GestureDetector(
      onTap: () => _selectAmount(amount),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.green[700] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'KSH ${amount.toStringAsFixed(0)}',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.green[700] : AppColors.brandPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAmountOption() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCustomAmount ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isCustomAmount ? Colors.green : Colors.grey[300]!,
          width: _isCustomAmount ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _selectCustomAmount,
            child: Row(
              children: [
                const Text('💰', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  'Custom Amount',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color:
                        _isCustomAmount ? Colors.green[700] : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          if (_isCustomAmount) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _customAmountController,
              focusNode: _customAmountFocusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              onChanged: (_) => _validateCustomAmount(),
              decoration: InputDecoration(
                hintText: 'Enter amount (50-50,000)',
                prefixText: 'KSH ',
                prefixStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            if (_amountError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _amountError,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
