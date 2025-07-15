import 'package:flutter/material.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';

Color getTypeColor(DocumentType type) {
  switch (type) {
    case DocumentType.bill:
      return Colors.blue.shade700;

    case DocumentType.act:
      return Colors.green.shade700;

    case DocumentType.law:
      return Colors.purple.shade700;

    case DocumentType.amendment:
      return Colors.orange.shade700;

    case DocumentType.regulation:
      return Colors.teal.shade700;
  }
}

String getTypeDisplayName(DocumentType type) {
  switch (type) {
    case DocumentType.bill:
      return 'Bill';

    case DocumentType.act:
      return 'Act';

    case DocumentType.law:
      return 'Law';

    case DocumentType.amendment:
      return 'Amendment';

    case DocumentType.regulation:
      return 'Regulation';
  }
}
