import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:wakili/common/res/l10n.dart';

class CustomFlashyBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomFlashyBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        isDarkMode ? Colors.white : Theme.of(context).primaryColor;
    final inactiveColor = Colors.grey[600]!;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: FlashyTabBar(
          selectedIndex: currentIndex,
          backgroundColor: Theme.of(context).colorScheme.surface,
          iconSize: 20,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          showElevation: false,
          onItemSelected: onTap,
          items: [
            FlashyTabBarItem(
              icon: FaIcon(
                currentIndex == 0
                    ? FontAwesomeIcons.solidComments
                    : FontAwesomeIcons.comments,
                color: currentIndex == 0 ? activeColor : inactiveColor,
              ),
              title: Text(
                AppLocalizations.getString(context, 'wakiliChat'),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            FlashyTabBarItem(
              icon: FaIcon(
                FontAwesomeIcons.landmark,
                color: currentIndex == 1 ? activeColor : inactiveColor,
              ),
              title: Text(
                AppLocalizations.getString(context, 'Bills'),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            FlashyTabBarItem(
              icon: FaIcon(
                FontAwesomeIcons.clockRotateLeft,
                color: currentIndex == 2 ? activeColor : inactiveColor,
              ),
              title: Text(
                AppLocalizations.getString(context, 'History'),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            FlashyTabBarItem(
              icon: FaIcon(
                currentIndex == 3
                    ? FontAwesomeIcons.solidUser
                    : FontAwesomeIcons.user,
                color: currentIndex == 3 ? activeColor : inactiveColor,
              ),
              title: Text(
                AppLocalizations.getString(context, 'account'),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
      ),
    );
  }
}
