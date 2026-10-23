import 'package:flutter/material.dart';

class MenuService extends ChangeNotifier {
  int _currentPage = 0;
  int _previousPage = 0;
  
  // Holds our deep-dive screens like CategoryScreen
  Widget? _customPage; 

  int get currentPage => _currentPage;
  int get previousPage => _previousPage;
  Widget? get customPage => _customPage;

  void onPageChanged(int index) {
    _previousPage = _currentPage; // Save the state before moving
    _currentPage = index;
    _customPage = null; 
    notifyListeners();
  }

  void setPreviousPage(int index) {
    _previousPage = index;
  }

  // Show a category screen without using Navigator.push
  void pushCustomPage(Widget page) {
    _customPage = page;
    notifyListeners();
  }

  // The teacher's custom Go Back function!
  void goBack() {
    if (_customPage != null) {
      // If we are looking at a category, clear it to reveal the main tabs again
      _customPage = null;
      notifyListeners();
    } else {
      // Otherwise, return to the previous tab index
      _currentPage = _previousPage;
      notifyListeners();
    }
  }
}