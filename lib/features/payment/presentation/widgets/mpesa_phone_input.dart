import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MpesaPhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const MpesaPhoneInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<MpesaPhoneInput> createState() => _MpesaPhoneInputState();
}

class _MpesaPhoneInputState extends State<MpesaPhoneInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _focusAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
        if (_isFocused) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.green[900] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/M-PESA.png',
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'M-Pesa Phone Number',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.grey[200] : Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Enter your mobile number',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isFocused
                      ? [
                          const Color(0xFF4CAF50).withValues(alpha: 0.1),
                          const Color(0xFF81C784).withValues(alpha: 0.05),
                        ]
                      : [
                          isDarkMode ? Colors.grey[900]! : Colors.white,
                          isDarkMode ? Colors.grey[850]! : Colors.grey[50]!,
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isFocused
                      ? const Color(0xFF4CAF50)
                      : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
                  width: _isFocused ? 2.5 : 1.5,
                ),
                boxShadow: [
                  if (_isFocused) ...[
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: (isDarkMode ? Colors.black : Colors.grey[400]!)
                          .withValues(alpha: isDarkMode ? 0.4 : 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                  _KenyanPhoneFormatter(),
                ],
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  hintText: '712 345 678',
                  hintStyle: GoogleFonts.inter(
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                    fontSize: 16,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🇰🇪',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+254',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          },
        ),
        if (widget.errorText?.isNotEmpty ?? false) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _KenyanPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    if (newText.isNotEmpty &&
        !newText.startsWith('7') &&
        !newText.startsWith('1')) {
      return oldValue;
    }

    if (newText.length > 9) {
      return oldValue;
    }

    return newValue;
  }
}
