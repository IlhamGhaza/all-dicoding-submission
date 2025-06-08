import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../utils/env.dart';

class FoodRecognitionProvider extends ChangeNotifier {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  bool _isProcessing = false;
  Map<String, dynamic>? _lastPrediction;
  Map<String, dynamic>? _lastMealData;
  Map<String, dynamic>? _lastNutritionalData;

  bool _isIdentifyingFood = false;
  bool _isFetchingMealData = false;
  bool _isFetchingNutritionalData = false;

  bool get isModelLoaded => _isModelLoaded;
  bool get isProcessing => _isProcessing;
  Map<String, dynamic>? get lastPrediction => _lastPrediction;
  Map<String, dynamic>? get lastMealData => _lastMealData;
  Map<String, dynamic>? get lastNutritionalData => _lastNutritionalData;

  bool get isIdentifyingFood => _isIdentifyingFood;
  bool get isFetchingMealData => _isFetchingMealData;
  bool get isFetchingNutritionalData => _isFetchingNutritionalData;

  
  
  
  
  Future<void> loadModel() async {
    try {
      _isProcessing = true;
      notifyListeners();
      final modelFile = await _getModelFile();
      _interpreter = Interpreter.fromFile(modelFile);
      _isModelLoaded = true;
    } catch (e) {
      debugPrint('Error loading model: $e');
      _isModelLoaded = false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<File> _getModelFile() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelPath = path.join(appDir.path, 'aiy.tflite');
    final modelFile = File(modelPath);

    if (!await modelFile.exists()) {
      final modelData = await rootBundle.load('assets/aiy.tflite');
      await modelFile.writeAsBytes(modelData.buffer.asUint8List());
    }
    return modelFile;
  }

  void clearLastData() {
    _lastPrediction = null;
    _lastMealData = null;
    _lastNutritionalData = null;
    _isIdentifyingFood = false;
    _isFetchingMealData = false;
    _isFetchingNutritionalData = false;
    _isProcessing = false;
    notifyListeners();
  }

  Future<void> processImageAndFetchDetails(String imagePath) async {
    try {
      _isProcessing = true;
      _isIdentifyingFood = true;
      _lastMealData = null;
      _lastNutritionalData = null;
      _lastPrediction = null;
      notifyListeners();

      final foodName = await _getFoodNameFromImage(imagePath);
      _isIdentifyingFood = false;

      if (foodName == null) {
        _lastPrediction = {'label': 'Unknown Food', 'confidence': 0.0};
        notifyListeners();
        _isProcessing = false;
        notifyListeners();
        return;
      }

      _lastPrediction = {'label': foodName, 'confidence': 0.95}; 
      notifyListeners();

      _isFetchingMealData = true;
      notifyListeners();

      String nameForNutritionAPI = foodName;
      try {
        await _fetchMealData(foodName);
        if (_lastMealData != null && _lastMealData!['strMeal'] != null && (_lastMealData!['strMeal'] as String).isNotEmpty) {
          nameForNutritionAPI = _lastMealData!['strMeal'] as String;
        }
      } catch (e) {
        debugPrint("Error fetching meal data: $e");
      } finally {
        _isFetchingMealData = false;
        notifyListeners();
      }

      _isFetchingNutritionalData = true;
      notifyListeners();
      try {
        await _fetchNutritionalData(nameForNutritionAPI);
      } catch (e) {
        debugPrint("Error fetching nutritional data from Gemini: $e");
      } finally {
        _isFetchingNutritionalData = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error in prediction process: $e');
      _lastPrediction ??= {'label': 'Error', 'confidence': 0.0};
    } finally {
      _isIdentifyingFood = false; 
      _isFetchingMealData = false;
      _isFetchingNutritionalData = false;
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<String?> _getFoodNameFromImage(String imagePath) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: Env.geminiApiKey,
      );

      final prompt = TextPart(
        "What is the name of the food in this image? Please provide only the most common name for it.",
      );
      final imageBytes = await File(imagePath).readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      return response.text?.trim();
    } catch (e) {
      debugPrint("Error identifying food with Gemini Vision: $e");
      return null;
    }
  }

  Future<void> _fetchNutritionalData(String foodName) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: Env.geminiApiKey,
      );
      final prompt =
          'Provide nutritional data (calories, carbohydrates, protein, fat, fiber) for $foodName. Please respond in a clean JSON format like this: {"calories": "...", "carbohydrates": "...", "protein": "...", "fat": "...", "fiber": "..."}.';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text != null) {
        String jsonString = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        _lastNutritionalData = json.decode(jsonString); 
      }
    } catch (e) {
      debugPrint('Error fetching nutritional data from Gemini: $e');
    }
  }

  Future<void> _fetchMealData(String foodLabel) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/search.php?s=$foodLabel',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          _lastMealData = data['meals'][0]; 
        }
      }
    } catch (e) {
      debugPrint('Error fetching meal data: $e');
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}
