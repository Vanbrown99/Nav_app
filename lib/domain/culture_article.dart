import 'package:flutter/material.dart';
import 'package:nyetam/domain/place.dart';

enum CultureTopic {
  food('Food', Icons.restaurant_menu),
  customs('Customs', Icons.diversity_3_outlined),
  history('History', Icons.account_balance_outlined),
  language('Language', Icons.translate_outlined),
  arts('Arts', Icons.palette_outlined);

  const CultureTopic(this.label, this.icon);

  final String label;
  final IconData icon;
}

class CultureArticle extends TourismEntity {
  const CultureArticle({
    required super.id,
    required super.name,
    required this.subtitle,
    required this.region,
    required this.topic,
    required this.introduction,
    required this.sections,
    required this.imageUrl,
    required this.readMinutes,
  });

  final String subtitle;
  final String region;
  final CultureTopic topic;
  final String introduction;
  final List<CultureSection> sections;
  final String imageUrl;
  final int readMinutes;
}

class CultureSection {
  const CultureSection({required this.title, required this.content});

  final String title;
  final String content;
}
