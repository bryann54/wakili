import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/account/presentation/widgets/section_header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class TipsTricksScreen extends StatelessWidget {
  const TipsTricksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: _buildAppBar(context, colorScheme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(colorScheme),
            const SizedBox(height: 32),
            _buildTipsSection(context, colorScheme),
            const SizedBox(height: 32),
            _buildPromptingSection(context, colorScheme),
            const SizedBox(height: 32),
            _buildUnderstandingAISection(context, colorScheme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      title: Text(
        'Wakili AI Tips',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      backgroundColor: colorScheme.surface,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(
                  FontAwesomeIcons.robot,
                  color: AppColors.brandPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Mastering Wakili AI',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Unlock the full potential of your Wakili AI legal advisor with these expert tips and tricks.', // Updated description
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Getting Started with Wakili'),
        const SizedBox(height: 16),
        ..._buildTipItems(context, _getWakiliUsageTips(), colorScheme),
      ],
    );
  }

  Widget _buildPromptingSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Crafting Effective Prompts'),
        const SizedBox(height: 16),
        ..._buildTipItems(context, _getPromptingTips(), colorScheme),
      ],
    );
  }

  Widget _buildUnderstandingAISection(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Understanding AI Advice'),
        const SizedBox(height: 16),
        ..._buildTipItems(context, _getAIBestPracticesTips(), colorScheme),
      ],
    );
  }

  List<Widget> _buildTipItems(BuildContext context,
      List<Map<String, dynamic>> tips, ColorScheme colorScheme) {
    return tips
        .map((tip) => _buildTipCard(
              context,
              icon: tip['icon'],
              title: tip['title'],
              description: tip['description'],
              isNew: tip['isNew'] ?? false,
              colorScheme: colorScheme,
            ))
        .toList();
  }

  Widget _buildTipCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    bool isNew = false,
    required ColorScheme colorScheme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              icon,
              color: AppColors.brandPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isNew) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.brandSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'NEW',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Wakili AI Specific Tips ---

  List<Map<String, dynamic>> _getWakiliUsageTips() {
    return [
      {
        'icon': FontAwesomeIcons.lightbulb,
        'title': 'Start with Clear Questions',
        'description':
            'Begin your query with a concise question about the legal topic you need help with. E.g., "What are my rights as a tenant?"',
        'isNew': false,
      },
      {
        'icon': FontAwesomeIcons.language,
        'title': 'Use Your Preferred Language',
        'description':
            'Wakili understands English, Swahili, and Sheng. Feel free to chat in the language you\'re most comfortable with.',
        'isNew': false,
      },
      {
        'icon': FontAwesomeIcons.bookOpenReader,
        'title': 'Refer to Past Conversations',
        'description':
            'Wakili remembers previous chats. If you have follow-up questions, continue the conversation for better context.',
        'isNew': false,
      },
    ];
  }

  List<Map<String, dynamic>> _getPromptingTips() {
    return [
      {
        'icon': FontAwesomeIcons.magnifyingGlassPlus,
        'title': 'Add Specific Details',
        'description':
            'Include crucial details like dates, locations (e.g., "Nairobi"), and specific parties involved for more accurate advice.',
        'isNew': true,
      },
      {
        'icon': FontAwesomeIcons.listOl,
        'title': 'Break Down Complex Issues',
        'description':
            'For complex cases, break your problem into smaller, individual questions to get clearer, more focused responses.',
        'isNew': false,
      },
      {
        'icon': FontAwesomeIcons.questionCircle,
        'title': 'Ask "What If" Scenarios',
        'description':
            'Explore different outcomes by asking hypothetical questions related to your legal situation.',
        'isNew': false,
      },
    ];
  }

  List<Map<String, dynamic>> _getAIBestPracticesTips() {
    return [
      {
        'icon': FontAwesomeIcons.handshakeAngle,
        'title': 'AI Guidance, Not Legal Advice',
        'description':
            'Wakili provides informed legal guidance. Always consult a human lawyer for formal, personalized legal advice.',
        'isNew': false,
      },
      {
        'icon': FontAwesomeIcons.checkToSlot,
        'title': 'Verify Critical Information',
        'description':
            'While accurate, always cross-reference critical legal details or statutes mentioned with official sources.',
        'isNew': false,
      },
      {
        'icon': FontAwesomeIcons.shieldHalved,
        'title': 'Protect Your Privacy',
        'description':
            'Avoid sharing highly sensitive personal or confidential information with the AI directly. Generalize where possible.',
        'isNew': false,
      },
      {
        'icon': FontAwesomeIcons.solidLightbulb,
        'title': 'Provide Feedback',
        'description':
            'Help improve Wakili by providing feedback on its responses. Your input is valuable for refinement.',
        'isNew': true,
      },
    ];
  }
}
