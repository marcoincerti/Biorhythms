import 'package:flutter/cupertino.dart';

class Horoscope {
  final String color;
  final String compatibility;
  final String description;
  final String lucky_number;
  final String lucky_time;
  final String mood;

  Horoscope({
    @required this.color,
    @required this.compatibility,
    @required this.description,
    @required this.lucky_number,
    @required this.lucky_time,
    @required this.mood,
  });

  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      color: json['color'],
      compatibility: json['compatibility'],
      description: json['description'],
      lucky_number: json['lucky_number'],
      lucky_time: json['lucky_time'],
      mood: json['mood'],
    );
  }
}
