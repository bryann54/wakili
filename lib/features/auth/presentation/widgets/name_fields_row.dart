// File: lib/features/auth/presentation/widgets/name_fields_row.dart

import 'package:flutter/material.dart';
import 'package:wakili/features/auth/presentation/widgets/auth_text_field.dart';

class NameFieldsRow extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final ValueChanged<String>? onChanged;

  const NameFieldsRow({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Expanded(
            child: AuthTextField(
              controller: firstNameController,
              label: 'First Name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'First Name is required' : null,
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AuthTextField(
              controller: lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Last Name is required' : null,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
