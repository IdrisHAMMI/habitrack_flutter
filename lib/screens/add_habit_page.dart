import 'package:flutter/material.dart';
import '../model/habit.dart';

class AddHabitPage extends StatefulWidget {
  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  String selectedIconName = 'water';
  String selectedColorName = 'blue';

  final Map<String, IconData> availableIcons = {
    'water': Icons.local_drink,
    'sport': Icons.fitness_center,
    'book': Icons.book,
    'meditation': Icons.spa,
    'sleep': Icons.bed,
    'food': Icons.restaurant,
    'walk': Icons.directions_walk,
    'music': Icons.music_note,
    'work': Icons.work,
    'study': Icons.school,
  };


  final Map<String, Color> availableColors = {
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
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // SAVE HABIT AND RETURN TO PREVIOUS SCREEN
  void _saveHabit() {
    if (nameController.text.trim().isEmpty) {
      // Show error if name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le nom de l\'habitude est requis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // CREATE NEW HABIT
    final newHabit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple unique ID
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      iconName: selectedIconName,
      colorValue: availableColors[selectedColorName]!.value,
    );

    // Return the new habit to the previous screen
    Navigator.pop(context, newHabit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Nouvelle Habitude',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF6C63FF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveHabit,
            child: Text(
              'Sauver',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form title
            Text(
              'Créer une nouvelle habitude',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Habit name field
            Text(
              'Nom de l\'habitude *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Ex: Boire 2L d\'eau',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF6C63FF), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),
            
            SizedBox(height: 25),
            
            // Description field
            Text(
              'Description (optionnel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Ajouter une description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color(0xFF6C63FF), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
            ),
            
            SizedBox(height: 25),
            
            // Icon selection
            Text(
              'Choisir une icône',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableIcons.length,
                itemBuilder: (context, index) {
                  String iconName = availableIcons.keys.elementAt(index);
                  IconData icon = availableIcons[iconName]!;
                  bool isSelected = iconName == selectedIconName;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIconName = iconName;
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF6C63FF) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? Color(0xFF6C63FF) : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.grey[600],
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 25),
            
            // Color selection
            Text(
              'Choisir une couleur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 15),
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: availableColors.entries.map((entry) {
                String colorName = entry.key;
                Color color = entry.value;
                bool isSelected = colorName == selectedColorName;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColorName = colorName;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: 30),
            
            // Preview card
            Text(
              'Aperçu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 15),
            _buildPreviewCard(),
            
            Spacer(),
            
            // Save button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Créer l\'habitude',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Preview how the habit will look
  Widget _buildPreviewCard() {
    IconData selectedIcon = availableIcons[selectedIconName]!;
    Color selectedColor = availableColors[selectedColorName]!;
    String habitName = nameController.text.trim().isEmpty 
        ? 'Nom de l\'habitude' 
        : nameController.text.trim();
    
    return Container(
      width: double.infinity,
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
          // Icon preview
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: selectedColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(selectedIcon, color: selectedColor, size: 28),
          ),
          
          SizedBox(width: 15),
          
          // Text preview
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habitName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                if (descriptionController.text.trim().isNotEmpty) ...[
                  SizedBox(height: 5),
                  Text(
                    descriptionController.text.trim(),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
          
          // Checkbox preview
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}