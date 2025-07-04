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
          selectedFilter = state.currentFilter;
        }

        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip(
                context: context,
                label: 'All',
                isSelected: selectedFilter == null,
                onTap: () => context.read<OverviewBloc>().add(const LoadLegalDocuments()),
              ),
              const SizedBox(width: 8),
              ...DocumentType.values.map((type) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  context: context,
                  label: _getTypeDisplayName(type),
                  isSelected: selectedFilter == type,
                  onTap: () => context.read<OverviewBloc>().add(LoadLegalDocuments(filterType: type)),
                ),
              )).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: isSelected 
                ? Theme.of(context).colorScheme.onPrimary 
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
    }
  
    String _getTypeDisplayName(DocumentType type) {
      // You can customize the display names as needed
      switch (type) {
        case DocumentType.act:
          return 'Contract';
        case DocumentType.amendment:
          return 'Agreement';
        case DocumentType.law:
          return 'Policy';
        case DocumentType.bill:
          return 'Bill';
        case DocumentType.regulation:
          return 'Regulation';
          
        }
    }
  }