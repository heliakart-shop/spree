class GameData {
  final String id;
  final String title;
  final String description;
  final List<String> rules;
  final List<String> materials;
  final int duration;
  final String difficulty;
  final String playerCount;
  final String instructions;
  final String scoringSystem;
  final List<String> tips;
  final String gameType;
  final String? theme;
  final DateTime createdAt;

  const GameData({
    required this.id,
    required this.title,
    required this.description,
    required this.rules,
    required this.materials,
    required this.duration,
    required this.difficulty,
    required this.playerCount,
    required this.instructions,
    required this.scoringSystem,
    required this.tips,
    required this.gameType,
    this.theme,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'rules': rules,
      'materials': materials,
      'duration': duration,
      'difficulty': difficulty,
      'playerCount': playerCount,
      'instructions': instructions,
      'scoringSystem': scoringSystem,
      'tips': tips,
      'gameType': gameType,
      'theme': theme,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      rules: List<String>.from(json['rules']),
      materials: List<String>.from(json['materials']),
      duration: json['duration'],
      difficulty: json['difficulty'],
      playerCount: json['playerCount'],
      instructions: json['instructions'],
      scoringSystem: json['scoringSystem'],
      tips: List<String>.from(json['tips']),
      gameType: json['gameType'],
      theme: json['theme'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  GameData copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? rules,
    List<String>? materials,
    int? duration,
    String? difficulty,
    String? playerCount,
    String? instructions,
    String? scoringSystem,
    List<String>? tips,
    String? gameType,
    String? theme,
    DateTime? createdAt,
  }) {
    return GameData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rules: rules ?? this.rules,
      materials: materials ?? this.materials,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      playerCount: playerCount ?? this.playerCount,
      instructions: instructions ?? this.instructions,
      scoringSystem: scoringSystem ?? this.scoringSystem,
      tips: tips ?? this.tips,
      gameType: gameType ?? this.gameType,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GameSettings {
  final String gameType;
  final String playerCount;
  final String ageGroup;
  final int duration;
  final String difficulty;
  final String location;
  final String? theme;

  const GameSettings({
    required this.gameType,
    required this.playerCount,
    required this.ageGroup,
    required this.duration,
    required this.difficulty,
    required this.location,
    this.theme,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameType': gameType,
      'playerCount': playerCount,
      'ageGroup': ageGroup,
      'duration': duration,
      'difficulty': difficulty,
      'location': location,
      'theme': theme,
    };
  }

  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      gameType: json['gameType'],
      playerCount: json['playerCount'],
      ageGroup: json['ageGroup'],
      duration: json['duration'],
      difficulty: json['difficulty'],
      location: json['location'],
      theme: json['theme'],
    );
  }

  GameSettings copyWith({
    String? gameType,
    String? playerCount,
    String? ageGroup,
    int? duration,
    String? difficulty,
    String? location,
    String? theme,
  }) {
    return GameSettings(
      gameType: gameType ?? this.gameType,
      playerCount: playerCount ?? this.playerCount,
      ageGroup: ageGroup ?? this.ageGroup,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      location: location ?? this.location,
      theme: theme ?? this.theme,
    );
  }
}

// Enums for predefined options
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