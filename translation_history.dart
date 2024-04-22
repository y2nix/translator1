import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TranslationHistory {
  static final TranslationHistory _instance = TranslationHistory._internal();

  factory TranslationHistory() {
    return _instance;
  }

  TranslationHistory._internal();

  List<Map<String, String>> _history = [];

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList('translation_history');
    if (history != null) {
      _history = history.map((entry) => Map<String, String>.from(json.decode(entry))).toList();
    }
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyStrings = _history.map((entry) => json.encode(entry)).toList();
    await prefs.setStringList('translation_history', historyStrings);
  }

  void addTranslation(String text, String sourceLanguage, String targetLanguage, String translation) {
    print('Adding translation to history: text: $text, source: $sourceLanguage, target: $targetLanguage, translation: $translation');
    final entry = {
      'text': text,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'translation': translation,
    };
    _history.add(entry);
    saveHistory();
  }

  List<Map<String, String>> get history => _history;
}
