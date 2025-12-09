class GameSettings {
  final String gameType;
  final String playerCount;
  final String ageGroup;
  final int duration;
  final String difficulty;
  final String location;
  final String? theme;
  final DateTime createdAt;

  GameSettings({
    required this.gameType,
    required this.playerCount,
    required this.ageGroup,
    required this.duration,
    required this.difficulty,
    required this.location,
    this.theme,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'gameType': gameType,
      'playerCount': playerCount,
      'ageGroup': ageGroup,
      'duration': duration,
      'difficulty': difficulty,
      'location': location,
      'theme': theme,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      gameType: json['gameType'] as String? ?? GameTypes.partyClassics,
      playerCount: json['playerCount'] as String? ?? PlayerCounts.medium,
      ageGroup: json['ageGroup'] as String? ?? AgeGroups.adults,
      duration: json['duration'] as int? ?? 15,
      difficulty: json['difficulty'] as String? ?? DifficultyLevels.medium,
      location: json['location'] as String? ?? Locations.indoor,
      theme: json['theme'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  // Create copy with modifications
  GameSettings copyWith({
    String? gameType,
    String? playerCount,
    String? ageGroup,
    int? duration,
    String? difficulty,
    String? location,
    String? theme,
    DateTime? createdAt,
  }) {
    return GameSettings(
      gameType: gameType ?? this.gameType,
      playerCount: playerCount ?? this.playerCount,
      ageGroup: ageGroup ?? this.ageGroup,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      location: location ?? this.location,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'GameSettings{gameType: $gameType, playerCount: $playerCount, ageGroup: $ageGroup, duration: $duration, difficulty: $difficulty, location: $location, theme: $theme}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is GameSettings &&
        other.gameType == gameType &&
        other.playerCount == playerCount &&
        other.ageGroup == ageGroup &&
        other.duration == duration &&
        other.difficulty == difficulty &&
        other.location == location &&
        other.theme == theme;
  }

  @override
  int get hashCode {
    return gameType.hashCode ^
        playerCount.hashCode ^
        ageGroup.hashCode ^
        duration.hashCode ^
        difficulty.hashCode ^
        location.hashCode ^
        (theme?.hashCode ?? 0);
  }

  // Validation
  bool get isValid {
    return gameType.isNotEmpty &&
        playerCount.isNotEmpty &&
        ageGroup.isNotEmpty &&
        duration > 0 &&
        difficulty.isNotEmpty &&
        location.isNotEmpty;
  }

  List<String> get validationErrors {
    final errors = <String>[];
    
    if (gameType.isEmpty) errors.add('Game type is required');
    if (playerCount.isEmpty) errors.add('Player count is required');
    if (ageGroup.isEmpty) errors.add('Age group is required');
    if (duration <= 0) errors.add('Duration must be greater than 0');
    if (duration > 120) errors.add('Duration cannot exceed 120 minutes');
    if (difficulty.isEmpty) errors.add('Difficulty level is required');
    if (location.isEmpty) errors.add('Location is required');
    
    return errors;
  }

  // Display helpers
  String get displayDuration {
    if (duration < 60) {
      return '$duration minutes';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) {
      return hours == 1 ? '1 hour' : '$hours hours';
    }
    return '${hours}h ${minutes}m';
  }

  String get shortDescription {
    return '$gameType for $playerCount ($displayDuration)';
  }
}

// Game Types
class GameTypes {
  static const String iceBreakers = 'Ice Breakers';
  static const String teamBuilding = 'Team Building';
  static const String creative = 'Creative Games';
  static const String physical = 'Physical Activities';
  static const String mindGames = 'Mind Games';
  static const String partyClassics = 'Party Classics';
  
  static const List<String> all = [
    iceBreakers,
    teamBuilding,
    creative,
    physical,
    mindGames,
    partyClassics,
  ];
}

// Player Counts
class PlayerCounts {
  static const String small = '2-5 players';
  static const String medium = '6-10 players';
  static const String large = '11-20 players';
  static const String extraLarge = '20+ players';
  
  static const List<String> all = [
    small,
    medium,
    large,
    extraLarge,
  ];
}

// Age Groups
class AgeGroups {
  static const String kids = 'Kids (6-12)';
  static const String teens = 'Teens (13-17)';
  static const String adults = 'Adults (18+)';
  static const String mixed = 'Mixed Ages';
  
  static const List<String> all = [
    kids,
    teens,
    adults,
    mixed,
  ];
}

// Difficulty Levels
class DifficultyLevels {
  static const String easy = 'Easy';
  static const String medium = 'Medium';
  static const String hard = 'Hard';
  
  static const List<String> all = [
    easy,
    medium,
    hard,
  ];
}

// Locations
class Locations {
  static const String indoor = 'Indoor';
  static const String outdoor = 'Outdoor';
  static const String both = 'Both';
  
  static const List<String> all = [
    indoor,
    outdoor,
    both,
  ];
}

// Game Themes
class GameThemes {
  static const String birthday = 'Birthday';
  static const String holiday = 'Holiday';
  static const String halloween = 'Halloween';
  static const String christmas = 'Christmas';
  static const String summer = 'Summer';
  static const String sports = 'Sports';
  static const String movie = 'Movie Night';
  static const String retro = 'Retro';
  static const String music = 'Music';
  static const String general = 'General';
  
  static const List<String> all = [
    general,
    birthday,
    holiday,
    halloween,
    christmas,
    summer,
    sports,
    movie,
    retro,
    music,
  ];
}