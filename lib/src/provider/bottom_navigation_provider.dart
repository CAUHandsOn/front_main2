import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier{
  int _index = 0;
  int get currentNavigationIndex => _index;

  updateIndex(int index){
    _index = index;
    notifyListeners();
  }
}