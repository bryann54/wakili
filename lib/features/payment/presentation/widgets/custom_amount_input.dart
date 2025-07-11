import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAmountInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isSelected;
  final String? errorText;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;

  const CustomAmountInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isSelected,
    required this.onTap,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<CustomAmountInput> createState() => _CustomAmountInputState();
}

class _CustomAmountInputState extends State<CustomAmountInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(CustomAmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: widget.isSelected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        const Color(0xFF2D5A27).withValues(alpha: 0.8),
                        const Color(0xFF4CAF50).withValues(alpha: 0.6),
                      ]
                    : [
                        const Color(0xFF81C784).withValues(alpha: 0.3),
                        const Color(0xFF4CAF50).withValues(alpha: 0.2),
                      ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        Colors.grey[900]!.withValues(alpha: 0.8),
                        Colors.grey[800]!.withValues(alpha: 0.6),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.9),
                        Colors.grey[50]!.withValues(alpha: 0.8),
                      ],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isSelected
              ? const Color(0xFF4CAF50)
              : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
          width: widget.isSelected ? 2.5 : 1.5,
        ),
        boxShadow: [
          if (widget.isSelected) ...[
            BoxShadow(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ] else ...[
            BoxShadow(
              color: (isDarkMode ? Colors.black : Colors.grey[400]!)
                  .withValues(alpha: isDarkMode ? 0.4 : 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Glassmorphism background
            if (widget.isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 1.5,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.isSelected
                                ? Colors.green.withValues(alpha: 0.2)
                                : (isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              const Text('💰', style: TextStyle(fontSize: 24)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Custom Amount',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: widget.isSelected
                                      ? (isDarkMode
                                          ? Colors.green[300]
                                          : Colors.green[700])
                                      : (isDarkMode
                                          ? Colors.grey[200]
                                          : Colors.grey[800]),
                                ),
                              ),
                              Text(
                                'Set your own amount',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          widget.isSelected
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: widget.isSelected
                              ? (isDarkMode
                                  ? Colors.green[300]
                                  : Colors.green[700])
                              : (isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _expandAnimation,
                    builder: (context, child) {
                      return ClipRect(
                        child: Align(
                          heightFactor: _expandAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.grey[700]!
                                  : Colors.grey[200]!,
                            ),
                          ),
                          child: TextFormField(
                            controller: widget.controller,
                            focusNode: widget.focusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            onChanged: widget.onChanged,
                            decoration: InputDecoration(
                              hintText: 'Enter amount',
                              hintStyle: GoogleFonts.inter(
                                color: isDarkMode
                                    ? Colors.grey[500]
                                    : Colors.grey[600],
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'KSH',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
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
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 16),
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

                        const SizedBox(height: 12),

                        // Amount range indicator
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (isDarkMode
                                    ? Colors.blue[900]
                                    : Colors.blue[50])
                                ?.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue[700],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Amount range: KSH 50 - 50,000',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDarkMode
                                      ? Colors.blue[300]
                                      : Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
