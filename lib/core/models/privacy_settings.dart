class PrivacySettings {
  final bool isPrivateAccount;
  final bool showFollowers;
  final bool allowFollowing;
  final bool isActive;

  PrivacySettings({
    required this.isPrivateAccount,
    required this.showFollowers,
    required this.allowFollowing,
    required this.isActive,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) => PrivacySettings(
    isPrivateAccount: json['isPrivateAccount'] ?? false,
    showFollowers: json['showFollowers'] ?? true,
    allowFollowing: json['allowFollowing'] ?? true,
    isActive: json['isActive'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'isPrivateAccount': isPrivateAccount,
    'showFollowers': showFollowers,
    'allowFollowing': allowFollowing,
    'isActive': isActive,
  };

  PrivacySettings copyWith({
    bool? isPrivateAccount,
    bool? showFollowers,
    bool? allowFollowing,
    bool? isActive,
  }) {
    return PrivacySettings(
      isPrivateAccount: isPrivateAccount ?? this.isPrivateAccount,
      showFollowers: showFollowers ?? this.showFollowers,
      allowFollowing: allowFollowing ?? this.allowFollowing,
      isActive: isActive ?? this.isActive,
    );
  }
} 