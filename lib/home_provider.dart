import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model.dart';

class HomeProvider extends ChangeNotifier {
  GroceryData? data;
  List<Product> filteredList = [];

  String language = 'english';

  void changeLanguage(String lang) {
    language = lang;
    notifyListeners();
  }

  Future<void> jsonParsing() async {
    String json = await rootBundle.loadString('assets/json/temp.json');
    final geeta = jsonDecode(json);
    data = GroceryData.fromJson(geeta);
    switch (language) {
      case "english":
        filteredList = data!.english;
        break;
      case "hindi":
        filteredList = data!.hindi;
        break;
      case "gujarati":
        filteredList = data!.gujarati;
        break;
    }

    notifyListeners();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      switch (language) {
        case "english":
          filteredList = data!.english;
          break;
        case "hindi":
          filteredList = data!.hindi;
          break;
        case "gujarati":
          filteredList = data!.gujarati;
          break;
      }
    } else {
      switch (language) {
        case "english":
          filteredList =
              data!.english.where((item) {
                return item.tags.any(
                  (tag) => tag.toLowerCase().contains(query.toLowerCase()),
                );
              }).toList();
          break;
        case "hindi":
          filteredList =
              data!.hindi.where((item) {
                return item.tags.any(
                  (tag) => tag.toLowerCase().contains(query.toLowerCase()),
                );
              }).toList();
          break;
        case "gujarati":
          filteredList =
              data!.gujarati.where((item) {
                return item.tags.any(
                  (tag) => tag.toLowerCase().contains(query.toLowerCase()),
                );
              }).toList();
          break;
      }
    }
    notifyListeners();
  }
}
