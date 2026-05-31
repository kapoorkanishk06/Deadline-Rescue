import 'package:flutter/foundation.dart';

enum EnergyLevel { low, medium, high }

class RescueState extends ChangeNotifier {
  int? _timeHours; // 1..5, where 5 represents 5+
  EnergyLevel? _energy;
  String _brainDump = '';
  
  int _computePriorityScore(String text) {
    int score = 0;
    final lower = text.toLowerCase();
    const urgentKeywords = [
      'exam',
      'deadline',
      'submit',
      'submission',
      'meeting',
      'call',
    ];
    if (urgentKeywords.any((kw) => lower.contains(kw))) {
      score += 2;
    }
    final words =
        lower.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.length > 5) {
      score -= 1;
    }
    return score;
  }

  int? get timeHours => _timeHours;
  EnergyLevel? get energy => _energy;
  String get brainDump => _brainDump;

  void setTimeHours(int hours) {
    _timeHours = hours;
    notifyListeners();
  }

  void setEnergy(EnergyLevel level) {
    _energy = level;
    notifyListeners();
  }

  void setBrainDump(String text) {
    _brainDump = text;
    notifyListeners();
  }

  List<String> get tasks {
    // Split by commas or newlines; trim and dedupe empties
    final raw = _brainDump
        .split(RegExp(r'[\n,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    // Step 1 – remove input-order bias: shuffle once
    raw.shuffle();
    // Step 2 – compute score for each task
    final scored = raw
        .map((t) => MapEntry(t, _computePriorityScore(t)))
        .toList();
    // Step 3 – sort by descending score; ties keep random order
    scored.sort((a, b) => b.value.compareTo(a.value));
    // Return only the task texts, in new priority order
    return scored.map((e) => e.key).toList();
    return raw;
  }
}
