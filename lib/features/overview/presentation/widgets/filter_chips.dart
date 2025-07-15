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
          height: 52,
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
              const SizedBox(width: 12),
              ...DocumentType.values.map((type) => Padding(
                    padding: const EdgeInsets.only(right: 12),
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
          borderRadius: BorderRadius.circular(25),
          splashColor: isSelected
              ? colorScheme.onPrimary.withValues(alpha: 0.1)
              : colorScheme.primary.withValues(alpha: 0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : colorScheme.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
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
                    size: 18,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
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
