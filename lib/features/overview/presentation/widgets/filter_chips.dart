import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/legal_document.dart';
import '../bloc/overview_bloc.dart';

class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        DocumentType? selectedFilter;
        if (state is OverviewLoaded) {
          selectedFilter = state.currentQuery.filterType;
        }

        return Container(
          height: 40, // Adjusted height for smaller chips
          margin: const EdgeInsets.only(bottom: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterChip(
                context: context,
                label: 'All',
                icon: Icons.apps_rounded,
                isSelected: selectedFilter == null,
                onTap: () => context
                    .read<OverviewBloc>()
                    .add(const FilterDocuments(null)),
              ),
              const SizedBox(width: 10), // Slightly reduced spacing
              ...DocumentType.values.map((type) => Padding(
                    padding: const EdgeInsets.only(
                        right: 10), // Slightly reduced spacing
                    child: _buildFilterChip(
                      context: context,
                      label: _getTypeDisplayName(type),
                      icon: _getTypeIcon(type),
                      isSelected: selectedFilter == type,
                      onTap: () => context
                          .read<OverviewBloc>()
                          .add(FilterDocuments(type)),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(10), // Slightly smaller border radius
          splashColor: isSelected
              ? colorScheme.onPrimary
                  .withOpacity(0.1) // Using .withOpacity for clarity
              : colorScheme.primary.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            // Reduced padding to make the chip smaller
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 6), // Adjusted vertical padding
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary
                            .withOpacity(0.8), // Using .withOpacity
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : colorScheme.surface,
              borderRadius: BorderRadius.circular(
                  10), // Matching the InkWell's border radius
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : colorScheme.outline
                        .withOpacity(0.2), // Using .withOpacity
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary
                            .withOpacity(0.3), // Using .withOpacity
                        blurRadius: 6, // Slightly reduced blur
                        offset: const Offset(0, 1), // Slightly smaller offset
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(
                            0.03), // Reduced opacity for subtle shadow
                        blurRadius: 3, // Slightly reduced blur
                        offset: const Offset(0, 1), // Slightly smaller offset
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    size: 16, // Reduced icon size from 18 to 16
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface
                            .withOpacity(0.7), // Using .withOpacity
                  ),
                ),
                const SizedBox(width: 6), // Reduced space between icon and text
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.poppins(
                    fontSize: 12, // Reduced font size from 14 to 12
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  child: Text(label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeDisplayName(DocumentType type) {
    switch (type) {
      case DocumentType.act:
        return 'Acts';
      case DocumentType.amendment:
        return 'Amendments';
      case DocumentType.law:
        return 'Laws';
      case DocumentType.bill:
        return 'Bills';
      case DocumentType.regulation:
        return 'Regulations';
    }
  }

  IconData _getTypeIcon(DocumentType type) {
    switch (type) {
      case DocumentType.act:
        return Icons.gavel_rounded;
      case DocumentType.amendment:
        return Icons.edit_document;
      case DocumentType.law:
        return Icons.balance_rounded;
      case DocumentType.bill:
        return Icons.description_rounded;
      case DocumentType.regulation:
        return Icons.rule_rounded;
    }
  }
}
