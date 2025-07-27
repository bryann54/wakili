// widgets/intro_content_data.dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wakili/features/auth/data/models/intro_screen_model.dart';

class IntroContentData {
  static final List<IntroScreenContent> introContent = [
    IntroScreenContent(
      icon: FontAwesomeIcons.comments,
      title: 'AI-Powered Legal Conversations',
      description:
          'Engage in natural conversations with Wakili AI to get clear explanations of legal concepts and personalized advice.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.clockRotateLeft,
      title: 'Your Conversation History',
      description:
          'All your chat histories are saved securely for future reference and continuous learning.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.magnifyingGlassChart,
      title: 'Real-Time Legal Updates',
      description:
          'Wakili AI continuously monitors and analyzes new bills, laws, and parliamentary proceedings to keep you informed.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.fileLines,
      title: 'Smart Document Analysis',
      description:
          'Upload legal documents for instant analysis, key point extraction, and actionable summaries.',
    ),
  ];
}
