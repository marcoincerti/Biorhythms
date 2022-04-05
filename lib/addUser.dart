import 'dart:convert';

import 'package:biorhythms/Classi/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:progress_button/progress_button.dart';
import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';
import 'Classi/SharedPref.dart';
import 'Classi/ad_helper.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController dateCtl = TextEditingController();
  TextEditingController name = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime date = DateTime(1900);
  ButtonState button = ButtonState.normal;
  SharedPref sharedPref = SharedPref();

  // TODO: Add _bannerAd
  BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  @override
  void initState() {
    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAddUserAdUnitId,
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
    // TODO: Dispose a BannerAd object
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 219, 183, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(236, 199, 149, 1.0),
        title: Text("Add User"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Stack(
            children: [
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                        color:
                            Color.fromRGBO(182, 154, 129, 0.33725490196078434),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Ready to discover your perfect day?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Your name',
                            ),
                            validator: (value) {
                              if (value == "Your name" || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: dateCtl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Your birthday date',
                            ),
                            validator: (value) {
                              if (date.compareTo(DateTime.now()) >= 0 ||
                                  date.compareTo(
                                          DateTime(1900, 01, 01, 00, 00, 00)) ==
                                      0) {
                                return 'Please enter valid date';
                              }
                              return null;
                            },
                            onTap: () async {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              if (Platform.isIOS) {
                                await showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                          height: 500,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 400,
                                                child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .date,
                                                    initialDateTime:
                                                        DateTime.now(),
                                                    onDateTimeChanged: (val) {
                                                      setState(() {
                                                        date = val;
                                                      });
                                                    }),
                                              ),
                                              // Close the modal
                                              CupertinoButton(
                                                child: Text('OK'),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              )
                                            ],
                                          ),
                                        ));
                              } else {
                                date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                              }

                              var myFormat = DateFormat('d/MM/yyyy');
                              dateCtl.text = ('${myFormat.format(date)}');
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 180,
                            margin: const EdgeInsets.only(top: 20),
                            child: ProgressButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.fiber_new_rounded,
                                    color: Colors.green,
                                    size: 24.0,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() async {
                                    button = ButtonState.inProgress;
                                    User newuser = User(
                                        name: name.text,
                                        date: date,
                                        segnoZod: getZodicaSign(date));
                                    String key = await _read();
                                    _save(key, newuser);
                                    button = ButtonState.normal;
                                    sharedPref.save("selezionato", newuser);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => Home(user: newuser)),
                                          (Route<dynamic> route) => false,);
                                  });
                                }
                              },
                              buttonState: button,
                              backgroundColor: Color.fromRGBO(
                                  182, 154, 129, 0.33725490196078434),
                              progressColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _read() async {
    final prefs = await SharedPreferences.getInstance();
    Set key = prefs.getKeys();
    String lastValore;
    key.isEmpty ? lastValore = "0" : lastValore = key.last;
    int appoggio = int.parse(lastValore) + 1;
    return appoggio.toString();
  }

  Future _save(String key, User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(user));
  }

  String getZodicaSign(DateTime date) {
    var days = date.day;
    var months = date.month;
    if (months == 1) {
      if (days >= 21) {
        return "Aquarius";
      } else {
        return "Capricorn";
      }
    } else if (months == 2) {
      if (days >= 20) {
        return "Picis";
      } else {
        return "Aquarius";
      }
    } else if (months == 3) {
      if (days >= 21) {
        return "Aries";
      } else {
        return "Pisces";
      }
    } else if (months == 4) {
      if (days >= 21) {
        return "Taurus";
      } else {
        return "Aries";
      }
    } else if (months == 5) {
      if (days >= 22) {
        return "Gemini";
      } else {
        return "Taurus";
      }
    } else if (months == 6) {
      if (days >= 22) {
        return "Cancer";
      } else {
        return "Gemini";
      }
    } else if (months == 7) {
      if (days >= 23) {
        return "Leo";
      } else {
        return "Cancer";
      }
    } else if (months == 8) {
      if (days >= 23) {
        return "Virgo";
      } else {
        return "Leo";
      }
    } else if (months == 9) {
      if (days >= 24) {
        return "Libra";
      } else {
        return "Virgo";
      }
    } else if (months == 10) {
      if (days >= 24) {
        return "Scorpio";
      } else {
        return "Libra";
      }
    } else if (months == 11) {
      if (days >= 23) {
        return "Sagittarius";
      } else {
        return "Scorpio";
      }
    } else if (months == 12) {
      if (days >= 22) {
        return "Capricorn";
      } else {
        return "Sagittarius";
      }
    }
    return "";
  }
}
