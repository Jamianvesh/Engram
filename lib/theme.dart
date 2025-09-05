import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    brightness: Brightness.light,
    textTheme: GoogleFonts.poppinsTextTheme(),
    useMaterial3: true,
  );
}
