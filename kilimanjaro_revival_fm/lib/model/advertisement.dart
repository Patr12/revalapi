// lib/models/advertisement.dart
import 'dart:math';

class Advertisement {
  final int? id;
  final String title;
  final String description;
  final String imageDisplay;
  final String targetProgram;
  final DateTime startDate;
  final DateTime endDate;
  final int displayDuration;
  final String advertiser;
  final String? advertiserContact;
  final String? advertiserEmail;
  final String? callToAction;
  final String? externalLink;
  final String status;
  final int impressions;
  final int clicks;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Advertisement({
    this.id,
    required this.title,
    required this.description,
    required this.imageDisplay,
    required this.targetProgram,
    required this.startDate,
    required this.endDate,
    this.displayDuration = 30,
    required this.advertiser,
    this.advertiserContact,
    this.advertiserEmail,
    this.callToAction,
    this.externalLink,
    required this.status,
    this.impressions = 0,
    this.clicks = 0,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// ✅ ADD THIS METHOD
  bool matchesProgram(String programTitle) {
    if (targetProgram.toLowerCase() == 'general') return true;
    return targetProgram.toLowerCase() == programTitle.toLowerCase();
  }

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    // Helper function to convert relative paths to absolute URLs
    String getImageUrl(String? imagePath) {
      if (imagePath == null || imagePath.isEmpty) return '';

      // Trim whitespace
      String cleanPath = imagePath.trim();
      if (cleanPath.isEmpty) return '';

      // If it's already an http(s) URL, return as is
      if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
        print('  ✅ Valid HTTP URL: $cleanPath');
        return cleanPath;
      }

      // Base URL WITHOUT trailing slash
      const baseUrl = 'http://192.168.1.199:8000';

      // Remove file:// protocol if present
      if (cleanPath.startsWith('file://')) {
        print('  🔨 Removing file:// from: $cleanPath');
        cleanPath = cleanPath.replaceFirst('file://', '');
      }

      // Ensure path starts with /
      if (!cleanPath.startsWith('/')) {
        cleanPath = '/$cleanPath';
      }

      final finalUrl = '$baseUrl$cleanPath';
      print(
        '  🔄 Converted: ${imagePath.substring(0, min(40, imagePath.length))}... → $finalUrl',
      );
      return finalUrl;
    }

    // Get image from whichever field is populated
    final imageField =
        json['image'] ?? json['image_url'] ?? json['image_display'] ?? '';

    return Advertisement(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageDisplay: getImageUrl(imageField),
      targetProgram: json['target_program'] ?? 'General',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      displayDuration: json['display_duration'] ?? 30,
      advertiser: json['advertiser'] ?? '',
      advertiserContact: json['advertiser_contact'],
      advertiserEmail: json['advertiser_email'],
      callToAction: json['call_to_action'],
      externalLink: json['external_link'],
      status: json['status'] ?? 'active',
      impressions: json['impressions'] ?? 0,
      clicks: json['clicks'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image_url': imageDisplay,
      'target_program': targetProgram,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'display_duration': displayDuration,
      'advertiser': advertiser,
      'advertiser_contact': advertiserContact,
      'advertiser_email': advertiserEmail,
      'call_to_action': callToAction,
      'external_link': externalLink,
      'status': status,
    };
  }

  Advertisement copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? targetProgram,
    DateTime? startDate,
    DateTime? endDate,
    int? displayDuration,
    String? advertiser,
    String? advertiserContact,
    String? advertiserEmail,
    String? callToAction,
    String? externalLink,
    String? status,
    int? impressions,
    int? clicks,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Advertisement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageDisplay: imageUrl ?? imageDisplay,
      targetProgram: targetProgram ?? this.targetProgram,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      displayDuration: displayDuration ?? this.displayDuration,
      advertiser: advertiser ?? this.advertiser,
      advertiserContact: advertiserContact ?? this.advertiserContact,
      advertiserEmail: advertiserEmail ?? this.advertiserEmail,
      callToAction: callToAction ?? this.callToAction,
      externalLink: externalLink ?? this.externalLink,
      status: status ?? this.status,
      impressions: impressions ?? this.impressions,
      clicks: clicks ?? this.clicks,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Program choices based on Django model
class ProgramChoices {
  static const List<String> programs = [
    'SUN RISE',
    'KR MORNING',
    'HABARI KWA UFUPI',
    'JAMVI LETU',
    'HABARI KAMILI MCHANA',
    'GOSPEL REVIVAL HUB',
    'SUN SET DRIVE TIME',
    'SPORTS COUNTER',
    'HABARI ZA USIKU',
    'TUJIFUNZE BIBLIA',
    'USIKU WA USHINDI',
    'HABARI ZA USIKU (MARUDIO)',
    'General',
  ];
}

// Status choices
class StatusChoices {
  static const List<String> statuses = ['active', 'inactive', 'scheduled'];
}
