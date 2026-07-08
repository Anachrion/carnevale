import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

/// The small numbered chip shown beside an Agenda's title, so players can
/// reference "agenda 2" at the table. Shared by the initial-draw cards and the
/// Score-tab hand tiles. The number is the agenda's position in the hand.
class AgendaNumberBadge extends StatelessWidget {
  const AgendaNumberBadge({super.key, required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.secondaryAccentColor,
      ),
      child: Text(
        '$number',
        style: GoogleFonts.cinzel(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
