import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

import '../Classi/Daily.dart';
import '../Classi/ad_helper.dart';

class RandomEventDaily extends StatefulWidget {
  const RandomEventDaily({Key key}) : super(key: key);

  @override
  _RandomEventDailyState createState() => _RandomEventDailyState();
}

class _RandomEventDailyState extends State<RandomEventDaily> {

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  DateTime dateof = DateTime.now();
  DateFormat formatter = DateFormat('dd MMMM yyyy');
  final translator = GoogleTranslator();
  bool trad_oroscopo = true;
  bool trad_daily = true;
  String prova;
  String defaultLocale;

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {_bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    prova = Platform.localeName;
    defaultLocale = prova.substring(0, 2);
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 219, 183, 1.0),
      appBar: AppBar(
        actions: <Widget>[],
        backgroundColor: Color.fromRGBO(236, 199, 149, 1.0),
        title: Text("Random Event"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  FutureBuilder(
                      future: fetchDaily(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError)
                              return Center(child: Text('Error: ${snapshot.error}'));
                            else {
                              Daily daily = snapshot.data;
                              String formatted = formatter.format(dateof);
                              return Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20, right: 20),
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          formatted,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 20, right: 20),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(182, 154, 129, 0.33725490196078434),
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "What happened:",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            FutureBuilder(
                                              future: translator.translate(daily.text, to: '${defaultLocale}'),
                                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                                switch (snapshot.connectionState) {
                                                  case ConnectionState.waiting:
                                                    return Center(child: CircularProgressIndicator());
                                                  default:
                                                    if (snapshot.hasError)
                                                      return Center(child: Text('Error: ${snapshot.error}'));
                                                    else {
                                                      var daily = snapshot.data;
                                                      return Text(trad_daily ? daily.text.toString() : daily.source.toString(),
                                                          textAlign: TextAlign.center, style: TextStyle(fontSize: 20));
                                                    }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 20, right: 5),
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(182, 154, 129, 0.33725490196078434),
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "In the year:",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(daily.year.toString(),
                                                  textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 5, right: 20),
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(182, 154, 129, 0.33725490196078434),
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Has been verified?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(daily.found ? "True" : "False",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 18, color: daily.found ? Colors.green : Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                    elevation: MaterialStateProperty.all<double>(6.0),
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: Text('New cips of knowledge'),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ]);
                            }
                        }
                      }),
                ],
              ),
            ),
            if (_isBannerAdReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<Daily> fetchDaily() async {
    DateTime date = DateTime.now();
    const _api_key = "ef846cd2bfmshb45f9921920d395p1ad840jsn353a6ac9ba2e";
    // Base API url
    const String _baseUrl = "numbersapi.p.rapidapi.com";
    // Base headers for Response url
    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-host": _baseUrl,
      "x-rapidapi-key": _api_key,
    };
    final queryParameters = {
      'json': 'true',
      'fragment': 'true',
    };

    final response =
    await http.get(Uri.https(_baseUrl, "/${date.month}/${date.day}/date", queryParameters), headers: _headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Daily.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Horoscope');
    }
  }
}
