class Habit {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final int colorValue;
  final DateTime createdDate;
  bool isCompleted;
  int streak;

  Habit({
    required this.id,
    required this.name,
    this.description = '',
    required this.iconName,
    required this.colorValue,
    DateTime? createdDate,
    this.isCompleted = false,
    this.streak = 0,
  }) : createdDate = createdDate ?? DateTime.now();

  // DATA CONVERSION TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'colorValue': colorValue,
      'createdDate': createdDate.toIso8601String(),
      'isCompleted': isCompleted,
      'streak': streak,
    };
  }

  // JSON MAP CREATION
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconName: json['iconName'],
      colorValue: json['colorValue'],
      createdDate: DateTime.parse(json['createdDate']),
      isCompleted: json['isCompleted'],
      streak: json['streak'],
    );
  }

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    int? colorValue,
    DateTime? createdDate,
    bool? isCompleted,
    int? streak,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      createdDate: createdDate ?? this.createdDate,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
    );
  }
}