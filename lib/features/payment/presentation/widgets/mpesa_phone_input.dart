import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MpesaPhoneInput extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
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
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(9),
            // Custom formatter to ensure it starts with 7 or 1
            _KenyanPhoneFormatter(),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '712345678',
            prefixIcon: Container(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'assets/M-PESA.png',
                height: 24,
                width: 24,
              ),
            ),
            prefix: Container(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '+254',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            errorText: errorText,
            helperText: 'Enter 9 digits starting with 7 or 1',
            helperStyle: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
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

    // If empty, allow it
    if (newText.isEmpty) {
      return newValue;
    }

    // Only allow numbers starting with 7 or 1 (Kenyan mobile prefixes)
    if (newText.isNotEmpty &&
        !newText.startsWith('7') &&
        !newText.startsWith('1')) {
      return oldValue;
    }

    // Limit to 9 digits
    if (newText.length > 9) {
      return oldValue;
    }

    return newValue;
  }
}
