import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/account/presentation/widgets/section_header_widget.dart';
import 'package:wakili/features/account/presentation/widgets/support_card_widget.dart';

class SupportSectionWidget extends StatelessWidget {
  const SupportSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderWidget(title: 'Support'),
          const SizedBox(height: 5),
          Column(
            children: [
              const SizedBox(height: 5),
              SupportCardWidget(
                icon: Icons.support_agent_outlined,
                title: 'Help & Support',
                onTap: () {
                  context.router.push(const HelpSupportRoute());
                },
              ),
              SupportCardWidget(
                icon: Icons.auto_awesome,
                title: 'Tips & Tricks',
                onTap: () {
                  context.router.push(const TipsTricksRoute());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
