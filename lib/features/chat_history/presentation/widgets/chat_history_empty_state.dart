// features/chat_history/presentation/widgets/chat_history_empty_state.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as Math;

class ChatHistoryEmptyState extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isSearchEmpty;
  final bool hasConversationsBeforeFilter;
  final VoidCallback? onRefetch;

  const ChatHistoryEmptyState({
    super.key,
    required this.colorScheme,
    required this.isSearchEmpty,
    required this.hasConversationsBeforeFilter,
    this.onRefetch,
  });

  @override
  Widget build(BuildContext context) {
    final EmptyStateConfig config = _getEmptyStateConfig();
    final screenSize = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: () async {
        if (onRefetch != null) {
          onRefetch!();
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: screenSize.height * 0.6,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background floating animation
                  _buildFloatingBackground(screenSize),

                  // Main content
                  _buildMainContent(context, config),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBackground(Size screenSize) {
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height * 0.8,
      child: Stack(
        children: List.generate(8, (index) {
          final isSmall = index % 2 == 0;
          final angle = (index * 45.0) * (3.14159 / 180); // Convert to radians
          final radius = screenSize.width * 0.25 + (index % 3) * 40.0;

          final xOffset = radius * Math.cos(angle);
          final yOffset = radius * Math.sin(angle);

          return Positioned(
            left: screenSize.width / 2 + xOffset,
            top: screenSize.height * 0.4 + yOffset,
            child: FaIcon(
              _getBackgroundIcon(index),
              color: colorScheme.primary.withOpacity(0.08 + (index % 3) * 0.02),
              size: isSmall ? 16.0 : 24.0,
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .rotate(
                  begin: 0,
                  end: 1,
                  duration: Duration(seconds: 15 + index % 10),
                  curve: Curves.linear,
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: Duration(seconds: 4 + index % 3),
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.2, 1.2),
                  end: const Offset(0.8, 0.8),
                  duration: Duration(seconds: 4 + index % 3),
                  curve: Curves.easeInOut,
                ),
          );
        }),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, EmptyStateConfig config) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container with improved design
          _buildIconContainer(config),
          const SizedBox(height: 32),

          // Title with better typography
          _buildTitle(config),
          const SizedBox(height: 16),

          // Description with better spacing
          _buildDescription(config),

          // Pull to refresh hint
          if (onRefetch != null) _buildPullToRefreshHint(),
        ],
      ),
    );
  }

  Widget _buildIconContainer(EmptyStateConfig config) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withOpacity(0.4),
            colorScheme.primaryContainer.withOpacity(0.2),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.1),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: FaIcon(
        config.mainIcon,
        size: 56,
        color: colorScheme.primary,
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 600.ms);
  }

  Widget _buildTitle(EmptyStateConfig config) {
    return Text(
      config.titleText,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 300.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 300.ms);
  }

  Widget _buildDescription(EmptyStateConfig config) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        config.descriptionText,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
          fontSize: 16,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 500.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 500.ms);
  }

  Widget _buildPullToRefreshHint() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Pull down to refresh',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 900.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 900.ms);
  }

  EmptyStateConfig _getEmptyStateConfig() {
    if (isSearchEmpty) {
      return EmptyStateConfig(
        titleText: 'No conversations found',
        descriptionText:
            'Try adjusting your search terms or clear filters to see more results.',
        mainIcon: FontAwesomeIcons.magnifyingGlass,
      );
    } else if (!hasConversationsBeforeFilter) {
      return EmptyStateConfig(
        titleText: 'Welcome to Wakili',
        descriptionText:
            'Start your first conversation and it will appear here for easy access later.',
        mainIcon: FontAwesomeIcons.solidComments,
      );
    } else {
      return EmptyStateConfig(
        titleText: 'No matching conversations',
        descriptionText:
            'No conversations match your current filter. Try adjusting your criteria.',
        mainIcon: FontAwesomeIcons.filter,
      );
    }
  }

  IconData _getBackgroundIcon(int index) {
    const icons = [
      FontAwesomeIcons.comment,
      FontAwesomeIcons.solidComment,
      FontAwesomeIcons.message,
      FontAwesomeIcons.solidMessage,
    ];
    return icons[index % icons.length];
  }
}

// Configuration class for better maintainability
class EmptyStateConfig {
  final String titleText;
  final String descriptionText;
  final IconData mainIcon;

  const EmptyStateConfig({
    required this.titleText,
    required this.descriptionText,
    required this.mainIcon,
  });
}
