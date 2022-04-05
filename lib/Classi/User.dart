import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

class User{
  String name;
  DateTime date;
  String segnoZod;

  User({
    @required this.name,
    @required this.date,
    @required this.segnoZod
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        date = DateTime.parse(json['date']),
        segnoZod = json['segno'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date.toString(),
    'segno': segnoZod,
  };

  int calculateAge() {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - this.date.year;
    int month1 = currentDate.month;
    int month2 = this.date.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = this.date.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  int daysBetween(DateTime to) {
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(this.date).inHours / 24).round();
  }

  double punteggioFisico(DateTime data){
    int giorni = daysBetween(data);
    double ris = sin((2*pi*giorni)/23);

    ris > 0 ? ris=ris+1 :  ris=1+ris;

    return double.parse(((ris*10)/2).toStringAsFixed(1));

  }

  double punteggioIntellettuale(DateTime data){
    int giorni = daysBetween(data);
    double ris = sin((2*pi*giorni)/33);

    ris > 0 ? ris=ris+1 :  ris=1+ris;

    return double.parse(((ris*10)/2).toStringAsFixed(1));

  }

  double punteggioEmotivo(DateTime data){
    int giorni = daysBetween(data);
    double ris = sin((2*pi*giorni)/28);

    ris > 0 ? ris=ris+1 :  ris=1+ris;

    return double.parse(((ris*10)/2).toStringAsFixed(1));

  }

  double returnFisico(int ris, DateTime data){
    int giorni = daysBetween(data);
    switch (ris) {
      case 1:
        int ciao = giorni-3;
        return double.parse(((sin((2*pi*ciao)/23)).toStringAsFixed(2)));
      case 2:
        int ciao = giorni-2;
        return double.parse(((sin((2*pi*ciao)/23)).toStringAsFixed(2)));
      case 3:
        int ciao = giorni-1;
        return double.parse(((sin((2*pi*ciao)/23)).toStringAsFixed(2)));
      case 4:
        return double.parse(((sin((2*pi*giorni)/23)).toStringAsFixed(2)));
      case 5:
        int ciao = giorni+1;
        return double.parse(((sin((2*pi*ciao)/23)).toStringAsFixed(2)));
      case 6:
        int ciao = giorni+2;
        return double.parse(((sin((2*pi*ciao)/23)).toStringAsFixed(2)));
      case 7:
        int ciao = giorni+3;
        return double.parse(((sin((2*pi*ciao)/23)).toStringAsFixed(2)));
    }
  }
  double returnEmotivo(int ris, DateTime data){
    int giorni = daysBetween(data);
    switch (ris) {
      case 1:
        int ciao = giorni-3;
        return double.parse(((sin((2*pi*ciao)/28)).toStringAsFixed(2)));
      case 2:
        int ciao = giorni-2;
        return double.parse(((sin((2*pi*ciao)/28)).toStringAsFixed(2)));
      case 3:
        int ciao = giorni-1;
        return double.parse(((sin((2*pi*ciao)/28)).toStringAsFixed(2)));
      case 4:
        return double.parse(((sin((2*pi*giorni)/28)).toStringAsFixed(2)));
      case 5:
        int ciao = giorni+1;
        return double.parse(((sin((2*pi*ciao)/28)).toStringAsFixed(2)));
      case 6:
        int ciao = giorni+2;
        return double.parse(((sin((2*pi*ciao)/28)).toStringAsFixed(2)));
      case 7:
        int ciao = giorni+3;
        return double.parse(((sin((2*pi*ciao)/28)).toStringAsFixed(2)));
    }

  }
  double returnIntellettuale(int ris, DateTime data){
    int giorni = daysBetween(data);
    switch (ris) {
      case 1:
        int ciao = giorni-3;
        return double.parse(((sin((2*pi*ciao)/33)).toStringAsFixed(2)));
      case 2:
        int ciao = giorni-2;
        return double.parse(((sin((2*pi*ciao)/33)).toStringAsFixed(2)));
      case 3:
        int ciao = giorni-1;
        return double.parse(((sin((2*pi*ciao)/33)).toStringAsFixed(2)));
      case 4:
        return double.parse(((sin((2*pi*giorni)/33)).toStringAsFixed(2)));
      case 5:
        int ciao = giorni+1;
        return double.parse(((sin((2*pi*ciao)/33)).toStringAsFixed(2)));
      case 6:
        int ciao = giorni+2;
        return double.parse(((sin((2*pi*ciao)/33)).toStringAsFixed(2)));
      case 7:
        int ciao = giorni+3;
        return double.parse(((sin((2*pi*ciao)/33)).toStringAsFixed(2)));
    }
  }

  List<FlSpot> returnFisicoMese(DateTime data){
    List<FlSpot> spots = [];
    int giorni = daysBetween(data);
    giorni= giorni-15;

    for (double i=1; i<=30; i++){
      int ciao = giorni+i.toInt();
      FlSpot spot = FlSpot(i, double.parse(((sin((2*pi*ciao)/23)).toStringAsFixed(2))));
      spots.add(spot);
    }
    return spots;
  }
  List<FlSpot> returnEmotivoMese(DateTime data){
    List<FlSpot> spots = [];
    int giorni = daysBetween(data);
    giorni= giorni-15;

    for (double i=1; i<=30; i++){
      int ciao = giorni+i.toInt();
      FlSpot spot = FlSpot(i, double.parse(((sin((2*pi*ciao)/28)).toStringAsFixed(2))));
      spots.add(spot);
    }
    return spots;
  }
  List<FlSpot> returnIntellettualeMese(DateTime data){
    List<FlSpot> spots = [];
    int giorni = daysBetween(data);
    giorni= giorni-15;

    for (double i=1; i<=30; i++){
      int ciao = giorni+i.toInt();
      FlSpot spot = FlSpot(i, double.parse(((sin((2*pi*ciao)/33)).toStringAsFixed(2))));
      spots.add(spot);
    }
    return spots;
  }

}