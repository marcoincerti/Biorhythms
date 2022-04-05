import 'dart:convert';

import 'package:biorhythms/Classi/ListaEventi.dart';
import 'package:biorhythms/Classi/ad_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ListEvent extends StatefulWidget {
  const ListEvent({Key key}) : super(key: key);

  @override
  _ListEventState createState() => _ListEventState();
}

class _ListEventState extends State<ListEvent> {
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
        title: Text("Event List"),
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
                      'Chronological list of events that happened today in the past',
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
                  FutureBuilder(
                      future: fetchListDaily(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError)
                              return Center(child: Text('Error: ${snapshot.error}'));
                            else {
                              ListaEventi lista = snapshot.data;
                              var reversedList = new List.from(lista.events.reversed);
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
                                          Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.all(8.0),
                                                  padding: EdgeInsets.all(3.0),
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.lightBlue,
                                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                                  child: Center(
                                                    child: Text(
                                                      "${reversedList[index].year}",
                                                      style:
                                                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${reversedList[index].description}",
                                                    maxLines: 10,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Wrap(
                                                    spacing: 3.0,
                                                    runSpacing: 0.0,
                                                    children:
                                                        List<Widget>.generate(reversedList[index].wikipedia.length,
                                                            // place the length of the array here
                                                            (int index2) {
                                                      String text = reversedList[index].wikipedia[index2].title;
                                                      return ActionChip(
                                                        elevation: 3.0,
                                                        label: Text(
                                                          text.length < 20 ? text : truncateWithEllipsis(20, text),
                                                          style: TextStyle(fontSize: 12),
                                                        ),
                                                        onPressed: () async {
                                                          await canLaunch(
                                                                  reversedList[index].wikipedia[index2].wikipedia)
                                                              ? await launch(
                                                                  reversedList[index].wikipedia[index2].wikipedia)
                                                              : throw 'Could not launch ${reversedList[index].wikipedia[index2].wikipedia}';
                                                        },
                                                        backgroundColor: Colors.white,
                                                        shape: StadiumBorder(
                                                          side: BorderSide(
                                                            width: 2,
                                                            color: Colors.orangeAccent,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                )
                                              ],
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

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
  }

  Future<ListaEventi> fetchListDaily() async {
    DateTime date = DateTime.now();

    final response = await http.get(Uri.parse('https://byabbe.se/on-this-day/${date.month}/${date.day}/events.json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return ListaEventi.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Horoscope');
    }
  }
}
