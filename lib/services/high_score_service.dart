import 'package:shared_preferences/shared_preferences.dart';

class HighScoreService {
  static const String _highScoreKey = 'best_time';

  Future<double> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_highScoreKey) ?? 0.0;
  }

  Future<bool> saveHighScore(double score) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHigh = prefs.getDouble(_highScoreKey) ?? 0.0;
    if (score > currentHigh) {
      return prefs.setDouble(_highScoreKey, score);
    }
    return false;
  }
}
