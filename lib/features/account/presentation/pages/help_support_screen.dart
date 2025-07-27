import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/account/presentation/widgets/section_header_widget.dart';
import 'package:wakili/features/account/presentation/widgets/support_card_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
            _buildEmailContactSection(context, colorScheme),
            const SizedBox(height: 32),
            _buildFAQSection(context, colorScheme),
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
        'Help & Support',
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
                  FontAwesomeIcons.headset,
                  color: AppColors.brandPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'How can we help you?',
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
            'We\'re here to assist you with any questions or issues you may have. Contact us via email for support.', // Updated text
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

  Widget _buildEmailContactSection(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Contact Us'),
        const SizedBox(height: 16),
        SupportCardWidget(
          icon: FontAwesomeIcons.envelope,
          title: 'Email: support@wakili.com',
          onTap: () => _sendEmail(context),
          colorScheme: colorScheme,
        ),
        SupportCardWidget(
          icon: FontAwesomeIcons.clock,
          title: 'Hours: Mon-Fri 9AM-6PM EAT',
          onTap: () {},
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildFAQSection(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeaderWidget(title: 'Frequently Asked Questions'),
        const SizedBox(height: 16),
        ..._buildFAQItems(context, colorScheme),
      ],
    );
  }

  List<Widget> _buildFAQItems(BuildContext context, ColorScheme colorScheme) {
    final faqs = [
      {
        'question': 'What kind of legal advice can Wakili AI provide?',
        'answer':
            'Wakili AI provides general legal information and guidance based on Kenyan law. It can help you understand legal concepts, your rights, and common procedures. It is not a substitute for formal legal consultation.',
      },
      {
        'question': 'Is my conversation with Wakili AI private?',
        'answer':
            'Your conversations are processed with privacy in mind. We use industry-standard security measures to protect your data. For sensitive personal information, always consult a human lawyer.',
      },
      {
        'question': 'How accurate is the advice from Wakili AI?',
        'answer':
            'Wakili AI strives for accuracy based on its knowledge base of Kenyan law. However, laws change, and specific situations vary. Always verify critical information and seek professional legal advice for your unique case.',
      },
      {
        'question': 'How can I provide feedback on Wakili AI\'s responses?',
        'answer':
            'You can provide feedback through the "Tips & Tricks" screen or by emailing us directly. Your input helps us improve the AI\'s performance.',
      },
    ];

    return faqs
        .map((faq) => _buildFAQItem(
            context, faq['question']!, faq['answer']!, colorScheme))
        .toList();
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer,
      ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          question,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: colorScheme.onSurface,
          ),
        ),
        iconColor: AppColors.brandPrimary,
        collapsedIconColor: colorScheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@wakili.com',
      query: 'subject=Support Request for Wakili AI',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Unable to open email client. Please email support@wakili.com directly.'), // More helpful message
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
