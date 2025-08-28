import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/habit.dart';
import 'add_habit_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // IN MEMORY STORAGE
  List<Habit> habits = [];

  // ICON MAPPING
  final Map<String, IconData> iconMap = {
    'water': Icons.local_drink,
    'sport': Icons.fitness_center,
    'book': Icons.book,
    'meditation': Icons.spa,
    'sleep': Icons.bed,
    'food': Icons.restaurant,
    'walk': Icons.directions_walk,
    'music': Icons.music_note,
  };

  // COLOR MAPPING
  final Map<String, Color> colorMap = {
    'blue': Colors.blue,
    'red': Colors.red,
    'green': Colors.green,
    'purple': Colors.purple,
    'orange': Colors.orange,
    'pink': Colors.pink,
    'teal': Colors.teal,
    'indigo': Colors.indigo,
  };

  @override
  void initState() {
    super.initState();
    _loadTodaysHabits(); // LOAD TODAY'S HABITS
  }

  // DAILY STORAGE (this clears at midnight, need to find a way to persist across app restarts)
  Future<void> _loadTodaysHabits() async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    String? savedDate = prefs.getString('habits_date');
    
    // If it's a new day, clear old data
    if (savedDate != today) {
      await prefs.remove('daily_habits');
      await prefs.setString('habits_date', today);
      setState(() {
        _loadSampleHabits(); // Load sample habits
      });
      _saveTodaysHabits(); // Save them immediately
      return;
    }
    
    // LOAD TODAY'S SAVED HABITS
    List<String>? habitStrings = prefs.getStringList('daily_habits');
    if (habitStrings != null && habitStrings.isNotEmpty) {
      try {
        setState(() {
          habits = habitStrings.map((s) => Habit.fromJson(json.decode(s))).toList();
        });
      } catch (e) {
        // If there's an error loading, start fresh
        setState(() {
          _loadSampleHabits();
        });
        _saveTodaysHabits();
      }
    } else {
      setState(() {
        _loadSampleHabits(); // No saved habits, load samples
      });
      _saveTodaysHabits(); // Save them
    }
  }

  // SAVE TODAY'S HABITS
  void _saveTodaysHabits() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> habitStrings = habits.map((h) => json.encode(h.toJson())).toList();
    await prefs.setStringList('daily_habits', habitStrings);
  }

  // LOAD SAMPLE HABITS (SIMULATE DATA)
  // This is purely static
  void _loadSampleHabits() {
    habits = [
      Habit(
        id: '1',
        name: 'Boire 2L d\'eau',
        description: 'Rester hydraté toute la journée',
        iconName: 'water',
        colorValue: Colors.blue.value,
        streak: 5,
      ),
      Habit(
        id: '2',
        name: 'Faire du sport',
        description: '30 minutes d\'activité physique',
        iconName: 'sport',
        colorValue: Colors.red.value,
        streak: 3,
        isCompleted: true,
      ),
      Habit(
        id: '3',
        name: 'Lire 30 minutes',
        description: 'Lecture quotidienne',
        iconName: 'book',
        colorValue: Colors.green.value,
        streak: 12,
      ),
    ];
  }

  // ADD NEW HABIT (CALLED FROM add_habit_page)
  void addHabit(Habit newHabit) {
    setState(() {
      habits.add(newHabit);
    });
    _saveTodaysHabits(); // Save after adding new habit
  }

  // DELETE HABIT
  void _deleteHabit(String habitId) {
    setState(() {
      habits.removeWhere((habit) => habit.id == habitId);
    });
    _saveTodaysHabits(); // Save after deleting
  }

  // DELETE DIALOG
  void _showDeleteDialog(Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer l\'habitude'),
          content: Text('Êtes-vous sûr de vouloir supprimer "${habit.name}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deleteHabit(habit.id);  // Delete habit
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  // TOGGLE HABIT COMPLETION
  void _toggleHabit(String habitId) {
    setState(() {
      int index = habits.indexWhere((habit) => habit.id == habitId);
      if (index != -1) {
        Habit oldHabit = habits[index];
        
        // Toggle completion and update streak
        bool newCompletionStatus = !oldHabit.isCompleted;
        int newStreak = oldHabit.streak;
        
        if (newCompletionStatus && !oldHabit.isCompleted) {
          // Marking as complete
          newStreak++;
        } else if (!newCompletionStatus && oldHabit.isCompleted) {
          // Unmarking as complete
          newStreak = newStreak > 0 ? newStreak - 1 : 0;
        }
        
        habits[index] = oldHabit.copyWith(
          isCompleted: newCompletionStatus,
          streak: newStreak,
        );
      }
    });
    _saveTodaysHabits(); // Save
  }

  // CALCULATE TODAY'S PROGRESS
  double _getTodayProgress() {
    if (habits.isEmpty) return 0.0;
    int completedCount = habits.where((habit) => habit.isCompleted).length;
    return completedCount / habits.length;
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = habits.where((habit) => habit.isCompleted).length;
    
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Mes Habitudes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF6C63FF),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with progress
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF6C63FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aujourd\'hui',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  _getTodayDateString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _getTodayProgress(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      '$completedCount/${habits.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Habits list
          Expanded(
            child: habits.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vos habitudes du jour',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              return _buildHabitCard(habits[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      
      // Add habit button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add habit page
          final newHabit = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHabitPage(),
            ),
          );
          
          if (newHabit != null) {
            addHabit(newHabit);
          }
        },
        backgroundColor: Color(0xFF6C63FF),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // EMPTY STATE WHEN NO HABITS
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.track_changes, size: 100, color: Colors.grey[300]),
          SizedBox(height: 20),
          Text(
            'Aucune habitude pour le moment',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          Text(
            'Appuyez sur + pour créer votre première habitude',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // BUILD HABIT CARD
  Widget _buildHabitCard(Habit habit) {
    IconData icon = iconMap[habit.iconName] ?? Icons.circle;
    Color color = Color(habit.colorValue);
    
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          
          SizedBox(width: 15),
          
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                if (habit.description.isNotEmpty) ...[
                  SizedBox(height: 5),
                  Text(
                    habit.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                    SizedBox(width: 5),
                    Text(
                      '${habit.streak} jours',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Actions row
          Row(
            children: [
              // Delete button
              GestureDetector(
                onTap: () => _showDeleteDialog(habit),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red[400],
                    size: 20,
                  ),
                ),
              ),
              
              SizedBox(width: 10),
              
              // Completion checkbox
              GestureDetector(
                onTap: () => _toggleHabit(habit.id),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: habit.isCompleted ? color : Colors.transparent,
                    border: Border.all(
                      color: habit.isCompleted ? color : Colors.grey[400]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: habit.isCompleted
                      ? Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // FRENCH DATE FORMAT
  String _getTodayDateString() {
    DateTime now = DateTime.now();
    List<String> months = [
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${now.day} ${months[now.month]} ${now.year}';
  }
}
