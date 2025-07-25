import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final bool hasSearchQuery;
  final VoidCallback onClearSearch;

  const EmptyState({
    super.key,
    required this.hasSearchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearchQuery
                ? 'No documents match your search'
                : 'No documents found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (hasSearchQuery) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onClearSearch,
              child: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }
}
