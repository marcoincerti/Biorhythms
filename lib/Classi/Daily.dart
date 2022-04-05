import 'package:flutter/cupertino.dart';

class Daily {
  final String text;
  final bool found;
  final int year;

  Daily({
    @required this.text,
    @required this.found,
    @required this.year,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      text: json['text'],
      found: json['found'],
      year: json['year'],
    );
  }
}
