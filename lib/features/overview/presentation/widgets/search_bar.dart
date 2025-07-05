import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegalSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String? hintText;

  const LegalSearchBar({
    super.key,
    required this.onSearchChanged,
    this.hintText,
  });

  @override
  State<LegalSearchBar> createState() => _LegalSearchBarState();
}

class _LegalSearchBarState extends State<LegalSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onSearchChanged,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search bills, acts, and laws...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
