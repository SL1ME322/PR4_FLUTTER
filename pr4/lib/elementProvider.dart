import 'package:flutter/material.dart';

class ElementProvider extends ChangeNotifier{
  List<String> test = [];

  String _text ='';  
  String get text => _text;
  void deleteElement(int index){
    test.removeAt(index);
    notifyListeners();
  }
  }
