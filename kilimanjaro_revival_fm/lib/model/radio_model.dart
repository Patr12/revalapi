import 'package:flutter/material.dart';

class RadioProgram {
  final String title;
  final TimeOfDay start;
  final TimeOfDay end;

  RadioProgram(this.title, this.start, this.end);
}

class AdModel {
  final String title;
  final String imageUrl;
  final String program;

  AdModel(this.title, this.imageUrl, this.program);
}
