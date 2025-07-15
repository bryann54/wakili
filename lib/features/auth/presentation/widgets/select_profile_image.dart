// lib/features/auth/presentation/widgets/select_profile_image.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class SelectProfileImage extends StatefulWidget {
  final VoidCallback? onTap;
  final String? imagePath;

  const SelectProfileImage({
    super.key,
    this.onTap,
    this.imagePath,
  });

  @override
  State<SelectProfileImage> createState() => _SelectProfileImageState();
}

class _SelectProfileImageState extends State<SelectProfileImage> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surfaceContainerHigh,
                  border: Border.all(
                    color: _isHovering
                        ? colors.primary.withValues(alpha: 0.6)
                        : colors.outline.withValues(alpha: 0.2),
                    width: _isHovering ? 2.5 : 1.0,
                  ),
                  boxShadow: _isHovering
                      ? [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: colors.shadow.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: _buildImageWidget(colors),
                    ),
                    if (_isHovering)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.scrim.withValues(alpha: 0.4),
                        ),
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          color: colors.onPrimary,
                          size: 38,
                        ),
                      ).animate().fadeIn(duration: 180.ms),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AnimatedOpacity(
                opacity: _isHovering ? 1.0 : 0.8,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Text(
                  widget.imagePath != null
                      ? 'Change Profile Photo'
                      : 'Upload Profile Photo',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              if (_isHovering)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tap to Upload',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: colors.primary,
                        size: 14,
                      )
                          .animate(
                            onPlay: (controller) => controller.repeat(),
                          )
                          .moveX(
                            begin: 0,
                            end: 3,
                            duration: 600.ms,
                            curve: Curves.easeInOut,
                          ),
                    ],
                  ).animate().fadeIn(duration: 200.ms),
                ),
            ],
          ).animate().fadeIn(duration: 300.ms),
        ),
      ),
    );
  }

  // Helper method to decide whether to display a network image or a local file image
  Widget _buildImageWidget(ColorScheme colors) {
    if (widget.imagePath != null) {
      if (widget.imagePath!.startsWith('http')) {
        // It's a network URL (e.g., from Firebase Storage)
        return Image.network(
          widget.imagePath!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultAvatar(colors),
        );
      } else {
        // It's a local file path (e.g., from image_picker)
        return Image.file(
          File(widget.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildDefaultAvatar(colors),
        );
      }
    }
    return _buildDefaultAvatar(colors);
  }

  Widget _buildDefaultAvatar(ColorScheme colors) {
    return FaIcon(
      FontAwesomeIcons.solidUser,
      size: 60,
      color: colors.onSurfaceVariant
          .withValues(alpha: 0.2), // Corrected from withValues
    );
  }
}
