import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Define primary color
  Color _primaryColor = Colors.blue; // Default color, change as needed
  Color get primaryColor => _primaryColor;

  // Other color properties
  Color _bgColor = Colors.white;
  Color get bgColor => _bgColor;

  Color _textColor = Colors.black;
  Color get textColor => _textColor;

  // Add methods to update colors if needed
  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void setBgColor(Color color) {
    _bgColor = color;
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    notifyListeners();
  }
}
