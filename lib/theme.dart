import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── IPL 2026 Palette ─────────────────────────────────────────────────────────
const kBg        = Color(0xFF05060F);
const kSurface   = Color(0xFF0D0F1E);
const kGold      = Color(0xFFD4AF37);
const kGoldLight = Color(0xFFFFD966);
const kBlue      = Color(0xFF1A6FFF);
const kRed       = Color(0xFFD4001A);
const kWhite     = Colors.white;

// ── Text helpers ─────────────────────────────────────────────────────────────
TextStyle headingStyle({double size = 48, Color color = kWhite}) =>
    GoogleFonts.playfairDisplay(
      fontSize: size,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -1.5,
      height: 0.95,
    );

TextStyle bodyStyle({
  double size = 14,
  Color color = kWhite,
  FontWeight weight = FontWeight.w300,
}) =>
    GoogleFonts.barlow(
      fontSize: size,
      color: color,
      fontWeight: weight,
      letterSpacing: 0.2,
    );

TextStyle labelStyle({double size = 12, Color color = kWhite}) =>
    GoogleFonts.barlow(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    );
