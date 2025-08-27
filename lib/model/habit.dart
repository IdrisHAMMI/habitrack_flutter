class Habit {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final int colorValue;
  final DateTime createdAt;
  bool isCompleted;
  int streak;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.colorValue,
    required this.createdAt,
    this.isCompleted = false,
    this.streak = 0,
  });

  // DATA CONVERSION
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
      'streak': streak,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      iconName: map['iconName'],
      colorValue: map['colorValue'],
      createdAt: DateTime.parse(map['createdAt']),
      isCompleted: map['isCompleted'],
      streak: map['streak'],
    );
  }

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    int? colorValue,
    DateTime? createdAt,
    bool? isCompleted,
    int? streak,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
    );
  }
}