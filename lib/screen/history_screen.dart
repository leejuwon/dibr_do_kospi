import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import "package:flutter_dibr_do_kospi/ad_manager.dart";
import "package:flutter_dibr_do_kospi/screen/result_screen.dart";
import "package:flutter_dibr_do_kospi/screen/etfStockInfo_screen.dart";
import "package:flutter_dibr_do_kospi/main.dart";
import "package:flutter_dibr_do_kospi/model/model_market.dart";
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class DibrHistoryPage extends StatefulWidget {
  @override
  _DibrHistoryPageState createState() => _DibrHistoryPageState();
}

class _DibrHistoryPageState extends State<DibrHistoryPage> {
  Future<MarketInfo> futureHistMarketInfo;

  //DateTime now = DateTime.now();

  String _selectedDt = new DateFormat("yyyy-MM-dd").format(new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));

  //String _selectedDt = new DateFormat("yyyy-MM-dd").format(DateTime.now());

  bool _isHistRewardedAdReady;

  @override
  void initState() {
    super.initState();

    // TODO: Set Rewarded Ad event listener
    RewardedVideoAd.instance.listener = _onHistRewardedAdEvent;

    // TODO: Load a Rewarded Ad
    futureHistMarketInfo = fetchMarketHistInfo('Init');
  }

  // TODO: Implement _onRewardedAdEvent()
  void _onHistRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isHistRewardedAdReady = true;
        });
        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isHistRewardedAdReady = false;
        });
        RewardedVideoAd.instance.load(
          targetingInfo: MobileAdTargetingInfo(),
          adUnitId: AdManager.rewardedAdUnitId,
        );
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isHistRewardedAdReady = true;
          futureHistMarketInfo = fetchMarketHistInfo('Hist');
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        print('@@@@@rewarded!!!!');
        setState(() {
          futureHistMarketInfo = fetchMarketHistInfo('Hist');
        });
        break;
      default:
      // do nothing
    }
  }

  Color getColor(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }

    if (number >= 0) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  String getSelectStock(pTp1, pTp2, pTp3) {
    if (pTp3 == 1) {
      if (pTp1 == "R") {
        if (pTp2 == "N") {
          return "Leverage";
        } else {
          return "Inverse2X";
        }
      } else {
        if (pTp2 == "N") {
          return "Inverse2X";
        } else {
          return "Leverage";
        }
      }
    } else {
      if (pTp1 == "R") {
        if (pTp2 == "N") {
          return "Inverse2X";
        } else {
          return "Leverage";
        }
      } else {
        if (pTp2 == "N") {
          return "Leverage";
        } else {
          return "Inverse2X";
        }
      }
    }
  }

  IconData getIcon(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }

    if (number > 0) {
      return Icons.trending_up;
    } else if (number < 0) {
      return Icons.trending_down;
    } else {
      return null;
    }
  }

  IconData getUpDownIcon(number) {
    if (number == null || number == 'undefined') {
      number = 0;
    }
    if (number > 0) {
      return Icons.arrow_upward;
    } else if (number < 0) {
      return Icons.arrow_downward;
    } else {
      return null;
    }
  }

  Future<MarketInfo> fetchMarketHistInfo(pType) async {
    print('fetchMarketHistInfo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!pType: ' +
        pType);
    if (pType == 'Init') {
      print("1####################################~~~");
      return MarketInfo.fromInitJson();
    } else {
      final response = await http.get(Uri.encodeFull(
          'http://dibr.cafe24app.com/marketInfo/getMarketInfoHistDay/${_selectedDt}'));
      //headers: {"Accept": "application/json"});

      print(
          '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!_selectedDt: ' + _selectedDt);
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!pType: ' + pType);
      if (response.statusCode == 200) {
        Map dataJson = jsonDecode(response.body);
        print("1####################################");
        print(dataJson);
        print(dataJson[snpScore]);
        print("2####################################");
        //var marketInfo = ;
        return MarketInfo.fromJson(dataJson);
      } else {
        throw Exception('Failed to load MarketInfo');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;
    return Scaffold(
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          SizedBox(height: 10),
          Stack(
            children: <Widget>[
              Container(
                child: Image.asset(
                  'images/backgr2.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 80),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                      Widget>[
                    Container(
                      child: Image.asset(
                        'images/bg11.png',
                        height: 55,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                    ),
                    Container(
                      height: 55,
                      decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.white),
                            left: BorderSide(width: 1.0, color: Colors.white),
                            right: BorderSide(width: 1.0, color: Colors.white),
                            bottom: BorderSide(width: 1.0, color: Colors.white),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InkWell(
                              child: Text('$_selectedDt',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Future<DateTime> selectedDate = showDatePicker(
                                  context: context,
                                  initialDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  firstDate: new DateTime(2000, 1, 1),
                                  lastDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                        data: ThemeData.dark(), child: child);
                                  },
                                );

                                selectedDate.then((dateTime) {
                                  setState(() {
                                    var vDt = new DateFormat("yyyy-MM-dd")
                                        .format(dateTime);
                                    //_selectedTime = vDt;
                                    print('vDt:' + vDt);
                                    _selectedDt = vDt;
                                  });
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              tooltip: 'Tap to open date picker',
                              onPressed: () {
                                Future<DateTime> selectedDate = showDatePicker(
                                  context: context,
                                  initialDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  firstDate: new DateTime(2000, 1, 1),
                                  lastDate: new DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day - 1),
                                  builder:
                                      (BuildContext context, Widget child) {
                                    return Theme(
                                        data: ThemeData.dark(), child: child);
                                  },
                                );

                                selectedDate.then((dateTime) {
                                  setState(() {
                                    /*var vYear = dateTime.year;
                                    var vMonth = dateTime.month;
                                    var vDay = dateTime.day;*/

                                    //_selectedTime = dateTime;
                                    var vDt = new DateFormat("yyyy-MM-dd")
                                        .format(dateTime);
                                    print('vDt2: ' + vDt);
                                    _selectedDt = vDt;
                                  });
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
                height: 41,
                width: 240,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(' ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      fontStyle: FontStyle.normal,
                      backgroundColor: Colors.green,
                      letterSpacing: 2.0,
                    )),
                Text(' History 시장 정보 ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 2.0,
                        color: Colors.yellowAccent)),
              ]),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
              stream: futureHistMarketInfo.asStream(),

              builder: (BuildContext context, snapshot) {
                final marketInfo = snapshot.data;
                print('snapshot~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                print(snapshot);
                if (snapshot.hasData) {
                  print('snp~~~~~~~~~~~~~~~~~~~~~~~~~~~');
                  print(snapshot);
                  print('snp~~~~~~~~~~~~~~~~~~~~~~~~~~~');

                  return Container(
                    margin: EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Image.asset(
                                                              'images/usa.png',
                                                              height: 70,
                                                              width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.snpStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.snpEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .snpUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .snpUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.snpUdRateRealByClose}%[${snapshot.data.snpUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.snpUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,

                                                    children: <Widget>[
                                                      Text('S&P500 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .snpScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .snpScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.snpScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .snpScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              )],
                                              ))),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Image.asset(
                                                              'images/euro.png',
                                                              height: 70,
                                                              width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.eurStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.eurEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .eurUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .eurUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.eurUdRateRealByClose}%[${snapshot.data.eurUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.eurUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('EURO50 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .eurScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .eurScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.eurScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .eurScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              )],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Image.asset(
                                                              'images/oil_logo.png',
                                                              height: 70,
                                                              width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.wtiStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.wtiEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .wtiUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .wtiUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.wtiUdRateRealByClose}%[${snapshot.data.wtiUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.wtiUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('WTI 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .wtiScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .wtiScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.wtiScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .wtiScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              )],
                                              ))),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Image.asset(
                                                              'images/oil_logo.png',
                                                              height: 70,
                                                              width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.dubStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.dubEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .dubUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .dubUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.dubUdRateRealByClose}%[${snapshot.data.dubUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.dubUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('Dubai 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .dubScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .dubScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.dubScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .dubScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              )],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Image.asset(
                                                              'images/oil_logo.png',
                                                              height: 70,
                                                              width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.breStdPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.breEndPrice} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .breUdRateRealByClose),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .breUdRateRealByClose),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.breUdRateRealByClose}%[${snapshot.data.breUdPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.breUdRateRealByClose)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('Brent 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(
                                                                snapshot.data
                                                                    .breScore),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .breScore),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.breScore} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .breScore)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                              )],
                                              ))),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
                                    height: 130,
                                    width: 195,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3, top: 5),
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0,
                                                                right: 3.0),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Image.asset(
                                                              'images/excnew_logo.png',
                                                              height: 70,
                                                              width: 60),
                                                        ),
                                                      ),
                                                      Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text('기준가:',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.green)),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          Text(
                                                                        '${snapshot.data.bfStdRate} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text('종가:',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Colors.green)),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '${snapshot.data.tdOpRate} ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Icon(
                                                                        getUpDownIcon(snapshot
                                                                            .data
                                                                            .excDiffRate),
                                                                        size:
                                                                            14,
                                                                        color: getColor(snapshot
                                                                            .data
                                                                            .excDiffRate),
                                                                      ),
                                                                      Text(
                                                                        '${snapshot.data.excDiffRate}%[${snapshot.data.excDiffPrice}] ',
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                getColor(snapshot.data.excDiffRate)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ]),
                                                    ],
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5, right: 5),
                                                child:Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Text('환율 점수:',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: Colors
                                                                  .black87)),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            getUpDownIcon(snapshot
                                                                .data
                                                                .excScore1st),
                                                            size: 20,
                                                            color: getColor(
                                                                snapshot.data
                                                                    .excScore1st),
                                                          ),
                                                          Text(
                                                            '${snapshot.data.excScore1st} ',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: getColor(
                                                                    snapshot
                                                                        .data
                                                                        .excScore1st)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                              )],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.black,
                              height: 41,
                              width: 238,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.green,
                                        letterSpacing: 2.0,
                                      )),
                                  Text('    투자 점수[등급]   ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.yellowAccent)),
                                ]),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Table(
                            // columnWidths: ,
                            border: TableBorder(
                              bottom: BorderSide(
                                color: Colors.blueGrey,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              horizontalInside: BorderSide(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              left: BorderSide(
                                style: BorderStyle.none,
                              ),
                              right: BorderSide(
                                style: BorderStyle.none,
                              ),
                              top: BorderSide(
                                style: BorderStyle.none,
                              ),
                              verticalInside: BorderSide(
                                style: BorderStyle.none,
                              ),
                            ),
                            columnWidths: {
                              0: FractionColumnWidth(.5),
                              1: FractionColumnWidth(.5)
                            },
                            children: [
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('＄/￦환율 제외 전체',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('＄/￦환율',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                    ]),
                              ]),
                              TableRow(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.exRauTotScore),
                                        size: 35,
                                        color: getColor(
                                            snapshot.data.exRauTotScore),
                                      ),
                                      Text(
                                          '${snapshot.data.exRauTotScore}[${snapshot.data.exRauTotScoreGrade}] ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(snapshot
                                                  .data.exRauTotScore))),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        getIcon(snapshot.data.excScore1st),
                                        size: 35,
                                        color:
                                            getColor(snapshot.data.excScore1st),
                                      ),
                                      Text(
                                          //' $_excScore1st [$_excSetRngGrp]',
                                          '${snapshot.data.excScore1st}[${snapshot.data.excSetRngGrp}] ',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: getColor(
                                                  snapshot.data.excScore1st))),
                                    ]),
                              ]),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              color: Colors.black,
                              height: 41,
                              width: 235,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(' ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                        fontStyle: FontStyle.normal,
                                        backgroundColor: Colors.green,
                                        letterSpacing: 2.0,
                                      )),
                                  Text('        투자 추천       ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2.0,
                                          color: Colors.yellowAccent)),
                                ]),
                          ],
                        ),
                        SizedBox(height: 10),
                        Table(
                          // columnWidths: ,
                          border: TableBorder(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            horizontalInside: BorderSide(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            left: BorderSide(
                              style: BorderStyle.none,
                            ),
                            right: BorderSide(
                              style: BorderStyle.none,
                            ),
                            top: BorderSide(
                              style: BorderStyle.none,
                            ),
                            verticalInside: BorderSide(
                              style: BorderStyle.none,
                            ),
                          ),
                          columnWidths: {
                            0: FractionColumnWidth(.20),
                            1: FractionColumnWidth(.25),
                            2: FractionColumnWidth(.30),
                            3: FractionColumnWidth(.25)
                          },
                          children: [
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.priority_high,
                                      size: iconSize,
                                      color: Colors.blue,
                                    ),
                                    Text('매수순위',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.done,
                                      size: iconSize,
                                      color: Colors.redAccent,
                                    ),
                                    Text('선택종목',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.alarm_on,
                                      size: iconSize,
                                      color: Colors.redAccent,
                                    ),
                                    Text('매수예약(%)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.alarm_off,
                                      size: iconSize,
                                      color: Colors.blueAccent,
                                    ),
                                    Text('손절(%)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green)),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.looks_one,
                                      size: iconSize,
                                      color: Colors.redAccent,
                                    ),
                                    Text('순위')
                                  ]),
                              Text(
                                getSelectStock(snapshot.data.selectStock,
                                    snapshot.data.otType, 2),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.buyRate1st),
                                      size: 25,
                                      color: getColor(snapshot.data.buyRate1st),
                                    ),
                                    Text('${snapshot.data.buyRate1st}% ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.buyRate1st))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.minusDecide1st),
                                      size: 25,
                                      color: getColor(
                                          snapshot.data.minusDecide1st),
                                    ),
                                    Text('${snapshot.data.minusDecide1st}% ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.minusDecide1st))),
                                  ]),
                            ]),
                            TableRow(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.looks_two,
                                      size: iconSize,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    Text('순위')
                                  ]),
                              Text(
                                getSelectStock(snapshot.data.selectStock,
                                    snapshot.data.otType, 1),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.buyRate2nd),
                                      size: 25,
                                      color: getColor(snapshot.data.buyRate2nd),
                                    ),
                                    Text('${snapshot.data.buyRate2nd}% ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.buyRate2nd))),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      getIcon(snapshot.data.minusDecide2nd),
                                      size: 25,
                                      color: getColor(
                                          snapshot.data.minusDecide2nd),
                                    ),
                                    Text('${snapshot.data.minusDecide2nd}% ',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: getColor(
                                                snapshot.data.minusDecide2nd))),
                                  ]),
                            ]),
                          ],
                        ),
                        SizedBox(height: 5),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text("매수예약은 종목의 시작가 대비(%)입니다.",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  letterSpacing: 2.0,
                                ))),
                        SizedBox(height: 50,),
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                            child: RaisedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.redo,
                                    size: 40.0,
                                    color: Colors.white,
                                  ),
                                  Text("ETF 종목 정보 조회",
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.white)),
                                ],
                              ),
                              color: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  new BorderRadius.circular(20.0)),
                              onPressed: () {
                                var openStandardData = snapshot.data.kspOpenPrice;
                                if(openStandardData == 'undefined' || openStandardData == null || openStandardData == 0.0){
                                  showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('[Info]'),
                                      content: Text(
                                          '시장 정보 조회를 하셔야합니다!'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('ok'.toUpperCase()),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                                }else{
                                  Navigator.of(context).push(MaterialPageRoute<Null>(
                                      fullscreenDialog: true,
                                      builder: (BuildContext context){
                                        return DibrEtfStockInfoPage(marketInfo: marketInfo);
                                      }
                                  ));
                                }
                              },
                            ),)),
                        SizedBox(height: 300),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('error!');
                  print("${snapshot.error}");
                  return Text("${snapshot.error}");
                }

                return CircularProgressIndicator();
              }),

        ]),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: FloatingActionButton.extended(
              label: Text(
                '(Ad)시장 정보 조회)',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0),
              ),
              icon: Icon(
                Icons.movie,
                size: 25,
              ),
              backgroundColor: Colors.orange,
              onPressed: () {
                print(exRtScore.abs());
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Need a StockInfo?'),
                      content: Text('Watch an Ad to get a information!'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('cancel'.toUpperCase()),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('ok'.toUpperCase()),
                          onPressed: () {
                            // TODO: Set Rewarded Ad event listener
                            RewardedVideoAd.instance.listener =
                                _onHistRewardedAdEvent;
                            Navigator.pop(context);
                            RewardedVideoAd.instance.show();
                            //RestApi_Get();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
        ));
  }
}

