import 'dart:convert';
import 'dart:io';

import 'package:biorhythms/HoroBio/pagina_bioritmo.dart';
import 'package:biorhythms/HoroBio/pagina_oroscopo.dart';
import 'package:biorhythms/Daily/randomEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Classi/Horoscope.dart';
import 'Classi/SharedPref.dart';
import 'Classi/User.dart';
import 'Classi/ad_helper.dart';
import 'Daily/Compleanni.dart';
import 'Daily/ListEventDaily.dart';
import 'main.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPref sharedPref = SharedPref();
  int segmentedControlGroupValue = 0;

  final InAppReview _inAppReview = InAppReview.instance;
  bool _isAvailable;

  BannerAd _bannerAd;

  bool _isBannerAdReady = false;

  static const _url = "https://en.wikipedia.org/wiki/Biorhythm_(pseudoscience)";

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Your day"),
    1: Text("Daily facts"),
  };

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inAppReview
          .isAvailable()
          .then(
            (bool isAvailable) => setState(
              () => _isAvailable = isAvailable && !Platform.isAndroid,
            ),
          )
          .catchError((_) => setState(() => _isAvailable = false));
    });

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

  void _launchURL() async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  Future<void> _requestReview() => _inAppReview.requestReview();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 219, 183, 1.0),
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              sharedPref.remove("selezionato");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Text(
              "Exit",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
        backgroundColor: Color.fromRGBO(236, 199, 149, 1.0),
        title: Text("${widget.user.name}"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: CupertinoSlidingSegmentedControl(
                      groupValue: segmentedControlGroupValue,
                      children: myTabs,
                      onValueChanged: (i) {
                        setState(
                          () {
                            segmentedControlGroupValue = i;
                          },
                        );
                      },
                    ),
                  ),
                  if (segmentedControlGroupValue == 0) biopage(),
                  if (segmentedControlGroupValue == 1) dailyFact(),
                  //segmentedControlGroupValue == 0 ? biopage() : oroscopopage(),
                  SizedBox(
                    height: 30,
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

  Widget biopage() {
    return Column(children: [
      Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Text(
                "Days lived: ${widget.user.daysBetween(DateTime.now())} :)",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Text(
                "${widget.user.segnoZod}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(182, 154, 129, 0.33725490196078434),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Text(
              "TODAY",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              "(min 0 - max 10)",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${widget.user.punteggioFisico(DateTime.now())}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Physical"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${widget.user.punteggioEmotivo(DateTime.now())}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Emotional"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${widget.user.punteggioIntellettuale(DateTime.now())}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Intellectual"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                elevation: MaterialStateProperty.all<double>(4.0),
              ),
              onPressed: () {
                _launchURL();
              },
              child: Text('What are biorhythms?'),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
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
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 170, 207, 0.49411764705882355),
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "Horoscope compatibility:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(oroscopo.compatibility,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]);
                }
            }
          }),
      SizedBox(
        height: 10,
      ),
      Container(
        margin: EdgeInsets.all(15),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(8.0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              ))),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => paginaBioritmo(
                        user: widget.user,
                      )),
            );
          },
          child: Container(
            padding: EdgeInsets.all(5),
            height: 125,
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Check your Biorhythms',
                    style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.blue,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.all(15),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(8.0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              ))),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => pageOroscopo(
                        user: widget.user,
                      )),
            );
          },
          child: Container(
            padding: EdgeInsets.all(5),
            height: 125,
            decoration: BoxDecoration(
                //image: DecorationImage(image: AssetImage("assets/char.png"), fit: BoxFit.fill),
                ),
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Your Daily Horoscope',
                    style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.green,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
            elevation: MaterialStateProperty.all<double>(4.0),
          ),
          onPressed: _requestReview,
          child: Text("✨ Help us to better by leaving a review ❤️")),
      SizedBox(
        height: 40,
      )
    ]);
  }

  Widget dailyFact() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Whats happened?',
          style: GoogleFonts.fredokaOne(
              textStyle: TextStyle(color: Colors.deepOrange, fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListEvent(
                          )),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.view_list_rounded,
                          color: Colors.lightGreen,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "List on this day",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RandomEventDaily()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.whatshot_rounded,
                          color: Colors.red,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Random event on this day",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompleanniList(user: widget.user,pagina: 0,)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_sharp,
                          color: Colors.lightBlue,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Find out who was born on your own day",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompleanniList(user: widget.user,pagina: 1,)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.black,
                          size: 40,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "People worthy of being remembered",
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        /*Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => paginaBioritmo(
                                user: widget.user,
                              )),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.whatshot_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Birth on this",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "day",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      elevation: MaterialStateProperty.all<double>(8.0),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => paginaBioritmo(
                                user: widget.user,
                              )),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wb_sunny,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Death on this",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "day",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),*/
      ],
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
