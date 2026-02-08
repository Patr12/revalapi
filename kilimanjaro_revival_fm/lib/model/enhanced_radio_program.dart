// ===== ENHANCED RADIO PROGRAM CLASS =====
import 'package:flutter/material.dart';

class EnhancedRadioProgram {
  final String title;
  final TimeOfDay start;
  final TimeOfDay end;
  final String description;
  final String host;
  final IconData icon;

  EnhancedRadioProgram({
    required this.title,
    required this.start,
    required this.end,
    this.description = '',
    this.host = '',
    required this.icon,
  });
}