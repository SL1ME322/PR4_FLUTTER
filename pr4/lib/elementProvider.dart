import 'package:flutter/material.dart';

class ElementProvider extends ChangeNotifier{
  String _text ='';  
  String get text => _text;
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }
}