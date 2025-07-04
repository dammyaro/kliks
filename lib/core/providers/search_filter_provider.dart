import 'package:flutter/material.dart';
import 'package:kliks/features/main_app/search/filter_options.dart';

class SearchFilterProvider with ChangeNotifier {
  FilterOptions _filterOptions = FilterOptions();

  FilterOptions get filterOptions => _filterOptions;

  void updateFilters(FilterOptions newOptions) {
    _filterOptions = newOptions;
    notifyListeners();
  }

  void clearFilters() {
    _filterOptions = FilterOptions();
    notifyListeners();
  }
}
