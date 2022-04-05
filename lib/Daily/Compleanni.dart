import 'dart:convert';

import 'package:biorhythms/Classi/ListaEventi.dart';
import 'package:biorhythms/Classi/User.dart';
import 'package:biorhythms/Classi/ad_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CompleanniList extends StatefulWidget {
  const CompleanniList({Key key, this.user, this.pagina}) : super(key: key);
  final User user;
  final int pagina;

  @override
  _CompleanniListState createState() => _CompleanniListState();
}

class _CompleanniListState extends State<CompleanniList> {

  BannerAd _bannerAd;
  bool _isBannerAdReady = false;

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
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 219, 183, 1.0),
      appBar: AppBar(
        actions: <Widget>[],
        backgroundColor: Color.fromRGBO(236, 199, 149, 1.0),
        title: Text(widget.pagina == 0 ? "Birthday List": "Deaths List"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.pagina == 0 ? 'Your day of birth is important, find out who the other people worthy of being remembered are born today' :
                      "List of people who have positively or negatively influenced our days",
                      maxLines: 10,
                      style: GoogleFonts.fredokaOne(
                        textStyle: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 18,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Flexible(child: Container(color: Colors.white,)),
                        Flexible(child: Container(color: Colors.white,)),
                      ],
                    )
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: widget.pagina == 0 ? fetchListDaily() : fetchListDeaths(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError)
                              return Center(child: Text('Error: ${snapshot.error}'));
                            else {
                              var reversedList;
                              if(widget.pagina == 0)
                                reversedList = new List.from(snapshot.data.births.reversed);
                              else
                                reversedList = new List.from(snapshot.data.deaths.reversed);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: reversedList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () => {
                                                launch(reversedList[index].wikipedia[0].wikipedia)
                                            },
                                            child: Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    padding: EdgeInsets.all(3.0),
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: Colors.lightBlue,
                                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Center(
                                                      child: Text(
                                                        "${reversedList[index].year}",
                                                        style:
                                                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "${reversedList[index].description}",
                                                        maxLines: 4,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      );
                                    }),
                              );
                            }
                        }
                      }),
                  SizedBox(
                    height: 40,
                  ),
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

  Future<Compleanni> fetchListDaily() async {
    final response = await http.get(Uri.parse('https://byabbe.se/on-this-day/${widget.user.date.month}/${widget.user.date.day}/births.json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Compleanni.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Horoscope');
    }
  }

  Future<Morti> fetchListDeaths() async {
    DateTime date = DateTime.now();
    final response = await http.get(Uri.parse('https://byabbe.se/on-this-day/${date.month}/${date.day}/deaths.json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Morti.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Horoscope');
    }
  }
}
