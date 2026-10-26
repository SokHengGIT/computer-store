import 'package:flutter/material.dart';

class MenuService extends ChangeNotifier {
  int _currentPage = 0;
  int _previousPage = 0;
  Widget? _customPage; 

  int get currentPage => _currentPage;
  int get previousPage => _previousPage;
  Widget? get customPage => _customPage;

  void onPageChanged(int index) {
    if (_currentPage != index) {
      _previousPage = _currentPage;
      _currentPage = index;
    }
    _customPage = null; 
    notifyListeners();
  }

  void setPreviousPage(int index) {
    _previousPage = index;
  }
  void pushCustomPage(Widget page) {
    _customPage = page;
    notifyListeners();
  }
  void goBack() {
    if (_customPage != null) {
      _customPage = null;
      notifyListeners();
    } else {
      if (_currentPage == _previousPage) {
        _currentPage = 0;
      } else {
        final target = _previousPage;
        _previousPage = 0;
        _currentPage = target;
      }
      notifyListeners();
    }
  }
}
