// widgets/intro_content_data.dart
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wakili/features/auth/data/models/intro_screen_model.dart';

class IntroContentData {
  static final List<IntroScreenContent> introContent = [
    IntroScreenContent(
      icon: FontAwesomeIcons.brain,
      title: 'AI Legal Intelligence',
      description:
          'Experience the future of legal assistance with Wakili\'s advanced AI that understands complex legal matters and provides instant, accurate guidance.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.userShield,
      title: 'Your Legal Guardian',
      description:
          'Stay protected with real-time legal insights, risk assessments, and proactive alerts that keep you ahead of potential legal challenges.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.searchengin,
      title: 'Smart Legal Discovery',
      description:
          'Unlock hidden insights from vast legal databases. Find relevant cases, precedents, and regulations instantly with intelligent search capabilities.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.handshake,
      title: 'Trusted Legal Partner',
      description:
          'Build confidence in your legal decisions with a reliable AI companion that learns your preferences and provides personalized legal strategies.',
    ),
  ];

  // Alternative content sets for different use cases
  static final List<IntroScreenContent> alternativeContent = [
    IntroScreenContent(
      icon: FontAwesomeIcons.rocket,
      title: 'Launch Your Legal Journey',
      description:
          'Transform how you handle legal matters with cutting-edge AI technology that makes complex law accessible to everyone.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.compass,
      title: 'Navigate Legal Complexity',
      description:
          'Find your way through intricate legal landscapes with intelligent guidance that simplifies the most challenging legal concepts.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.lightbulb,
      title: 'Illuminate Legal Solutions',
      description:
          'Discover breakthrough insights and innovative approaches to your legal challenges with AI-powered analysis and recommendations.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.crown,
      title: 'Master Your Legal Destiny',
      description:
          'Take control of your legal affairs with premium AI assistance that empowers you to make informed, confident legal decisions.',
    ),
  ];

  // Professional/Corporate focused content
  static final List<IntroScreenContent> professionalContent = [
    IntroScreenContent(
      icon: FontAwesomeIcons.chartLine,
      title: 'Strategic Legal Analytics',
      description:
          'Leverage data-driven legal insights to make strategic decisions that protect and advance your business interests.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.userTie,
      title: 'Executive Legal Advisor',
      description:
          'Access C-suite level legal intelligence that helps you navigate corporate governance, compliance, and strategic legal planning.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.building,
      title: 'Enterprise Legal Solutions',
      description:
          'Scale your legal operations with AI-powered tools designed for modern businesses facing complex regulatory environments.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.handshakeAngle,
      title: 'Trusted Legal Partnership',
      description:
          'Establish a reliable legal foundation for your organization with AI assistance that grows with your business needs.',
    ),
  ];

  // Consumer/Personal focused content
  static final List<IntroScreenContent> personalContent = [
    IntroScreenContent(
      icon: FontAwesomeIcons.house,
      title: 'Protect Your Home & Family',
      description:
          'Safeguard what matters most with personalized legal guidance for family matters, property rights, and personal protection.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.piggyBank,
      title: 'Secure Your Financial Future',
      description:
          'Make smart financial and legal decisions with AI insights that help you avoid costly mistakes and maximize opportunities.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.graduationCap,
      title: 'Learn Legal Fundamentals',
      description:
          'Build your legal knowledge with interactive learning experiences that make law engaging and understandable for everyone.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.handHoldingHeart,
      title: 'Compassionate Legal Care',
      description:
          'Receive empathetic, understanding legal support that respects your unique situation and provides gentle guidance through difficult times.',
    ),
  ];

  // Method to get content based on user type or preference
  static List<IntroScreenContent> getContentForType(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'professional':
      case 'business':
      case 'corporate':
        return professionalContent;
      case 'personal':
      case 'individual':
      case 'family':
        return personalContent;
      case 'alternative':
      case 'creative':
        return alternativeContent;
      default:
        return introContent;
    }
  }

  // Method to get random content for variety
  static List<IntroScreenContent> getRandomContent() {
    final allContentSets = [
      introContent,
      alternativeContent,
      professionalContent,
      personalContent
    ];
    allContentSets.shuffle();
    return allContentSets.first;
  }
}
