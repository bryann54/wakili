import 'package:flutter/material.dart';

class LegalCategory {
  final String id;
  final String title;
  final Color color;
  final String description;
  final String imagePath;
  final List<LegalCategory>? subcategories;

  const LegalCategory({
    required this.id,
    required this.title,
    required this.color,
    required this.description,
    required this.imagePath,
    this.subcategories,
  });

  // Factory constructor to create a LegalCategory from a Firestore document
  factory LegalCategory.fromFirestore(Map<String, dynamic> data, String id) {
    // Parse color from hex string (e.g., "#RRGGBB" or "#AARRGGBB")
    Color color = Colors.grey; // Default color
    if (data['colorHex'] != null) {
      try {
        String colorHex = data['colorHex'].toString().replaceAll("#", "");
        if (colorHex.length == 6) {
          colorHex = "FF$colorHex"; // Add alpha if not present
        }
        color = Color(int.parse(colorHex, radix: 16));
      } catch (e) {
        debugPrint('Error parsing colorHex: ${data['colorHex']} - $e');
      }
    }

    // Parse subcategories if they exist
    List<LegalCategory>? parsedSubcategories;
    if (data['subcategories'] is List) {
      parsedSubcategories = (data['subcategories'] as List)
          .map((subData) =>
              LegalCategory.fromFirestore(subData, subData['id'] ?? ''))
          .toList();
    }

    return LegalCategory(
      id: id,
      title: data['title'] ?? 'Unknown',
      color: color,
      description: data['description'] ?? '',
      imagePath: data['imagePath'] ?? 'assets/wp.png', // Default image path
      subcategories: parsedSubcategories,
    );
  }

  // Method to convert a Color to a hex string for storage
  String toColorHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}
