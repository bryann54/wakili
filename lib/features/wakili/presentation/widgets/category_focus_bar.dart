import 'package:flutter/material.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';

class CategoryFocusBar extends StatelessWidget {
  final LegalCategory category;

  const CategoryFocusBar({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: category.color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(category.icon, size: 16, color: category.color),
          const SizedBox(width: 8),
          Text(
            'Focus: ${category.title}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}
