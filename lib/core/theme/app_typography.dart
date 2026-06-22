import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// PortScan typography system (spec §2).
/// Headings: Plus Jakarta Sans · Body/UI: Inter · VIN/codes: JetBrains Mono
class AppTypography {
  AppTypography._();

  // ─── Headings (Plus Jakarta Sans) ───
  static TextStyle get heading32 => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.25,
      );

  static TextStyle get heading28 => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.25,
      );

  static TextStyle get heading24 => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get heading20 => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle get heading18 => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  // ─── KPI stat number ───
  static TextStyle get statNumber => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.25,
      );

  static TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  // ─── Body / UI (Inter) ───
  static TextStyle get body16 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get body15 => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get body14 => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get body13 => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get body12 => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  // ─── Button / Label (Inter, medium/semibold) ───
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // ─── VIN / Codes / IDs (JetBrains Mono) ───
  static TextStyle get mono15 => GoogleFonts.jetBrainsMono(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 1.0,
      );

  static TextStyle get mono14 => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 1.0,
      );

  static TextStyle get mono13 => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 1.0,
      );

  // ─── Nav ───
  static TextStyle get navLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  // ─── Section header (uppercase) ───
  static TextStyle get sectionHeader => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.5,
      );
}
