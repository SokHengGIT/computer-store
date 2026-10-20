import 'package:flutter/material.dart';

class MenuService extends ChangeNotifier{
  int currentPage = 0;
  int previousPage = 0;

  void onPageChanged (int index) {
    currentPage = index;
    notifyListeners();
  }

  void setPreviousPage(int index) {
     previousPage = index;
  }
}