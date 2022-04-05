import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

import '../Classi/Horoscope.dart';
import '../Classi/User.dart';
import '../Classi/ad_helper.dart';

class pageOroscopo extends StatefulWidget {
  const pageOroscopo({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _pageOroscopoState createState() => _pageOroscopoState();
}

class _pageOroscopoState extends State<pageOroscopo> {

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  final translator = GoogleTranslator();
  bool trad_oroscopo = true;
  String prova;
  String defaultLocale;

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerHoroscopeAdUnitId,
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
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    prova = Platform.localeName;
    defaultLocale = prova.substring(0, 2);
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 219, 183, 1.0),
      appBar: AppBar(
        actions: <Widget>[
        ],
        backgroundColor: Color.fromRGBO(236, 199, 149, 1.0),
        title: Text("Horoscope"),

      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text(
                    'Will it be a good day?',
                    style: GoogleFonts.fredokaOne(
                        textStyle: TextStyle(color: Colors.deepOrange, fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 15,),
                  FutureBuilder(
                      future: fetchHoroscope(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError)
                              return Center(child: Text('Error: ${snapshot.error}'));
                            else {
                              Horoscope oroscopo = snapshot.data;
                              return Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20, right: 20),
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "${widget.user.segnoZod}",
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
                                Container(
                                  margin: const EdgeInsets.only(top: 5, bottom: 10, left: 25, right: 25),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Daily Horoscope:",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      FutureBuilder(
                                        future: translator.translate(oroscopo.description, to: '${defaultLocale}'),
                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return Center(child: CircularProgressIndicator());
                                            default:
                                              if (snapshot.hasError)
                                                return Center(child: Text('Error: ${snapshot.error}'));
                                              else {
                                                var oroscopo = snapshot.data;
                                                return Text(trad_oroscopo ? oroscopo.text.toString() : oroscopo.source.toString(),
                                                    textAlign: TextAlign.center, style: TextStyle(fontSize: 18));
                                              }
                                          }
                                        },
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                                          elevation: MaterialStateProperty.all<double>(4.0),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            trad_oroscopo ? trad_oroscopo = false : trad_oroscopo = true;
                                          });
                                        },
                                        child: Text(trad_oroscopo ? 'Without translation' : "With translation"),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
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
                                                "Mood:",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(oroscopo.mood, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
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
                                                "Color of the day:",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(oroscopo.color, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
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
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 20, right: 5),
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(147, 201, 142, 0.49411764705882355),
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Lucky number:",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(oroscopo.lucky_number,
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
                                            color: Color.fromRGBO(147, 201, 142, 0.49411764705882355),
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Lucky time:",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(oroscopo.lucky_time, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20, right: 20),
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(255, 170, 207, 0.49411764705882355),
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Compatibility:",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              oroscopo.compatibility,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 70,
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

  Future<Horoscope> fetchHoroscope() async {
    const _api_key = "ef846cd2bfmshb45f9921920d395p1ad840jsn353a6ac9ba2e";
    // Base API url
    const String _baseUrl = "sameer-kumar-aztro-v1.p.rapidapi.com";
    // Base headers for Response url
    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-host": _baseUrl,
      "x-rapidapi-key": _api_key,
    };

    final queryParameters = {
      'sign': '${widget.user.segnoZod}',
      'day': 'today',
    };

    final response = await http.post(Uri.https(_baseUrl, "", queryParameters), headers: _headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Horoscope.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Horoscope');
    }
  }

}
