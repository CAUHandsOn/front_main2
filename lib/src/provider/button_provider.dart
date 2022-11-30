import 'package:flutter/material.dart';

class ButtonProvider extends ChangeNotifier{
  int _editButton = 0;
  int get currentEditButton => _editButton;

  updateEditButton(int i){
    _editButton = i;
    notifyListeners();
  }
}