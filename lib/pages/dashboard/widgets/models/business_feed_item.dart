import 'package:flutter/material.dart';
import 'business_feed_type.dart';

class BusinessFeedItem {
  final FeedType type;

  final String title;
  final String? headline;
  final String? subtitle;
  final String? description;

  final IconData icon;
  final Color color;
  final num? originalPrice;
  final num? promoPrice;
  final List<BusinessFeedScene>? scenes;

  final String? actionLabel;
  final FeedActionType actionType;

  const BusinessFeedItem({
    required this.type,
    required this.title,
    this.headline,
    this.subtitle,
    this.description,
    required this.icon,
    required this.color,
    required this.scenes,
    this.actionLabel,
    this.originalPrice,
    this.promoPrice,
    this.actionType = FeedActionType.none,
  });
}

class BusinessFeedScene {
  final SceneType type;
  final String headline;
  final String? subtitle;
  final String? description;
  final List<BusinessFeedReveal>? reveals;

  const BusinessFeedScene({
    this.type = SceneType.normal,
    required this.headline,
    this.subtitle,
    this.description,
    this.reveals,
  });
}

class BusinessFeedReveal {
  final String headline;
  final String? subtitle;
  final String? description;
  final String? notes;

  const BusinessFeedReveal({
    required this.headline,
    this.subtitle,
    this.description,
    this.notes,
  });
}
