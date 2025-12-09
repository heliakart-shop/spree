import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/game_data.dart';

class ClaudeApiService {
  static const String _baseUrl = 'https://api.anthropic.com/v1';
  static const String _messagesEndpoint = '/messages';
  
  String get _apiKey => dotenv.env['CLAUDE_API_KEY'] ?? '';
  
  Future<GameData?> generateGame(ClaudeGameSettings settings) async {
    // Check if API key is available
    if (_apiKey.isEmpty || _apiKey == 'your_claude_api_key_here') {
      print('⚠️ Claude API key not configured. Using demo game...');
      return _createDemoGame(settings);
    }

    try {
      print('🚀 Attempting to generate game with Claude API...');
      final prompt = _buildGamePrompt(settings);
      
      final response = await http.post(
        Uri.parse('$_baseUrl$_messagesEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-3-sonnet-20240229',
          'max_tokens': 1500,
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      ).timeout(const Duration(seconds: 30));

      print('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['content'][0]['text'];
        print('✅ Successfully received response from Claude API');
        return _parseGameResponse(content, settings);
      } else if (response.statusCode == 401) {
        print('❌ Invalid API key. Using demo game...');
        return _createDemoGame(settings);
      } else if (response.statusCode == 429) {
        print('⏳ Rate limit exceeded. Using demo game...');
        return _createDemoGame(settings);
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        return _createDemoGame(settings);
      }
    } catch (e) {
      print('❌ Network/Connection Error: $e');
      print('🎮 Generating demo game instead...');
      return _createDemoGame(settings);
    }
  }

  String _buildGamePrompt(ClaudeGameSettings settings) {
    return '''
Create a fun ${settings.gameType.toLowerCase()} game for a party with the following specifications:

Party Details:
- Number of players: ${settings.playerCount}
- Age group: ${settings.ageGroup}
- Duration: ${settings.duration} minutes
- Difficulty: ${settings.difficulty}
- Location: ${settings.location}
- Theme: ${settings.theme ?? 'General'}

Requirements:
- The game should be engaging and appropriate for the specified age group
- Include clear, easy-to-follow rules
- Specify any materials needed
- Provide scoring system if applicable
- Make it suitable for the given location and duration
- Ensure it works well with the specified number of players

Please format your response as JSON with the following structure:
{
  "title": "Game Title",
  "description": "Brief description of the game",
  "rules": ["Rule 1", "Rule 2", "Rule 3"],
  "materials": ["Material 1", "Material 2"],
  "duration": ${settings.duration},
  "difficulty": "${settings.difficulty}",
  "playerCount": "${settings.playerCount}",
  "instructions": "Detailed step-by-step instructions",
  "scoringSystem": "How to score and win",
  "tips": ["Tip 1", "Tip 2"]
}

Make sure the game is creative, fun, and perfectly suited to the party settings!
''';
  }

  GameData? _parseGameResponse(String content, ClaudeGameSettings settings) {
    try {
      // Extract JSON from the response
      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
      if (jsonMatch == null) {
        throw Exception('No JSON found in response');
      }

      final jsonString = jsonMatch.group(0)!;
      final gameJson = jsonDecode(jsonString);

      return GameData(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: gameJson['title'] ?? 'Generated Game',
        description: gameJson['description'] ?? '',
        rules: List<String>.from(gameJson['rules'] ?? []),
        materials: List<String>.from(gameJson['materials'] ?? []),
        duration: gameJson['duration'] ?? settings.duration,
        difficulty: gameJson['difficulty'] ?? settings.difficulty,
        playerCount: gameJson['playerCount'] ?? settings.playerCount,
        instructions: gameJson['instructions'] ?? '',
        scoringSystem: gameJson['scoringSystem'] ?? '',
        tips: List<String>.from(gameJson['tips'] ?? []),
        gameType: settings.gameType,
        theme: settings.theme,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('Error parsing game response: $e');
      return _createDemoGame(settings);
    }
  }

  GameData _createDemoGame(ClaudeGameSettings settings) {
    final random = Random();
    final games = _getDemoGames(settings);
    final selectedGame = games[random.nextInt(games.length)];
    
    return GameData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: selectedGame['title'],
      description: selectedGame['description'],
      rules: List<String>.from(selectedGame['rules']),
      materials: List<String>.from(selectedGame['materials']),
      duration: settings.duration,
      difficulty: settings.difficulty,
      playerCount: settings.playerCount,
      instructions: selectedGame['instructions'],
      scoringSystem: selectedGame['scoringSystem'],
      tips: List<String>.from(selectedGame['tips']),
      gameType: settings.gameType,
      theme: settings.theme,
      createdAt: DateTime.now(),
    );
  }

  List<Map<String, dynamic>> _getDemoGames(ClaudeGameSettings settings) {
    // Different games based on game type
    switch (settings.gameType) {
      case 'Ice Breakers':
        return [
          {
            'title': 'Human Bingo',
            'description': 'Find people who match different characteristics on your bingo card.',
            'rules': [
              'Each player gets a bingo card with different traits or experiences',
              'Mingle and find people who match each square',
              'Get them to sign their name in that square',
              'First to complete a line (or full card) wins'
            ],
            'materials': ['Bingo cards', 'Pens'],
            'instructions': 'Create bingo cards with traits like "Has traveled to Asia", "Speaks 3 languages", "Born in winter", etc. Players must find different people for each square.',
            'scoringSystem': 'First to get a line wins. For longer games, aim for full card completion.',
            'tips': ['Make traits specific to your group', 'Include fun and surprising facts', 'Encourage conversation beyond just signing']
          },
          {
            'title': 'Two Truths and a Lie Plus',
            'description': 'Classic icebreaker with a creative twist and team scoring.',
            'rules': [
              'Each player writes 3 statements about themselves (2 true, 1 false)',
              'Present statements to the group',
              'Others vote on which is the lie',
              'Reveal the answer and award points'
            ],
            'materials': ['Paper', 'Pens', 'Scoring sheet'],
            'instructions': 'Go around the circle. Each person shares their statements. Group discusses and votes. Most creative lie and best detective get bonus points.',
            'scoringSystem': '1 point for guessing correctly, 2 points for fooling everyone with your lie, 1 bonus point for most creative statement.',
            'tips': ['Make truths sound unbelievable', 'Keep lies realistic', 'Ask follow-up questions for more fun']
          }
        ];
      
      case 'Team Building':
        return [
          {
            'title': 'Perfect Square Challenge',
            'description': 'Teams must form a perfect square while blindfolded - communication is key!',
            'rules': [
              'Teams of 6-8 people get a long rope',
              'Everyone puts on blindfolds',
              'Team must form a perfect square with the rope',
              'Only verbal communication allowed'
            ],
            'materials': ['Long rope or string', 'Blindfolds', 'Timer'],
            'instructions': 'Give each team a rope. Once blindfolded, they must work together using only verbal communication to create a perfect square. Time each attempt.',
            'scoringSystem': 'Fastest team to create an accurate square wins. Judge based on corner angles and side lengths.',
            'tips': ['Assign roles like "corner person" or "measurer"', 'Practice communication phrases', 'Start with simpler shapes if needed']
          },
          {
            'title': 'Collaborative Story Building',
            'description': 'Build an epic story together with unexpected twists and teamwork.',
            'rules': [
              'Form teams of 4-5 people',
              'First person writes opening sentence',
              'Pass paper clockwise, each adds one sentence',
              'Include mandatory elements drawn from hat'
            ],
            'materials': ['Paper', 'Pens', 'Element cards', 'Timer'],
            'instructions': 'Each round, draw 3 random elements (character, location, object). Teams have 15 minutes to create a story incorporating all elements. Read aloud and vote.',
            'scoringSystem': 'Points for creativity, use of all elements, and audience votes. Bonus for best plot twist.',
            'tips': ['Encourage wild creativity', 'Yes-and mentality', 'Read with dramatic flair']
          }
        ];

      case 'Creative Games':
        return [
          {
            'title': 'Artistic Telephone',
            'description': 'Like telephone, but alternating between drawing and describing - hilarious results guaranteed!',
            'rules': [
              'Start with a phrase or sentence',
              'First person draws it',
              'Next person describes the drawing',
              'Continue alternating drawing/describing',
              'Reveal the progression at the end'
            ],
            'materials': ['Paper', 'Pencils', 'Clipboards or books'],
            'instructions': 'Each person starts with a stack of papers. Write a phrase on top sheet, pass left. Next person draws it on new sheet (hiding phrase), passes left. Continue until back to start.',
            'scoringSystem': 'No winners - just enjoy the hilarious transformations! Can vote for funniest progression.',
            'tips': ['Keep phrases moderately complex', 'No talking during game', 'Don\'t worry about artistic skill']
          },
          {
            'title': 'Random Object Innovation',
            'description': 'Invent creative new uses for everyday objects and pitch them like entrepreneurs.',
            'rules': [
              'Teams draw random household objects',
              'Invent 3 completely new uses for the object',
              'Create a 2-minute sales pitch',
              'Present to "investors" (other teams)'
            ],
            'materials': ['Object cards/pictures', 'Timer', 'Presentation materials'],
            'instructions': 'Each team gets a random object (paperclip, rubber boot, etc.). Spend 10 minutes brainstorming innovative uses, then 5 minutes preparing pitch. Present shark-tank style.',
            'scoringSystem': 'Vote for most creative, most practical, and most entertaining pitch. Teams can\'t vote for themselves.',
            'tips': ['Think outside the box', 'Make it entertaining', 'Use props and demonstrations']
          }
        ];

      case 'Physical Activities':
        return [
          {
            'title': 'Silent Line-Up Challenge',
            'description': 'Line up in order without speaking - harder than it sounds!',
            'rules': [
              'No talking or writing allowed',
              'Line up in order based on given criteria',
              'Use only gestures and non-verbal communication',
              'Team with most accurate order wins'
            ],
            'materials': ['Space to move around', 'Criteria cards'],
            'instructions': 'Call out criteria like "birthday order", "height", "number of siblings". Teams must organize themselves silently. Check final order.',
            'scoringSystem': 'Points for correct positioning. Fastest correct lineup gets bonus points.',
            'tips': ['Start with obvious criteria like height', 'Use creative hand signals', 'Be patient with communication']
          }
        ];

      case 'Mind Games':
        return [
          {
            'title': 'Memory Palace Relay',
            'description': 'Test your memory skills with increasingly complex sequences and teamwork.',
            'rules': [
              'Teams create a sequence of actions/words',
              'Each team member adds one element',
              'Must repeat entire sequence before adding',
              'Mistake eliminates that round'
            ],
            'materials': ['Cards with actions/words', 'Timer'],
            'instructions': 'Start with simple sequences. Each person adds to the sequence and must perform/recite the entire thing. Complexity increases each round.',
            'scoringSystem': 'Points for longest successful sequence. Bonus points for creativity in additions.',
            'tips': ['Create memorable connections', 'Use physical actions for memory', 'Start slow and build up']
          }
        ];

      default: // Party Classics
        return [
          {
            'title': 'Musical Chairs Evolution',
            'description': 'Classic musical chairs with creative twists and variations.',
            'rules': [
              'Start with traditional musical chairs',
              'Add challenges: dance styles, freeze poses, partner matching',
              'Eliminated players become judges/DJs',
              'Final round has special challenge'
            ],
            'materials': ['Music player', 'Chairs', 'Challenge cards'],
            'instructions': 'Begin normally, but each round introduces new rules. Maybe "zombie walk" round, or "find partner" round. Keep eliminated players engaged as helpers.',
            'scoringSystem': 'Last player standing wins, but award style points for creativity and fun participation.',
            'tips': ['Keep eliminated players involved', 'Vary music styles', 'Focus on fun over competition']
          },
          {
            'title': 'Charades Championship',
            'description': 'Enhanced charades with categories, themes, and tournament structure.',
            'rules': [
              'Teams of 3-4 players',
              'Categories: movies, books, songs, famous people',
              'One minute per turn',
              'No talking, letters, or sounds'
            ],
            'materials': ['Category cards', 'Timer', 'Score sheet'],
            'instructions': 'Tournament style with different rounds. Start with easy categories, progress to harder ones. Final round mixes all categories.',
            'scoringSystem': '1 point per correct guess, bonus round worth double points. Best actor award for most entertaining performance.',
            'tips': ['Use clear gestures', 'Act out syllables if needed', 'Keep it energetic and fun']
          }
        ];
    }
  }
}

// Separate GameSettings class for Claude API to avoid conflicts
class ClaudeGameSettings {
  final String gameType;
  final String playerCount;
  final String ageGroup;
  final int duration;
  final String difficulty;
  final String location;
  final String? theme;
  final DateTime createdAt;

  ClaudeGameSettings({
    required this.gameType,
    required this.playerCount,
    required this.ageGroup,
    required this.duration,
    required this.difficulty,
    required this.location,
    this.theme,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

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

  factory ClaudeGameSettings.fromJson(Map<String, dynamic> json) {
    return ClaudeGameSettings(
      gameType: json['gameType'] as String? ?? 'Party Classics',
      playerCount: json['playerCount'] as String? ?? '6-10 players',
      ageGroup: json['ageGroup'] as String? ?? 'Adults (18+)',
      duration: json['duration'] as int? ?? 15,
      difficulty: json['difficulty'] as String? ?? 'Medium',
      location: json['location'] as String? ?? 'Indoor',
      theme: json['theme'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  ClaudeGameSettings copyWith({
    String? gameType,
    String? playerCount,
    String? ageGroup,
    int? duration,
    String? difficulty,
    String? location,
    String? theme,
    DateTime? createdAt,
  }) {
    return ClaudeGameSettings(
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
}