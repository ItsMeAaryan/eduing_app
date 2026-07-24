import 'package:cloud_firestore/cloud_firestore.dart';

class AppSettings {
  // General
  final String language;
  final String themeMode;
  final String region;
  final String timezone;
  final double fontSize;
  final bool accessibilityMode;

  // AI Preferences
  final bool conversationMemory;
  final bool aiSuggestions;
  final bool aiNotifications;
  final String writingStyle;
  final String responseLength;

  // Notifications
  final bool applicationUpdates;
  final bool scholarshipDeadlines;
  final bool interviewReminders;
  final bool plannerReminders;
  final bool emailNotifications;
  final bool pushNotifications;

  // Privacy
  final bool analyticsToggle;

  // Developer
  final bool developerMode;
  final bool mockApiToggle;

  const AppSettings({
    this.language = 'English',
    this.themeMode = 'System',
    this.region = 'United States',
    this.timezone = 'EST',
    this.fontSize = 14.0,
    this.accessibilityMode = false,
    this.conversationMemory = true,
    this.aiSuggestions = true,
    this.aiNotifications = true,
    this.writingStyle = 'Professional',
    this.responseLength = 'Concise',
    this.applicationUpdates = true,
    this.scholarshipDeadlines = true,
    this.interviewReminders = true,
    this.plannerReminders = true,
    this.emailNotifications = false,
    this.pushNotifications = true,
    this.analyticsToggle = true,
    this.developerMode = false,
    this.mockApiToggle = true,
  });

  AppSettings copyWith({
    String? language,
    String? themeMode,
    String? region,
    String? timezone,
    double? fontSize,
    bool? accessibilityMode,
    bool? conversationMemory,
    bool? aiSuggestions,
    bool? aiNotifications,
    String? writingStyle,
    String? responseLength,
    bool? applicationUpdates,
    bool? scholarshipDeadlines,
    bool? interviewReminders,
    bool? plannerReminders,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? analyticsToggle,
    bool? developerMode,
    bool? mockApiToggle,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      region: region ?? this.region,
      timezone: timezone ?? this.timezone,
      fontSize: fontSize ?? this.fontSize,
      accessibilityMode: accessibilityMode ?? this.accessibilityMode,
      conversationMemory: conversationMemory ?? this.conversationMemory,
      aiSuggestions: aiSuggestions ?? this.aiSuggestions,
      aiNotifications: aiNotifications ?? this.aiNotifications,
      writingStyle: writingStyle ?? this.writingStyle,
      responseLength: responseLength ?? this.responseLength,
      applicationUpdates: applicationUpdates ?? this.applicationUpdates,
      scholarshipDeadlines: scholarshipDeadlines ?? this.scholarshipDeadlines,
      interviewReminders: interviewReminders ?? this.interviewReminders,
      plannerReminders: plannerReminders ?? this.plannerReminders,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      analyticsToggle: analyticsToggle ?? this.analyticsToggle,
      developerMode: developerMode ?? this.developerMode,
      mockApiToggle: mockApiToggle ?? this.mockApiToggle,
    );
  }

  factory AppSettings.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppSettings(
      language: data['language'] ?? 'English',
      themeMode: data['themeMode'] ?? 'System',
      region: data['region'] ?? 'United States',
      timezone: data['timezone'] ?? 'EST',
      fontSize: (data['fontSize'] ?? 14.0).toDouble(),
      accessibilityMode: data['accessibilityMode'] ?? false,
      conversationMemory: data['conversationMemory'] ?? true,
      aiSuggestions: data['aiSuggestions'] ?? true,
      aiNotifications: data['aiNotifications'] ?? true,
      writingStyle: data['writingStyle'] ?? 'Professional',
      responseLength: data['responseLength'] ?? 'Concise',
      applicationUpdates: data['applicationUpdates'] ?? true,
      scholarshipDeadlines: data['scholarshipDeadlines'] ?? true,
      interviewReminders: data['interviewReminders'] ?? true,
      plannerReminders: data['plannerReminders'] ?? true,
      emailNotifications: data['emailNotifications'] ?? false,
      pushNotifications: data['pushNotifications'] ?? true,
      analyticsToggle: data['analyticsToggle'] ?? true,
      developerMode: data['developerMode'] ?? false,
      mockApiToggle: data['mockApiToggle'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'language': language,
      'themeMode': themeMode,
      'region': region,
      'timezone': timezone,
      'fontSize': fontSize,
      'accessibilityMode': accessibilityMode,
      'conversationMemory': conversationMemory,
      'aiSuggestions': aiSuggestions,
      'aiNotifications': aiNotifications,
      'writingStyle': writingStyle,
      'responseLength': responseLength,
      'applicationUpdates': applicationUpdates,
      'scholarshipDeadlines': scholarshipDeadlines,
      'interviewReminders': interviewReminders,
      'plannerReminders': plannerReminders,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'analyticsToggle': analyticsToggle,
      'developerMode': developerMode,
      'mockApiToggle': mockApiToggle,
    };
  }
}
