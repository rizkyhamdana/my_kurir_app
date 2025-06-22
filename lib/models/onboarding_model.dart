import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String subtitle;
  final String description;
  final String icon;
  final List<Color> gradientColors;

  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradientColors,
  });
}
