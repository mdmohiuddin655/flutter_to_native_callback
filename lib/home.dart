import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NutritionData {
  static const platform = MethodChannel('nutrition_widget');

  static Future<void> updateWidgetData(Map<String, dynamic> data) async {
    try {
      await platform.invokeMethod('updateWidget', data);
    } on PlatformException catch (e) {
      log('Error: ${e.message}');
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _calorieController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  Future<void> _updateData() async {
    final data = {
      'calories': double.tryParse(_calorieController.text) ?? 0,
      'protein': double.tryParse(_proteinController.text) ?? 0,
      'carbs': double.tryParse(_carbsController.text) ?? 0,
      'fats': double.tryParse(_fatsController.text) ?? 0,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    await NutritionData.updateWidgetData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nutrition Tracker')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _calorieController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Calories'),
            ),
            TextField(
              controller: _proteinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Protein (g)'),
            ),
            TextField(
              controller: _carbsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Carbs (g)'),
            ),
            TextField(
              controller: _fatsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Fats (g)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateData,
              child: Text('Update Widget'),
            ),
          ],
        ),
      ),
    );
  }
}
