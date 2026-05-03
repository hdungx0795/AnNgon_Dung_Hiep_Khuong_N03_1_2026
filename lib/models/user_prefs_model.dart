import 'package:hive/hive.dart';

part 'user_prefs_model.g.dart';

@HiveType(typeId: 9)
class UserPrefsModel {
  @HiveField(0)
  final List<int> favoriteIds;
  
  @HiveField(1)
  final bool isDarkMode;
  
  @HiveField(2)
  final bool onboardingDone;

  UserPrefsModel({
    this.favoriteIds = const [],
    this.isDarkMode = false,
    this.onboardingDone = false,
  });

  UserPrefsModel copyWith({
    List<int>? favoriteIds,
    bool? isDarkMode,
    bool? onboardingDone,
  }) {
    return UserPrefsModel(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      onboardingDone: onboardingDone ?? this.onboardingDone,
    );
  }
}
