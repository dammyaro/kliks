import 'package:flutter/material.dart';

class FilterOptions {
  final String? category;
  final double locationRange;
  final String ageGroup;
  final String guests;
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final DateTime? endDate;
  final TimeOfDay? endTime;

  FilterOptions({
    this.category,
    this.locationRange = 50,
    this.ageGroup = 'everyone',
    this.guests = 'anyone',
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
  });
}
