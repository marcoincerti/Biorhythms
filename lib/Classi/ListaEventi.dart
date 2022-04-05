import 'package:flutter/cupertino.dart';

class ListaEventi {
  final String wikipedia;
  final String date;
  final List<Evento> events;

  ListaEventi({
    @required this.wikipedia,
    @required this.date,
    @required this.events,
  });

  factory ListaEventi.fromJson(Map<String, dynamic> json) {
    var list = json['events'] as List;
    List<Evento> itemsList = list.map((i) => Evento.fromJson(i)).toList();

    return ListaEventi(
      wikipedia: json['wikipedia'],
      date: json['date'],
      events: itemsList,
    );
  }
}

class Compleanni {
  final String wikipedia;
  final String date;
  final List<Evento> births;

  Compleanni({
    @required this.wikipedia,
    @required this.date,
    @required this.births,
  });

  factory Compleanni.fromJson(Map<String, dynamic> json) {
    var list = json['births'] as List;
    List<Evento> itemsList = list.map((i) => Evento.fromJson(i)).toList();

    return Compleanni(
      wikipedia: json['wikipedia'],
      date: json['date'],
      births: itemsList,
    );
  }
}

class Morti {
  final String wikipedia;
  final String date;
  final List<Evento> deaths;

  Morti({
    @required this.wikipedia,
    @required this.date,
    @required this.deaths,
  });

  factory Morti.fromJson(Map<String, dynamic> json) {
    var list = json['deaths'] as List;
    List<Evento> itemsList = list.map((i) => Evento.fromJson(i)).toList();

    return Morti(
      wikipedia: json['wikipedia'],
      date: json['date'],
      deaths: itemsList,
    );
  }
}

class Evento {
  final String year;
  final String description;
  final List<Wiki> wikipedia;

  Evento({
    @required this.year,
    @required this.description,
    @required this.wikipedia,
  });

  factory Evento.fromJson(Map<String, dynamic> json) {
    var list = json['wikipedia'] as List;
    List<Wiki> itemsList = list.map((i) => Wiki.fromJson(i)).toList();

    return Evento(
      year: json['year'],
      description: json['description'],
      wikipedia: itemsList,
    );
  }
}

class Wiki {
  final String title;
  final String wikipedia;

  Wiki({
    @required this.title,
    @required this.wikipedia,
  });

  factory Wiki.fromJson(Map<String, dynamic> json) {
    return Wiki(
      title: json['title'],
      wikipedia: json['wikipedia'],
    );
  }
}
