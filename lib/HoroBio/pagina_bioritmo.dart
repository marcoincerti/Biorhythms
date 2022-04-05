import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


import '../Classi/User.dart';
import '../Classi/ad_helper.dart';

class paginaBioritmo extends StatefulWidget {
  const paginaBioritmo({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _paginaBioritmoState createState() => _paginaBioritmoState();
}

class _paginaBioritmoState extends State<paginaBioritmo> {
  BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  Locale defaultLocale;
  DateTime currentDate;
  DateTime _focusDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    currentDate = DateTime.now();
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerBioritmoAdUnitId,
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
    defaultLocale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 219, 183, 1.0),
      appBar: AppBar(
        actions: <Widget>[],
        backgroundColor: Color.fromRGBO(236, 199, 149, 1.0),
        title: Text("Biorhythm"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2040, 3, 14),
                        focusedDay: _focusDate,
                        selectedDayPredicate: (day) {
                          return isSameDay(currentDate, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            currentDate = selectedDay;
                            _focusDate = focusedDay;
                          });
                        },
                        locale: '${defaultLocale}',
                        calendarFormat: _calendarFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(182, 154, 129, 0.33725490196078434),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              currentDate.day == DateTime.now().day ? "TODAY" : "${currentDate.day} ${DateFormat.MMMM().format(currentDate)}",
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
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${widget.user.punteggioFisico(currentDate)}",
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
                                          "${widget.user.punteggioEmotivo(currentDate)}",
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
                                          "${widget.user.punteggioIntellettuale(currentDate)}",
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xfffc4c4c),
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
                                "Physical",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xfffae181),
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
                                "Emotional",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 20),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xff4af699),
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
                                "Intellectual",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AspectRatio(
                        aspectRatio: 1.23,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff6bb1fa),
                                Color(0xffA8D1FC),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'THIS WEEK',
                                    style: TextStyle(
                                      color: Color(0xff827daa),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                                      child: LineChart(
                                        sampleData1(),
                                        swapAnimationDuration: const Duration(milliseconds: 250),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 1.23,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff6bb1fa),
                                Color(0xffA8D1FC),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'THIS MONTH',
                                    style: TextStyle(
                                      color: Color(0xff827daa),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                                      child: LineChart(
                                        sampleData2(),
                                        swapAnimationDuration: const Duration(milliseconds: 250),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ]),
                  ),
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

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '-3';
              case 2:
                return '-2';
              case 3:
                return '-1';
              case 4:
                return 'today';
              case 5:
                return '+1';
              case 6:
                return '+2';
              case 7:
                return '+3';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return ':)';
              case -1:
                return ':(';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 8,
      maxY: 1.5,
      minY: -2,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, widget.user.returnIntellettuale(1, currentDate)),
        FlSpot(2, widget.user.returnIntellettuale(2, currentDate)),
        FlSpot(3, widget.user.returnIntellettuale(3, currentDate)),
        FlSpot(4, widget.user.returnIntellettuale(4, currentDate)),
        FlSpot(5, widget.user.returnIntellettuale(5, currentDate)),
        FlSpot(6, widget.user.returnIntellettuale(6, currentDate)),
        FlSpot(7, widget.user.returnIntellettuale(7, currentDate)),
      ],
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(1, widget.user.returnFisico(1, currentDate)),
        FlSpot(2, widget.user.returnFisico(2, currentDate)),
        FlSpot(3, widget.user.returnFisico(3, currentDate)),
        FlSpot(4, widget.user.returnFisico(4, currentDate)),
        FlSpot(5, widget.user.returnFisico(5, currentDate)),
        FlSpot(6, widget.user.returnFisico(6, currentDate)),
        FlSpot(7, widget.user.returnFisico(7, currentDate)),
      ],
      isCurved: true,
      colors: [
        const Color(0xfffc4c4c),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final lineChartBarData3 = LineChartBarData(
      spots: [
        FlSpot(1, widget.user.returnEmotivo(1, currentDate)),
        FlSpot(2, widget.user.returnEmotivo(2, currentDate)),
        FlSpot(3, widget.user.returnEmotivo(3, currentDate)),
        FlSpot(4, widget.user.returnEmotivo(4, currentDate)),
        FlSpot(5, widget.user.returnEmotivo(5, currentDate)),
        FlSpot(6, widget.user.returnEmotivo(6, currentDate)),
        FlSpot(7, widget.user.returnEmotivo(7, currentDate)),
      ],
      isCurved: true,
      colors: const [
        Color(0xfffae181),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '-15';
              case 5:
                return '-10';
              case 10:
                return '-5';
              case 15:
                return 'today';
              case 20:
                return '+5';
              case 25:
                return '+10';
              case 29:
                return '+15';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return ':)';
              case -1:
                return ':(';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 30,
      maxY: 1.5,
      minY: -2,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    final lineChartBarData1 = LineChartBarData(
      spots: widget.user.returnIntellettualeMese(currentDate),
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final lineChartBarData2 = LineChartBarData(
      spots: widget.user.returnFisicoMese(currentDate),
      isCurved: true,
      colors: [
        const Color(0xfffc4c4c),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final lineChartBarData3 = LineChartBarData(
      spots: widget.user.returnEmotivoMese(currentDate),
      isCurved: true,
      colors: const [
        Color(0xfffae181),
      ],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
      lineChartBarData2,
      lineChartBarData3,
    ];
  }
}
